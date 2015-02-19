Rails.application.routes.draw do
  devise_for :controllers
  devise_for :users, :controllers => { :registrations => "users/registrations",:passwords => "users/passwords" }
  devise_scope :user do 
    get "/users/reset_passwords" => "users/registrations#reset_password"
    get "/users/:id/view_profile" => "users/registrations#view_profile"
    post "/users/reset_password" => "users/registrations#reset_password"
    
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  root 'welcome#index'   
  post '/questions/:id/edit' => 'questions#edit'
  get '/questions/:id/edit' => 'questions#edit'
  post '/exams/:id/edit' => 'exams#edit'
  get '/exams/:id/edit' => 'exams#edit'
  post '/exams/:id/set_questions'=> 'exam_questions#set_questions'
  get '/exams/:id/set_questions' => 'exam_questions#set_questions'
  post '/exams/view_past_exams'=> 'exams#view_past_exams'
  get '/exams/view_past_exams'=> 'exams#view_past_exams'
  post '/exam_questions/:id/view_exam_questions'=>'exam_questions#view_exam_questions'
  get '/exam_questions/:id/view_exam_questions'=>'exam_questions#view_exam_questions'
  post '/exam_questions/:id/save_exam_questions'=>'exam_questions#save_exam_questions'
  get '/exam_questions/:id/save_exam_questions'=>'exam_questions#save_exam_questions'
  get 'exams/:id/toggle_exam_status' => 'exams#toggle_exam_status'
  post 'exams/:id/toggle_exam_status' => 'exams#toggle_exam_status'
  post '/exams/:id/view_result'=>'exams#view_result'
  get '/exams/view_result'=>'exams#view_result'
  post "/admins/add_admin" => "admins#add_admin"
  get "/admins/add_admin" => "admins#add_admin"
  get "admins/download" => "admins#download"
  post "admins/addUser" => "admins#add_users"

  

  post "/answer_sheets/:id/update_result" => "answer_sheets#update_result"
  get "/answer_sheets/:id/get_answer" => "answer_sheets#get_answer"
  post "/answer_sheets/display_test" => "answer_sheets#display_test"
  get "/answer_sheets/display_test" => "answer_sheets#display_test"
  get "/answer_sheets/result" => "answer_sheets#show_result"  
  get "/answer_sheets/start_test" => "answer_sheets#start_test"
  get "/answer_sheets/start_timer" => "answer_sheets#start_timer"
   
  resources :questions
  #resources :admins
  resources :exams
  resources :answer_sheets

  #get '*path' => 'welcome#index'

  get '/admins' => 'admins#index'
   

   resources :questions do
   	resources :answersheet
   end	

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
