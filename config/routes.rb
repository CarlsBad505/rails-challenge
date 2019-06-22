Rails.application.routes.draw do

  post  'v1/api/orders/create', to: 'orders#create_order', defaults: { format: 'json' }
  get  'v1/api/orders/:order_id', to: 'orders#read_order', defaults: { format: 'json' }

end
