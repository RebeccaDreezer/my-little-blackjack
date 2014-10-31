user = User.new(name: "rebecca", email: "rebecca@rebecca.com", password: "reb", password_confirmation: "reb")
user.save

UserStat.create(user_id: user.id)
