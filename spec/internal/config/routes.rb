Rails.application.routes.draw do
  resources :people do
    collection do
      get 'compile_time_error_report'
      get 'runtime_error_report'
    end
  end
end
