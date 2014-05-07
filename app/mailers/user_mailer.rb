class UserMailer < ActionMailer::Base
 default :from => "beemup1@gmail.com"

  def registration_confirmation(user)
    @user=user
    mail(:to => user.email, :subject => "beam-e-up registration details.")
  end
  def credit_card_remainder(user)
    @user = user
    mail(:to => user.email, :subject => "beam-e-up credit card expiry.")
  end
end
