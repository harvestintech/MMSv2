# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

UserRole.create([
    { name: "主席", created_by: "System" }, 
    { name: "副主席", created_by: "System" }, 
    { name: "司庫", created_by: "System" }, 
    { name: "秘書", created_by: "System" }, 
    { name: "理事", created_by: "System" }
])
userRole = UserRole.find_by({name: "主席"})
User.create({
    user_role: userRole,
    zh_name: "系統管理員",
    en_name: "Administrator",
    email: "harvest.intech@gmail.com",
    password: "abcd1234",
    password_confirmation: "abcd1234",
    mobile: "",
    is_actived: true
})