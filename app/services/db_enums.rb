module DbEnums
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
    # Enum mapping thing type to its ID in the db
    module ThingType
        SWITCH = 1
    end
end
