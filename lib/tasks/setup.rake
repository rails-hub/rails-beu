namespace :db do
  desc "Erase and fill database"

  task :category => :environment do
    puts "Creating Store Categories........"
    Category.delete_all
    Category.create([
                     {name: 'Apparel: Children', logo_url: 'apparel_children_icon.png'},
                     {name: 'Apparel: Unisex', logo_url: 'unisex_icon.png'},
                     {name: 'Apparel: Women', logo_url: 'apparel_women_icon.png'},
                     {name: 'Apparel: Men', logo_url: 'apparel_men_icon.png'},
                     {name: 'Athletic Wear & Sporting Goods', logo_url: 'athletic_wear_icon.png'},
                     {name: 'Books & Music', logo_url: 'music_books_icon.png'},
                     {name: 'Cards & Gifts', logo_url: 'cards_gift_icon.png'},
                     {name: 'Department Stores', logo_url: 'department_stores_icon.png'},
                     {name: 'Electronics & Computers', logo_url: 'electronics_computers_icon.png'},
                     {name: 'Furniture', logo_url: 'furniture_icon.png'},
                     {name: 'Health & Beauty', logo_url: 'health_beauty_icon.png'},
                     {name: 'Home & Kitchen', logo_url: 'home_kitchen_icon.png'},
                     {name: 'Jewellery', logo_url: 'jewellery_icon.png'},
                     {name: 'Leather Goods & Luggage', logo_url: 'leather_goods_icon.png'},
                     {name: 'Movies', logo_url: 'movies_icon.png'},
                     {name: 'Photography', logo_url: 'photography_icon.png'},
                     {name: 'Restaurants & Food', logo_url: 'restaurants_icon.png'},
                     {name: 'Services', logo_url: 'services_icon.png'},
                     {name: 'Toys & Hobbies', logo_url: 'toys_hobbies_icon.png'}
                    ])


  end



  task :classifiedcategory => :environment do
    puts "Creating Classified Categories........"
    Admin::ClassifiedCategory.delete_all
    Admin::ClassifiedCategory.create([{name:'Real Estate'},
                                      {name:'Help Wanted'},
                                      {name:'Local Events'},
                                      {name: 'Items for Sale'},
                                      {name:'Office Space'}])
  end


  task :zones => :environment do
    Admin::Zone.delete_all
    Admin::Zone.create([{name: 'Toronto - Yonge',isactive: true},
                        {name: 'Toronto - Zone1',isactive: true},
                        {name: 'Toronto - Zone3',isactive: true}])
  end
  task :questions => :environment do
    Admin::Question.delete_all
    Admin::Question.create([{name: 'How do you feel today?',ans1: 'Happy',ans2: 'So So',ans3: 'Bad'}])
  end
  task :classifieds => :environment do
    Admin::Classified.delete_all
    Admin::Classified.create([{name: 'First Classified',classified_category_id: 1,isactive: true},
                              {name: 'Second Classified',classified_category_id: 1,isactive: true},
                              {name: 'Third Classified',classified_category_id: 2,isactive: true},
                              {name: 'Fourth Classified',classified_category_id: 2,isactive: true},
                              {name: 'Fifth Classified',classified_category_id: 3,isactive: true},])
  end
  ######################------RETAILER PORTAL------------###################################################
  task :retailers => :environment do
    User.create(
        [
            {
                business_name: '(MCS) MADNI COMPUTER SOLUTIONS',
                address: '27-D , LG , Hafeez Centre  Lahore',
                name: 'Syed Ali Saqib',
                mobile: '+92-321-4228788',
                email: 'info@madnicomputers.com',
                username: 'mcs',
                password: '123456',
                role_id: Role::SITE_USER_ID
            },
            {
                business_name: '(T.C.H) THE COMPUTERS HUT',
                address: '38 , 3rd , Hafeez Centre  Lahore',
                name: '(CEO) Muhammad Zakariya',
                mobile: '042-35879528',
                email: 'thecomputershut@gmail.com',
                username: 'tch',
                password: '123456',
                role_id: Role::SITE_USER_ID
            }
        ]
    )
  end
end