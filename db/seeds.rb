

puts "Creating account admin@iamadmin"
User.create(
   [
       {
           :business_name => 'System Administrator',
           :address => 'Beam-e-up Development Team',
           :name => 'Administrator',
           :mobile => '',
           :email => 'admin@beameup.com',
           :username => 'admin',
           :password => 'iamadmin',
           :role_id => Role::ADMIN_USER_ID
       }
   ]
)





puts "Creating Campaign Objectives ........"
CompaignObjective.delete_all
CompaignObjective.create([{:name => 'Increase Volume or Revenue Dollars per Sales Transaction'},
                          {:name => 'Increase Customer Traffic to your Business'},
                          {:name => 'Increase Sales of a Particular Item or Turnover Slower Moving Items'},
                          {:name => 'Reward or Entice Past Customers to Make a New Purchase'},
                          {:name => 'Last Minutes Sales of Perishable or Time Sensitive Items/Services'}])

puts "Creating Plans ........"
Plan.delete_all
Plan.create([{:title => 'Platinum',:price => 999.00, :duration => 1,:expiry => Time.zone.now+30,:compaigns_per_month => 'Unlimited',:plan_type => 's'},
             {:title => 'Gold ',   :price => 499.00,:duration => 1,:expiry => Time.zone.now+30,:compaigns_per_month => '15',:plan_type => 's'},
             {:title => 'Silver',  :price => 399.00,:duration => 1,:expiry => Time.zone.now+30,:compaigns_per_month =>  '10',:plan_type => 's'},
             {:title => 'Bronze',  :price => 299.00,:duration => 1,:expiry => Time.zone.now+30,:compaigns_per_month =>  '5',:plan_type => 's'},
             {:title => 'Platinum',:price => 1099.00,:duration => 1,:expiry => Time.zone.now+30,:compaigns_per_month =>  'Unlimited',:plan_type => 'f'},
             {:title => 'Gold ',   :price => 569.00,:duration => 1,:expiry => Time.zone.now+30,:compaigns_per_month =>  '15',:plan_type => 'f'},
             {:title => 'Silver',  :price => 449.00,:duration => 1,:expiry => Time.zone.now+30,:compaigns_per_month =>  '10',:plan_type => 'f'},
             {:title => 'Bronze',  :price => 349.00,:duration => 1,:expiry => Time.zone.now+30,:compaigns_per_month =>  '5',:plan_type => 'f'}
           ])