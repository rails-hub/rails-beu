namespace :data_insertion_in do
    # rake data_insertion_in:compaign_objectives
    task :compaign_objectives => :environment do
      puts "starting rake task 'Inserting Data to compaign_objectives'"
          # CompaignObjective.delete_all
          CompaignObjective.destroy_all

          CompaignObjective.create([{ name:'Increase customer traffic to your Business?'},
                         { name:'Increase Sales of a specific item or product to Liquidate a slow moving item or product?'},
                         { name:'Reward or Entice Past Customers to Make a New Purchase?'},
                         { name: 'Bundle or Upsell related items or products?'},
                         { name:'Increase Volume or Revenue Dollars per sales transaction?'}])

      puts "Ending rake task...."
        end
    end