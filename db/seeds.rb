# Create a settings object
Settings.instance.update!(email: 'bestuur@zeus.ugent.be', event_name: 'Zeus', organisation_name: 'Zeus WPI', event_date: Date.new(2024, 04, 24), address: 'Mijn appartement')

# Create an admin user
User.create!(email: 'saruman@zeus.ugent.be', password: 'thewhite', role: :admin, name: 'Saruman The White')

# Create a partner
zeus = Partner.create!(name: "Zeus WPI")
User.create!(email: 'bestuur@zeus.ugent.be', password: Devise.friendly_token, role: :partner, name: 'Zeus WPI User', partner: zeus)

# Create an item
Item.create!(name: 'Vat Chocomelk (50l)', price: 10, deposit: 5, category: :drank)
