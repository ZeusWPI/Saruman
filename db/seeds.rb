# Create a settings object
Settings.instance.update!(email: 'bestuur@zeus.ugent.be', event_name: 'Zeus', organisation_name: 'Zeus WPI')

# Create an admin user
User.create!(email: 'saruman@zeus.ugent.be', password: 'thewhite', role: :admin, name: 'Saruman The White')

# Create a partner
User.create!(email: 'bestuur@zeus.ugent.be', password: (0...8).map { (65 + rand(26)).chr }.join, role: :partner, name: 'Zeus WPI')

# Create an item
Item.create!(name: 'Vat Chocomelk (50l)', price: 10, deposit: 5, category: :drank)
