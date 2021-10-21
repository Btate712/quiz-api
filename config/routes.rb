Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'auth/register', to: 'users#register'

  post 'auth/login', to: 'users#login'
  get 'test', to: 'users#test'

  post 'quiz', to: 'quizzes#create'

  get '/', to: 'users#root'

  get 'questions/test', to: 'questions#test'

  post 'questions/batch', to: 'questions#batch_create'

  get '/users/me', to: 'users#get_user'

  resources :questions do
    resources :comments, only: [:index, :create]
  end
  
  resources :user_projects, :project_topics, only: [:create]
  resources :topics, :comments, :user_topics
  resources :encounters, only: [:create, :show]
  resources :projects, :users, only: [:index]

end
