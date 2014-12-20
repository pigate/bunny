Rails.application.routes.draw do
  resources :hearts
  resources :relationships
  resources :posts
  resources :comments
  resources :reviews
  resources :convos
  resources :suggestions
  resources :tag_types
  get 'categories' => 'tag_types#index'
  root 'static_pages#home'
  get 'about' => 'static_pages#about'
  get 'vision' => 'static_pages#vision'
  get 'help' => 'static_pages#help'
  get 'suggestion_added' => 'static_pages#suggestion_added'
  get 'not_found' => 'static_pages#not_found'
  get 'going_ons' => 'static_pages#going_ons'
  get 'box' => 'static_pages#box'
  get 'search' => 'static_pages#generic_search'

  get 'search/groups' => 'static_pages#group_search'
  get 'search/members' => 'static_pages#member_search'
  get 'search/posts' => 'static_pages#post_search'
  get 'search/recipes' => 'static_pages#recipe_search'
  
  resources :recipes
  resources :groups
  resources :group_memberships
  resources :group_posts

  devise_for :members, :controllers => { :registrations => "registrations" }
  devise_scope :member do
    get '/members/logout' => 'devise/sessions#destroy'
    get '/members/login' => 'devise/sessions#new'
    get '/members/register' => 'devise/registrations#new'
    get '/members/edit_account' => 'devise/registrations#edit'
    get '/members/delete_account' => 'devise/registrations#destroy'

  end
  resources :members

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
