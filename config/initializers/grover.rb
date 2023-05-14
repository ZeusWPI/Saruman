Grover.configure do |config|
  config.options = {
    # Groves runs puppeteer under the hood which runs in a separate headless Chrome
    # It thus needs an absolute URL as it won't be able to resolve anything relatively defined
    display_url: "#{Rails.env.development? ? "http://" : "https://"}#{Rails.configuration.action_mailer.default_url_options[:host]}",
  }
end
