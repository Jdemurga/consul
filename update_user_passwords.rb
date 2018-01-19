#!./rails runner

  encrypted_password = "$2a$10$VkVvpBhCZSHQJaS4LZEeP.DqT/DVzjBpFd.V9S1ZlJeLcyX21G0vm"

  User.all.each_with_index do |user, index|
	user.update_column(:encrypted_password, encrypted_password)
	user.update_column(:email, "pedro.leon+#{100+index}@wearestrings.com")
  end
  #User.all.collect &:accept_invitation!
  puts "Updated all users passwords in DEVELOPMENT DB"

