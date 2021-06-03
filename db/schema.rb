# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_03_084906) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_accounts", force: :cascade do |t|
    t.string "bank_name", null: false
    t.string "account_no"
    t.text "remark"
    t.datetime "bank_created_at"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "case_categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "desc"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "case_files", force: :cascade do |t|
    t.bigint "case_id", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.bigint "file_file_size"
    t.datetime "file_updated_at"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["case_id"], name: "index_case_files_on_case_id"
  end

  create_table "case_meetings", force: :cascade do |t|
    t.bigint "case_id", null: false
    t.datetime "meet_at"
    t.string "location"
    t.text "desc"
    t.string "status", default: "New"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["case_id"], name: "index_case_meetings_on_case_id"
  end

  create_table "cases", force: :cascade do |t|
    t.bigint "case_categorie_id", null: false
    t.string "ref_no", null: false
    t.datetime "request_at"
    t.string "client_name"
    t.string "client_phone"
    t.string "client_email"
    t.text "desc"
    t.string "follow_by"
    t.string "status", default: "New"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["case_categorie_id"], name: "index_cases_on_case_categorie_id"
    t.index ["ref_no"], name: "index_cases_on_ref_no"
  end

  create_table "claim_payments", force: :cascade do |t|
    t.bigint "payment_id", null: false
    t.bigint "claim_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["claim_id"], name: "index_claim_payments_on_claim_id"
    t.index ["payment_id"], name: "index_claim_payments_on_payment_id"
  end

  create_table "claims", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "payment_type_id", null: false
    t.string "paid_to"
    t.string "paid_by"
    t.datetime "paid_at"
    t.string "apply_by"
    t.datetime "apply_at"
    t.string "approved_by"
    t.datetime "approved_at"
    t.string "receipt_ref"
    t.datetime "receipt_date"
    t.string "receipt_file_name"
    t.string "receipt_content_type"
    t.bigint "receipt_file_size"
    t.datetime "receipt_updated_at"
    t.text "reason"
    t.decimal "amount", precision: 18, scale: 2
    t.string "status", default: "New"
    t.text "remark"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payment_type_id"], name: "index_claims_on_payment_type_id"
    t.index ["user_id"], name: "index_claims_on_user_id"
  end

  create_table "member_cases", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "case_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["case_id"], name: "index_member_cases_on_case_id"
    t.index ["member_id"], name: "index_member_cases_on_member_id"
  end

  create_table "member_histories", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.string "zh_first_name"
    t.string "zh_last_name"
    t.string "en_first_name"
    t.string "en_last_name"
    t.string "phone"
    t.string "email"
    t.string "work_phone"
    t.string "fax"
    t.string "hkid"
    t.string "gender"
    t.string "birth_year"
    t.string "birth_month"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "zip_code"
    t.string "post_address1"
    t.string "post_address2"
    t.string "post_city"
    t.string "post_state"
    t.string "post_country"
    t.string "post_zip_code"
    t.string "company"
    t.string "company_address"
    t.string "department"
    t.string "position"
    t.string "employment_type"
    t.datetime "apply_at"
    t.string "status", default: "New"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id"], name: "index_member_histories_on_member_id"
  end

  create_table "member_notifications", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.string "notify_type"
    t.text "notify_desc"
    t.datetime "notify_at"
    t.string "status", default: "New"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id"], name: "index_member_notifications_on_member_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "zh_first_name"
    t.string "zh_last_name"
    t.string "en_first_name"
    t.string "en_last_name"
    t.string "phone"
    t.string "email"
    t.string "work_phone"
    t.string "fax"
    t.string "hkid"
    t.string "gender"
    t.string "birth_year"
    t.string "birth_month"
    t.string "birth_date"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "zip_code"
    t.string "post_address1"
    t.string "post_address2"
    t.string "post_city"
    t.string "post_state"
    t.string "post_country"
    t.string "post_zip_code"
    t.string "company"
    t.string "company_address"
    t.string "department"
    t.string "position"
    t.string "employment_type"
    t.boolean "is_deleted", default: false
    t.datetime "apply_at"
    t.string "status", default: "New"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "membership_snapshots", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "membership_id", null: false
    t.string "zh_first_name"
    t.string "zh_last_name"
    t.string "en_first_name"
    t.string "en_last_name"
    t.string "phone"
    t.string "email"
    t.string "work_phone"
    t.string "fax"
    t.string "hkid"
    t.string "gender"
    t.string "birth_year"
    t.string "birth_month"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "zip_code"
    t.string "post_address1"
    t.string "post_address2"
    t.string "post_city"
    t.string "post_state"
    t.string "post_country"
    t.string "post_zip_code"
    t.string "company"
    t.string "company_address"
    t.string "department"
    t.string "position"
    t.string "employment_type"
    t.datetime "apply_at"
    t.string "status", default: "New"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id"], name: "index_membership_snapshots_on_member_id"
    t.index ["membership_id"], name: "index_membership_snapshots_on_membership_id"
  end

  create_table "membership_transactions", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.bigint "transaction_id"
    t.string "receipt_ref"
    t.string "receipt_file_name"
    t.string "receipt_content_type"
    t.bigint "receipt_file_size"
    t.datetime "receipt_updated_at"
    t.string "document_file_name"
    t.string "document_content_type"
    t.bigint "document_file_size"
    t.datetime "document_updated_at"
    t.string "payment_method"
    t.string "confirm_by"
    t.datetime "confirm_at"
    t.decimal "amount", precision: 18, scale: 2
    t.text "remark"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["membership_id"], name: "index_membership_transactions_on_membership_id"
    t.index ["transaction_id"], name: "index_membership_transactions_on_transaction_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.string "membership_ref", limit: 10, null: false
    t.string "approved_by"
    t.datetime "approved_at"
    t.string "year"
    t.datetime "expired_at"
    t.string "status", default: "New"
    t.text "remark"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id"], name: "index_memberships_on_member_id"
    t.index ["membership_ref"], name: "index_memberships_on_membership_ref"
  end

  create_table "payment_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "desc"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "payment_type_id", null: false
    t.string "paid_to"
    t.datetime "paid_at"
    t.string "approved_by"
    t.datetime "approved_at"
    t.string "handled_by"
    t.datetime "handled_at"
    t.string "receipt_ref"
    t.datetime "receipt_date"
    t.string "receipt_file_name"
    t.string "receipt_content_type"
    t.bigint "receipt_file_size"
    t.datetime "receipt_updated_at"
    t.decimal "amount", precision: 18, scale: 2
    t.string "status", default: "New"
    t.text "remark"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payment_type_id"], name: "index_payments_on_payment_type_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.string "zh_first_name"
    t.string "zh_last_name"
    t.string "en_first_name"
    t.string "en_last_name"
    t.string "phone"
    t.string "email"
    t.string "work_phone"
    t.string "hkid"
    t.string "gender"
    t.string "birth_year"
    t.string "birth_month"
    t.string "birth_date"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "zip_code"
    t.string "post_address1"
    t.string "post_address2"
    t.string "post_city"
    t.string "post_state"
    t.string "post_country"
    t.string "post_zip_code"
    t.string "company"
    t.string "company_address"
    t.string "department"
    t.string "position"
    t.string "employment_type"
    t.string "employment_proof_file_name"
    t.string "employment_proof_content_type"
    t.bigint "employment_proof_file_size"
    t.datetime "employment_proof_updated_at"
    t.boolean "declare", default: false
    t.boolean "agreement", default: false
    t.string "status", default: "New"
    t.string "handled_by"
    t.datetime "handled_at"
    t.text "remark"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "membership_id"
    t.index ["membership_id"], name: "index_registrations_on_membership_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "bank_account_id", null: false
    t.datetime "trans_at"
    t.string "trans_type"
    t.text "trans_desc"
    t.decimal "amount", precision: 18, scale: 2
    t.string "handled_by"
    t.datetime "handled_at"
    t.string "confirm_by"
    t.datetime "confirm_at"
    t.string "bank_ref"
    t.datetime "bank_received"
    t.text "remark"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bank_account_id"], name: "index_transactions_on_bank_account_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.string "name", null: false
    t.text "desc"
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.datetime "expired_at"
    t.string "login_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_user_tokens_on_token"
    t.index ["user_id"], name: "index_user_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "user_role_id", null: false
    t.string "zh_name", null: false
    t.string "en_name", null: false
    t.string "email", null: false
    t.string "mobile"
    t.string "password_digest"
    t.boolean "is_actived", default: false
    t.boolean "is_deleted", default: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["en_name"], name: "index_users_on_en_name"
    t.index ["user_role_id"], name: "index_users_on_user_role_id"
    t.index ["zh_name"], name: "index_users_on_zh_name"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "case_files", "cases"
  add_foreign_key "case_meetings", "cases"
  add_foreign_key "cases", "case_categories", column: "case_categorie_id"
  add_foreign_key "claim_payments", "claims"
  add_foreign_key "claim_payments", "payments"
  add_foreign_key "claims", "payment_types"
  add_foreign_key "claims", "users"
  add_foreign_key "member_cases", "cases"
  add_foreign_key "member_cases", "members"
  add_foreign_key "member_histories", "members"
  add_foreign_key "member_notifications", "members"
  add_foreign_key "membership_snapshots", "members"
  add_foreign_key "membership_snapshots", "memberships"
  add_foreign_key "membership_transactions", "memberships"
  add_foreign_key "membership_transactions", "transactions"
  add_foreign_key "memberships", "members"
  add_foreign_key "payments", "payment_types"
  add_foreign_key "registrations", "memberships"
  add_foreign_key "transactions", "bank_accounts"
  add_foreign_key "user_tokens", "users"
  add_foreign_key "users", "user_roles"
end
