QonsoleRails::Engine.routes.draw do
  root 'qonsole#index'

  post 'query' => 'qonsole#create'
  get 'query' => 'qonsole#index'
end
