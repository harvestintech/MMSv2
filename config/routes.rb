Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    scope :controller => "users", :path => "/users" do
      post "/login" => :login
      get "/profile" => :profile
      get "/" => :list
      get "/all" => :all
      get "/:item_id" => :get
      delete "/:item_id" => :delete
      post "/create" => :create
      put "/update/:item_id" => :update
      patch "/update/:item_id" => :update

    end

    scope :controller => "transactions", :path => "transactions" do
      get "/" => :list
      get "/:item_id" => :get
      post "/create" => :create
      put "/update/:item_id" => :update
      patch "/update/:item_id" => :update
    end
    scope :controller => "payment_types", :path => "payment_types" do
      get "/" => :list
      get "/all" => :all
      get "/:item_id" => :get
      # delete "/:item_id" => :delete
      post "/create" => :create
      put "/update/:item_id" => :update
      patch "/update/:item_id" => :update
    end
    
    scope :controller => "bank_accounts", :path => "bank_accounts" do
      get "/" => :list
      get "/all" => :all
      get "/:item_id" => :get
      get "/:item_id/transactions" => :get_transactions
      # delete "/:item_id" => :delete
      post "/create" => :create
      put "/update/:item_id" => :update
      patch "/update/:item_id" => :update
    end

    scope :controller => "roles", :path => "/roles" do
      get "/all" => :all
      # get "/" => :list
    end

    scope :controller => "members", :path => "/members" do
      get "/" => :list
      get "/:item_id" => :get
      get "/:item_id/memberships" => :get_memberships
      post "/create" => :create
      put "/update/:item_id" => :update
      patch "/update/:item_id" => :update
    end

    scope :controller => "memberships", :path => "/memberships" do
      get "/" => :list
      get "/:item_id" => :get
      post "/create" => :create
      put "/update/:item_id" => :update
      patch "/update/:item_id" => :update
    end

    scope :controller => "registrations", :path => "/registrations" do
      get "/" => :list
      get "/:item_id" => :get
      post "/create" => :create
      patch "/update/:item_id" => :update
    end
  end

  get '*path', to: 'application#frontend_index_html', constraints: lambda { |request|
    !request.xhr? && request.format.html?
  }
end
