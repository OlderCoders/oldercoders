# Development user data
if Rails.env.development?

  password = 'oldercoder'

  User.create!(
    first_name:            "Michael",
    last_name:             "Bester",
    email:                 "michael@oldercoders.net",
    username:              'bester',
    role:                  'admin',
    password:              password,
    password_confirmation: password,
    activated:             true,
    activated_at:          Time.zone.now
  )

  User.create!(
    first_name:            "Hugh",
    last_name:             "Jass",
    email:                 "hugh@jass.com",
    username:              'hugh',
    role:                  'user',
    password:              password,
    password_confirmation: password,
    activated:             true,
    activated_at:          Time.zone.now
  )
end
