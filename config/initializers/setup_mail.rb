ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "beemup1",
  :password             => "zxcv@123",
  :authentication       => "plain",
  :enable_starttls_auto => true
}