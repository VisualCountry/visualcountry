namespace :users do
  task clean_tokens: [:environment] do
    User.find_each do |user|
      next unless user.facebook_token_expiration

      if user.facebook_token_expiration < Time.now
        puts "Cleaning Facebook token for #{user.name}"

        user.update(
          facebook_token: nil,
          facebook_token_expiration: nil
        )

        TokenExpiredMailer.reauth_facebook(user).deliver
      end
    end
  end
end
