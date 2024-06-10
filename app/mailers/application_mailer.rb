class ApplicationMailer < ActionMailer::Base
  include AhoyEmail::Mailer
  default from: "from@example.com"
  layout "mailer"
end
