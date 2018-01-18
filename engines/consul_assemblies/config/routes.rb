ConsulAssemblies::Engine.routes.draw do



  resources :proposals
  resources :meetings
  resources :assemblies

  namespace :admin do

    resources :assemblies
    resources :meetings do
      get 'act', on: :member
    end
    resources :proposals

  end

end
