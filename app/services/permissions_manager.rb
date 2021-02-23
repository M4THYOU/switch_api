require 'db_enums'
# Responsible for making updates and changes to the DB while checking for correct permissions.
module PermissionsManager

    class << self
        # Family methods
        def get_families(user)
            Family.joins(family_group: :u_roles).where(
                'u_roles.user_id' => user.id,
                'u_roles.u_role_type_id' => [DbEnums::RoleType::PRIMARY_FAMILY, DbEnums::RoleType::SECONDARY_FAMILY])
        end
        def create_family(user)
            roles = user.u_roles.where(u_role_type_id: DbEnums::RoleType::PRIMARY_FAMILY)
            raise Exceptions::NoPermissionError unless roles.length == 0

            g_family = create_group(DbEnums::GroupType::FAMILY, user)
            g_shared_cluster = create_group(DbEnums::GroupType::CLUSTER, user)
            g_personal_cluster = create_group(DbEnums::GroupType::CLUSTER, user)

            family = Family.create(family_group_id: g_family.id, created_by_uid: user.id)
            Cluster.create(name: 'Shared Cluster',
                           is_shared: 1,
                           cluster_group_id: g_shared_cluster.id,
                           family_group_id: g_family.id,
                           created_by_uid: user.id)
            Cluster.create(cluster_group_id: g_personal_cluster.id,
                           family_group_id: g_family.id,
                           created_by_uid: user.id)
            create_user_role(DbEnums::RoleType::PRIMARY_FAMILY, user, g_family)
            create_user_role(DbEnums::RoleType::PRIMARY_CLUSTER, user, g_shared_cluster)
            create_user_role(DbEnums::RoleType::PRIMARY_CLUSTER, user, g_personal_cluster)
            family
        end
        def get_family_clusters(user, family_group_id)
            Cluster.joins(:family_group).joins(cluster_group: :u_roles).where(
                'u_roles.user_id' => user.id,
                'family_group.id' => family_group_id,
                'u_roles.u_role_type_id' => [DbEnums::RoleType::PRIMARY_CLUSTER, DbEnums::RoleType::SECONDARY_CLUSTER])
        end

        # Cluster methods
        def get_clusters(user)
            Cluster.joins(cluster_group: :u_roles).where('u_roles.user_id' => user.id, 'u_roles.u_role_type_id' => [DbEnums::RoleType::PRIMARY_CLUSTER]) # no sec_cluster role for now.
        end
        def get_cluster_things(user, cluster_group_id)
            # need to make sure user has the primary role in this cluster.
            roles = user.u_roles.where(u_role_type_id: DbEnums::RoleType::PRIMARY_CLUSTER, u_group_id: cluster_group_id)
            raise Exceptions::NoPermissionError if roles.length == 0
            Thing.select(:id, :aws_name, :name, :meta, :is_active, :thing_type_id).joins(:u_roles).where(
                'u_roles.u_role_type_id' => [DbEnums::RoleType::THING],
                'u_roles.u_group_id' => cluster_group_id)
        end

        # thing methods
        def activate_thing(user, params)
            name = params[:name]
            key = params[:key]
            cluster_group_id = params[:cluster_group_id]

            # check if user has permission to add to this cluster
            roles = user.u_roles.where(u_role_type_id: DbEnums::RoleType::PRIMARY_CLUSTER, u_group_id: cluster_group_id)
            raise Exceptions::NoPermissionError if roles.length == 0
            # check if thing is_active
            thing = Thing.find_by(aws_name: name)
            thing_auth = thing.authenticate(key)
            raise Exceptions::NoAuth unless thing_auth
            raise Exceptions::AlreadyActivatedError if thing.is_active != 0
            #  check if thing already has an existing role.
            thing_roles = URole.where(thing_id: thing.id, u_role_type_id: DbEnums::RoleType::THING)
            raise Exceptions::NoPermissionError unless thing_roles.length == 0

            thing.is_active = 1
            thing.save!
            group = UGroup.find(cluster_group_id)
            create_thing_role(thing, user, group)

            thing
        end
        def get_things(user)
            group_ids = user.u_roles.where(u_role_type_id: DbEnums::RoleType::PRIMARY_CLUSTER).pluck(:u_group_id)
            Thing.select(:id, :aws_name, :name, :meta, :is_active, :thing_type_id).joins(u_roles: :u_group).where('u_groups.id' => group_ids)
        end
        def has_thing_permission(user, aws_name)
            thing = Thing.find_by(aws_name: aws_name)
            role = thing.u_roles.first
            raise Exceptions::NoPermissionError unless role.u_role_type_id == DbEnums::RoleType::THING
            roles = user.u_roles.where(u_role_type_id: DbEnums::RoleType::PRIMARY_CLUSTER, u_group_id: role.u_group_id)
            raise Exceptions::NoPermissionError if roles.length == 0
        end

        ### ADMIN ONLY ###
        # params consists of (:name, :password, :meta) all strings
        def create_thing(user, params)
            raise Exceptions::NoPermissionError unless is_admin(user)
            thing_h = {
                'aws_name' => params[:name],
                'name' => params[:name],
                'password' => params[:password],
                'password_confirmation' => params[:password],
                'meta' => params[:meta],
                'thing_type_id' => params[:thing_type_id]
            }
            Thing.create!(thing_h)
        end

        private

        def create_group(group_id, user)
            group = UGroupType.find(group_id)
            group.u_groups.create(created_by_uid: user.id)
        end

        def create_user_role(role_id, user, group)
            raise Exceptions::NoPermissionError if role_id == DbEnums::RoleType::THING
            uid = user.id
            group.u_roles.create(u_role_type_id: role_id, user_id: uid, created_by_uid: uid)
        end

        # role_id is implied.
        def create_thing_role(thing, user, group)
            uid = user.id
            thing_id = thing.id
            group.u_roles.create(u_role_type_id: DbEnums::RoleType::THING, thing_id: thing_id, created_by_uid: uid)
        end

        def is_admin(user)
            roles = URole.joins(:u_group).where(
                'u_roles.user_id' => user.id,
                'u_groups.u_group_type_id' => DbEnums::GroupType::ADMIN,
                'u_role_type_id' => DbEnums::RoleType::ADMIN)
            roles.length == 1
        end

    end

end
