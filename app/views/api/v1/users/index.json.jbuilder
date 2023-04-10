json.total_user @users&.count
json.users @users do |user|
  json.id user&.id
  json.name user&.name
  json.email user&.email
  json.admin user&.admin
  json.created_at user&.created_at
  json.updated_at user&.updated_at
end
