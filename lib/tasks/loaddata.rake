namespace :db do

  task :loaddata => :environment do
    puts "Creating account admin@iamadmin"
    User.create(
        [
            {
                business_name: 'System Administrator',
                address: 'Beam-e-up Development Team',
                name: 'Administrator',
                mobile: '',
                email: 'admin@beameup.com',
                username: 'admin',
                password: 'iamadmin',
                role_id: Role::ADMIN_USER_ID
            }
        ]
    )

    puts "Creating Store Categories........"
    Category.delete_all
    Category.create([{name: 'Restaurant'},
                     {name: 'Home Appliances'},
                     {name: 'Household Goods'},
                     {name: 'Grocery & Beverages'},
                     {name: 'Fresh Foods'}])

    puts "Creating Classified Categories........"
    Admin::ClassifiedCategory.delete_all
    Admin::ClassifiedCategory.create([{name: 'Real Estate'},
                                      {name: 'Help Wanted'},
                                      {name: 'Local Events'},
                                      {name: 'Items for Sale'},
                                      {name: 'Office Space'}])

    puts "Creating Campaign Objectives ........"
    CompaignObjective.delete_all
    CompaignObjective.create([{name: 'Increase Volume or Revenue Dollars per Sales Transaction'},
                              {name: 'Increase Customer Traffic to your Business'},
                              {name: 'Increase Sales of a Particular Item or Turnover Slower Moving Items'},
                              {name: 'Reward or Entice Past Customers to Make a New Purchase'},
                              {name: 'Last Minutes Sales of Perishable or Time Sensitive Items/Services'}])

    puts "Creating Plans ........"
    Plan.delete_all
    Plan.create([{title: 'Platinum', price: 999.00, duration: 1, expiry: Time.zone.now+30, compaigns_per_month: 'Unlimited'},
                 {title: 'Gold ', price: 499.00, duration: 1, expiry: Time.zone.now+30, compaigns_per_month: '15'},
                 {title: 'Silver', price: 399.00, duration: 1, expiry: Time.zone.now+30, compaigns_per_month: '10'},
                 {title: 'Bronze', price: 299.00, duration: 1, expiry: Time.zone.now+30, compaigns_per_month: '5'}])

  end
end