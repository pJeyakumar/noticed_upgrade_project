AhoyEmail.default_options[:message] = true
AhoyEmail.subscribers << AhoyEmail::DatabaseSubscriber.new
AhoyEmail.api = true
