Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
    get "/dashboard", to: "dashboard#index"
    resources :users
  end

  unauthenticated do
    root "home#top", as: :unauthenticated_root
  end

  resource :onboarding, controller: :onboarding, only: [] do
    get   :step1
    patch :step1, action: :update_step1
    get   :step2
    patch :step2, action: :update_step2
  end

  resources :daily_records, except: [ :show ]

  resources :habits, except: [ :show ]

  resource :profile, only: [ :show ], controller: "profiles" do
    get :edit_goals
    patch :update_goals
  end

  resources :habit_checks, only: [] do
    collection do
      patch "today_tasks_update"
    end
  end
end
