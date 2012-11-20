Rails.application.routes.draw do
  resources :people do
    collection do
      get 'compile_time_error_report'
      get 'runtime_error_report'
      get 'nil_datasource'
      get 'java_parameter'
    end
  end
end
