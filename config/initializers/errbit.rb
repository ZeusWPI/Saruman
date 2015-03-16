Airbrake.configure do |config|
  config.api_key = '751337feac897fe3c0d004b28380ce86'
  config.host    = 'zeus-errbit.ilion.me'
  config.port    = 443
  config.secure  = config.port == 443
end
