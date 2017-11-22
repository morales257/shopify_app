ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = ENV['API_KEY']
  config.secret = EBV['SECRET']
  config.scope = "read_orders,read_checkouts, write_products"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
  config.webhooks = [
    {topic: 'orders/create', address:'https://e32239be.ngrok.io/webhooks/orders_create',
      format: 'json'},
    {topic: 'checkouts/update', address:'https://e32239be.ngrok.io/webhooks/checkouts_update',
      format: 'json'}
  ]
end
