# Create a main sample user
User.create!(name: "Aureliano",
			 email: "spadino@samur.ai",
			 password:              "mafalda",
			 password_confirmation: "mafalda",
			 admin: true)

# Generate a bunch of additional users
99.times do |n|
	name = Faker::Name.name
	email = "puta-#{n+1}@tumama.es"
	password = "password"
	User.create!(name: name,
				 email: email,
				 password:             password,
				 password_confirmation: password )
end