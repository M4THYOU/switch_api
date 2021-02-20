# Responsible for making updates and changes to the DB while checking for correct permissions.
module PermissionsManager
    # Enum mapping group type to its ID in the db
    module GroupType
        FAMILY = 1
        CLUSTER = 2
        ADMIN = 3
    end
    # Enum mapping role type to its ID in the db
    module RoleType
        PRIMARY_FAMILY = 1
        SECONDARY_FAMILY = 2
        THING = 3
        PRIMARY_CLUSTER = 4
        SECONDARY_CLUSTER = 5  # not yet implemented
        ANY = 6  # not actually assigned. It just means any role should be valid.
        ADMIN = 7
    end

    class << self
        # Family methods
        def get_families(user)
            Family.joins(family_group: :u_roles).where('u_roles.user_id' => user.id, 'u_roles.u_role_type_id' => [RoleType::PRIMARY_FAMILY, RoleType::SECONDARY_FAMILY])
        end
        def create_family(user)
            roles = user.u_roles.where(u_role_type_id: RoleType::PRIMARY_FAMILY)
            raise Exceptions::NoPermissionError unless roles.length == 0

            g_family = create_group(GroupType::FAMILY, user)
            g_shared_cluster = create_group(GroupType::CLUSTER, user)
            g_personal_cluster = create_group(GroupType::CLUSTER, user)

            family = Family.create(family_group_id: g_family.id, created_by_uid: user.id)
            Cluster.create(name: 'Shared Cluster',
                           is_shared: 1,
                           cluster_group_id: g_shared_cluster.id,
                           family_group_id: g_family.id,
                           created_by_uid: user.id)
            Cluster.create(cluster_group_id: g_personal_cluster.id,
                           family_group_id: g_family.id,
                           created_by_uid: user.id)
            create_user_role(RoleType::PRIMARY_FAMILY, user, g_family)
            create_user_role(RoleType::PRIMARY_CLUSTER, user, g_shared_cluster)
            create_user_role(RoleType::PRIMARY_CLUSTER, user, g_personal_cluster)
            family
        end
        def get_family_clusters(user, family_group_id)
            Cluster.joins(:family_group).joins(cluster_group: :u_roles).where(
                'u_roles.user_id' => user.id,
                'family_group.id' => family_group_id,
                'u_roles.u_role_type_id' => [RoleType::PRIMARY_CLUSTER, RoleType::SECONDARY_CLUSTER])
        end

        # Cluster methods
        def get_clusters(user)
            Cluster.joins(cluster_group: :u_roles).where('u_roles.user_id' => user.id, 'u_roles.u_role_type_id' => [RoleType::PRIMARY_CLUSTER]) # no sec_cluster role for now.
        end
        def get_cluster_things(user, cluster_group_id)
            # need to make sure user has the primary role in this cluster.
            Thing.joins
        end

        # thing methods
        def activate_thing(user, params)
            name = params[:name]
            key = params[:key]
            cluster_group_id = params[:cluster_group_id]

            # check if user has permission to add to this cluster
            roles = user.u_roles.where(u_role_type_id: RoleType::PRIMARY_CLUSTER, u_group_id: cluster_group_id)
            raise Exceptions::NoPermissionError if roles.length == 0
            # check if thing is_active
            thing = Thing.find_by(aws_name: name)
            thing_auth = thing.authenticate(key)
            raise Exceptions::NoAuth unless thing_auth
            raise Exceptions::AlreadyActivatedError if thing.is_active != 0
            #  check if thing already has an existing role.
            thing_roles = URole.where(thing_id: thing.id, u_role_type_id: RoleType::THING)
            raise Exceptions::NoPermissionError unless thing_roles.length == 0

            thing.is_active = 1
            thing.save!
            group = UGroup.find(cluster_group_id)
            role = create_thing_role(thing, user, group)
            puts role.id

            # WHY THIS NOT WORKING!? FOREIGN_KEY OR ONE TO ONE OR SOMETHING
            #

            thing
        end

        # admin only
        # params consists of (:name, :password, :meta) all strings
        def create_thing(user, params)
            raise Exceptions::NoPermissionError unless is_admin(user)
            thing_h = {
                'aws_name' => params[:name],
                'name' => params[:name],
                'password' => params[:password],
                'password_confirmation' => params[:password],
                'meta' => params[:meta] }
            Thing.create!(thing_h)
        end

        private

        def create_group(group_id, user)
            group = UGroupType.find(group_id)
            group.u_groups.create(created_by_uid: user.id)
        end

        def create_user_role(role_id, user, group)
            raise Exceptions::NoPermissionError if role_id == RoleType::THING
            uid = user.id
            group.u_roles.create(u_role_type_id: role_id, user_id: uid, created_by_uid: uid)
        end

        # role_id is implied.
        def create_thing_role(thing, user, group)
            uid = user.id
            thing_id = thing.id
            group.u_roles.create(u_role_type_id: RoleType::THING, thing_id: thing_id, created_by_uid: uid)
        end

        def is_admin(user)
            roles = URole.joins(:u_group).where(
                'u_roles.user_id' => user.id,
                'u_groups.u_group_type_id' => GroupType::ADMIN,
                'u_role_type_id' => RoleType::ADMIN)
            roles.length == 1
        end

    end

end
