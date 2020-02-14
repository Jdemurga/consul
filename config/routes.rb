Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount ConsulAssemblies::Engine => '/assemblies', as: 'assemblies'

  draw :account
  draw :admin
  draw :annotation
  draw :budget
  draw :comment
  draw :community
  draw :debate
  draw :devise
  draw :direct_upload
  draw :document
  draw :graphql
  draw :legislation
  draw :management
  draw :moderation
  draw :notification
  draw :officing
  draw :poll
  draw :proposal
  draw :related_content
  draw :tag
  draw :user
  draw :valuation
  draw :verification

  root "welcome#index"
  get "/welcome", to: "welcome#welcome"
  get '/cuentasegura', to: 'welcome#verification', as: :cuentasegura
  get "/consul.json", to: "installation#details"
  # GET-67 Usernames can include dots and needs to be shown by username
  get 'users/:id', to: 'users#show', constraints: {id: /[a-zA-Z1-9\.@]+/}


  resources :stats, only: [:index]
  resources :images, only: [:destroy]
  resources :documents, only: [:destroy]
  resources :follows, only: [:create, :destroy]
  resources :remote_translations, only: [:create]

  resource :associations, only: [:index, :new, :search] do
    collection { get :search }
  end
  # More info pages
  get "help", to: "pages#show", id: "help/index", as: "help"
  get "help/how-to-use", to: "pages#show", id: "help/how_to_use/index", as: "how_to_use"
  get "help/faq", to: "pages#show", id: "faq", as: "faq"
  get "/more_info", to: "pages#show", id: "help/more_info", as: "more_info"
  get "/associative_spaces", to: "pages#show", id: "help/codigo", as: "associative_spaces"
  get "/privacy_regulations", to: "pages#show", id: "help/privacy_regulations", as: "privacy_regulations"
  get "/proposal_evaluation", to: "pages#show", id: "help/proposal_evaluation", as: "proposal_evaluation"

  # Static pages
  get '/blog' => redirect("https://www.getafe.es/")

  namespace :admin do
    resource :associations, only: [:index, :new, :create, :edit, :update, :destroy]
    resource :volunteerings, only: [:index, :new, :create, :edit, :update, :destroy]
  end
  # more info pages
  get 'more-information', to: 'pages#show', id: 'more_info/index', as: 'more_info'
  get 'more-information/how-to-use', to: 'pages#show', id: 'more_info/how_to_use/index', as: 'how_to_use'
  get 'more-information/faq', to: 'pages#show', id: 'more_info/faq/index', as: 'faq'
  get 'more-information/participation/facts', to: 'pages#show', id: 'more_info/participation/facts', as: 'participation_facts'
  get 'more-information/participation/world', to: 'pages#show', id: 'more_info/participation/world', as: 'participation_world'

  # GET-24 Carga de resultados de 2016-06
  get 'presupuestos-participativos-2016-resultados', to: 'spending_proposals#results', as: 'participatory_budget_results'

  # GET-17
  # GET-22
  get 'presupuestos-participativos-2017', to: 'pages#show', id: 'participatory_budget/in_two_minutes', as: 'participatory_budget/in_two_minutes'
  get 'normativa-presupuestos-participativos-2018', to: 'pages#show', id: 'normativa_presupuestos_participativos_2018', as: 'normativa-presupuestos-participativos-2018'
  get 'participatory_budget', to: 'spending_proposals#welcome', as: 'participatory_budget'
  get 'informacion-detallada-participa-getage', to: 'pages#show', as: 'mode_information', id: 'more_information'
  get 'informacion-detallada-participa-getage-pptos-participativo-2017', to: 'pages#show', as: 'mode_information_2017', id: 'more_information_2017'
  get 'comisiones-de-barrio', to: 'pages#show', as: 'about_neighborhood_commissions', id: 'about_neighborhood_commissions'

  #Espacios Asociativos
  get 'associative_spaces', to: 'associations#index'
  get 'searchAssociations', to: 'associations#search'
  get 'showAssociations', to: 'associations#show'
  get 'newAssociations', to: 'associations#new'
  post 'createAssociations', to: 'associations#create'

  #Voluntariado
  get 'volunteerings', to: 'volunteerings#home'
  #Admin routes
  #  associations
  get 'admin/associations', to: 'admin/associations#index'
  post 'associationEdit', to: 'admin/associations#update'
  #   volunteering
  get 'admin/volunteerings', to: 'admin/volunteerings#index'
  post 'volunteeringEdit', to: 'admin/volunteerings#update'
  post 'volunteeringSave', to: 'admin/volunteerings#create'


  get 'plan-municipal-accesibilidad-getafe',
      to: 'pages#show',
      as: 'plan-municipal-accesibilidad-getafe',
      id: 'plan_municipal_de_la_accesibilidad_de_getafe'

  get 'participacion-consulta-pleno-del-estado-del-municipio',
      to: 'pages#show',
      as: 'participacion-consulta-pleno-del-estado-del-municipio',
      id: 'participacion_consulta_pleno_del_estado_del_municipio'

  get 'reglamento-cesiones-locales-municipales',
      to: 'pages#show',
      as: 'reglamento-cesiones-locales-municipales',
      id: 'reglamento_cesiones_locales_municipales'

  get 'ordenanza-reguladora-adjudicacion-terrenos-municipales',
      to: 'pages#show',
      as: 'ordenanza-reguladora-adjudicacion-terrenos-municipales',
      id: 'ordenanza_reguladora_adjudicacion_terrenos_municipales'

  resources :pages, path: "/", only: [:show]
end
