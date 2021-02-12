# Responsible for making updates and changes to the DB while checking for correct permissions.
module PermissionsManager
    # Enum mapping group type to its ID in the db
    module GroupType
        FAMILY = 1
        CLUSTER = 2
    end
    # Enum mapping role type to its ID in the db
    module RoleType
        PRIMARY_FAMILY = 1
        SECONDARY_FAMILY = 2
        THING = 3
        PRIMARY_CLUSTER = 4
        SECONDARY_CLUSTER = 5  # not yet implemented
    end

    class << self
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
            create_role(RoleType::PRIMARY_FAMILY, user, g_family)
            create_role(RoleType::PRIMARY_CLUSTER, user, g_shared_cluster)
            create_role(RoleType::PRIMARY_CLUSTER, user, g_personal_cluster)
            family
        end

        private

        def create_group(group_id, user)
            group = UGroupType.find(group_id)
            group.u_groups.create(created_by_uid: user.id)
        end

        def create_role(role_id, user, group)
            uid = user.id
            group.u_roles.create(u_role_type_id: role_id, user_id: uid, created_by_uid: uid)
        end

    end

end
