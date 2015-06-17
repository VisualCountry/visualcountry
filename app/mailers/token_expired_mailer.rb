class TokenExpiredMailer < ActionMailer::Base
  default from: 'No Reply <noreply@visualcountry.com>'

  def reauth_facebook(user)
    @user = user
    mail(to: user.email, subject: 'Action Needed: Account Token Expired')
  end
end
