# Development user data
if Rails.env.development?

  password = 'oldercoder'

  Account.create!(
    first_name:            "Michael",
    last_name:             "Bester",
    email:                 "michael@oldercoders.net",
    username:              'bester',
    role:                  'admin',
    password:              password,
    password_confirmation: password,
  ).confirm

  Account.create!(
    first_name:            "Hugh",
    last_name:             "Jass",
    email:                 "hugh@jass.com",
    username:              'hugh',
    role:                  'user',
    password:              password,
    password_confirmation: password,
  ).confirm
end
