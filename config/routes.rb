Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'auth/register', to: 'users#register'

  post 'auth/login', to: 'users#login'
  get 'test', to: 'users#test'

  post 'quiz', to: 'quizzes#create'

  get '/', to: 'users#root'

  post 'questions/batch', to: 'questions#batch_create'

  get '/users/me', to: 'users#get_user'

  resources :user_projects, only: [:create]
  resources :topics, :questions, :comments, :user_topics
  resources :encounters, only: [:create, :show]
  resources :projects, :users, only: [:index]
end
