# Create a settings object
Settings.instance.update!(email: 'bestuur@zeus.ugent.be', event_name: 'Zeus', organisation_name: 'Zeus WPI')

# Create an admin user
User.create!(email: 'saruman@zeus.ugent.be', password: 'thewhite', role: :admin, name: 'Saruman The White')
