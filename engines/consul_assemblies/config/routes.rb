ConsulAssemblies::Engine.routes.draw do



  resources :proposals
  resources :meetings
  resources :assemblies

  namespace :admin do

    resources :assemblies
    resources :meetings
    resources :proposals

  end

end
