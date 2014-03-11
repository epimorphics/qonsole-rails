QonsoleRails::Engine.routes.draw do
  post 'query' => 'qonsole#create'
end
