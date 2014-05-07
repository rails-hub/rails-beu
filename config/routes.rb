BeemUp::Application.routes.draw do

  namespace :admin do
    resources :questions
    resources :zones
   # resources :classified_categories
    resources :classifieds
    resources :users
    resources :bases
    resources :hotspots
    resources :reports do 
      get :retailers_list, :on => :member
      get :deals_list, :on => :member
    end
  end

  resources :contactus

  resources :archive_contents
  namespace :api do namespace :v1 do
      resources :classified do
        get :get_classifieds, :on => :collection
      end
      resources :users do
        post :sign_up, :action => :create, :on => :collection
        post :update_profile, :action => :update, :on => :collection
        get :delete, :action => :delete_profile, :on => :collection
        get :profile, :on => :collection
        get :token_key, :on => :collection

      end
      resources :questions do
#        get :question, :action => :questionOfTheDay, :on => :collection
        get :question, :action => :question_of_the_day, :on => :collection
        post :answer, :action => :send_answers, :on => :collection
        
      end
#      resources :rules
      resources :target_rules
      
      resources :deals do
        get :search, :on => :collection
        get :coupons, :on => :collection
        get :my_coupons, :on => :collection
        get :last_minute_deals, :on => :collection
        get :gifts_or_seasonal_deals, :on => :collection
        get :generate_coupons, :on => :collection
      end
#      resources :redeemed_deals
      post '/redeem_coupon/redeem' => 'redeemed_deals#redeem'
      resources :stores do
        get :all , :action => :stores, :on => :collection
      end
      resources :store_categories do
        get :stores, :on => :collection
      end
      resources :categories do
        get :all , :action => :categories, :on => :collection
      end
      resources :user_categories do
        get :categories, :on => :collection
        post :save, :action => :saveUserCategories, :on => :collection

      end
      resources :user_stores do
        get :stores, :on => :collection
        post :save,  :action => :saveUserStores, :on => :collection
#        get :save,  :action => :saveUserStores, :on => :collection

      end
      
      resources :wallets do
        get :coupon,  :action => :save_coupon, :on => :collection
        get :mywallet,  :action => :my_wallet, :on => :collection
        get :redeem, :on=> :collection
      end
     
      
    end  end # /api/v1/

  
  resources :temp_images
  resources :temp_users
  resources :credit_card_informations
  resources :user_payments do
    get :change_subscription, :on=> :collection
    post :save_subscription_change, :on=> :collection
    get :renew_subscription, :on=> :collection
    post :save_renew_subscription, :on=> :collection
  end
  
  resources :subscription_details do
    get :renew_subscription, :as => :renew
  end

  resources :deals_wizards do
    get :compaign_objectives, :on => :collection, :as => :objectives
    get :set_deal_wizard, :on => :collection, :as=> :set
    get :send_data, :on => :collection
  end

  resources :target_rules do
    post :show_params, :on => :collection

  end
  match '/set_params'=> 'target_rules#parameter_setup'
  resources :campaigns

  resources :deals do
    get :compaign_params, :on=> :collection
    post :upload_img, :on=> :collection
#    post :set_preview, :on=> :collection
    get :set_preview, :on=> :collection
  end
  match 'save' => 'deals#save'
  resources :actions
  match "/users/actions" => "users#actions"
  get 'selectretailer', :to=>'users#select_retailer'

  devise_for :users , :controllers => {:registrations => "users"}    #Modified for Retailor

  devise_scope :user do
    resources :users  , :only => [:upload_pic, :index,:show,:new,:create, :edit,:update,:destroy,:switch,:switchbacktoadmin,:actions]    #Modified for Retailor
    get 'sign_in', :to=>'devise/sessions#new'
    delete 'sign_out', :to=>'devise/sessions#destroy'

    get 'switch', :to=>'users#switch'  #Modified for Retailor
    get 'switchbacktoadmin', :to=>'users#switchbacktoadmin'  #Modified for Retailor
    
  end
  root :to => "home#actions"
#  resources :users
#  

  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
