desc "send remainder of credit card expire"

task :credit_card_expire_notification => :environment do
  users = User.joins(:credit_card_informations).where("DATE(credit_card_informations.expire_date) = ? ", DateTime.now.to_date + 7.day).uniq
  users.each { |user|  }   
end
