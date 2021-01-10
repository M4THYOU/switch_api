# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_10_192540) do

  create_table "clusters", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: true, null: false
    t.datetime "created_on", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "created_by_uid", null: false
    t.bigint "u_group_id", null: false
    t.index ["u_group_id"], name: "index_clusters_on_u_group_id"
  end

  create_table "thing_clusters", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "thing_id", null: false
    t.bigint "cluster_id", null: false
    t.index ["cluster_id"], name: "index_thing_clusters_on_cluster_id"
    t.index ["thing_id"], name: "index_thing_clusters_on_thing_id"
  end

  create_table "things", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "aws_name", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.text "meta", null: false
    t.index ["aws_name"], name: "index_things_on_aws_name", unique: true
  end

  create_table "u_group_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "group_type", null: false
    t.text "desc"
  end

  create_table "u_groups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "u_group_type_id", null: false
    t.text "desc"
    t.datetime "created_on", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "created_by_uid", null: false
    t.index ["u_group_type_id"], name: "index_u_groups_on_u_group_type_id"
  end

  create_table "u_role_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "role_type", null: false
    t.text "desc"
  end

  create_table "u_roles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "u_role_type_id", null: false
    t.bigint "u_group_id", null: false
    t.integer "uid", null: false
    t.datetime "created_on", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "created_by_uid", null: false
    t.datetime "expires_on"
    t.boolean "is_revoked", default: false
    t.datetime "revoked_on"
    t.integer "revoked_by_uid"
    t.index ["u_group_id"], name: "index_u_roles_on_u_group_id"
    t.index ["u_role_type_id"], name: "index_u_roles_on_u_role_type_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "confirm_token"
    t.boolean "is_invited", default: false, null: false
    t.boolean "is_active", default: false, null: false
    t.datetime "created_on", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["confirm_token"], name: "index_users_on_confirm_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "clusters", "u_groups"
  add_foreign_key "thing_clusters", "clusters"
  add_foreign_key "thing_clusters", "things"
  add_foreign_key "u_groups", "u_group_types"
  add_foreign_key "u_roles", "u_groups"
  add_foreign_key "u_roles", "u_role_types"
end
