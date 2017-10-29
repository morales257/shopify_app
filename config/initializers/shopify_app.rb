ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = "9d3b5be0d7587a3d2b934a0200cbc5ff"
  config.secret = "70848228fe5a37a81be775c55b310c77"
  config.scope = "read_orders,read_checkouts, write_products"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
  config.webhooks = [
    {topic: 'orders/create', address:'https://e32239be.ngrok.io/webhooks/orders_create',
      format: 'json'},
    {topic: 'checkouts/create', address:'https://e32239be.ngrok.io/webhooks/checkouts_create',
      format: 'json'}
  ]
end
