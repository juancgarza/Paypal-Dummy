Rails.application.routes.draw do
  resources :payments do
    collection do
      get 'execute'
    end
  end

  resources :products do
    
    member do
      get 'buy'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
