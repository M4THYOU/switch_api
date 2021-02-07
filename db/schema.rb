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

ActiveRecord::Schema.define(version: 2021_02_07_152300) do

  create_table "jwt_denylists", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp"
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
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
    t.boolean "is_invited", default: false, null: false
    t.datetime "created_on", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "email", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "u_groups", "u_group_types"
  add_foreign_key "u_roles", "u_groups"
  add_foreign_key "u_roles", "u_role_types"
end
