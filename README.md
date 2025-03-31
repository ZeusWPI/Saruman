# [Saruman](https://materiaal.12urenloop.be)

![Saruman the white](http://25.media.tumblr.com/tumblr_m26l1xbEev1qb9ftxo1_500.gif)


Saruman is a material management tool where partners can reserve items from an inventory. There are 2 different roles: Inventory managers and partners. Inventory managers can add items to an inventory. They can create partners and assign reservable items to partners. Partners can follow a unique link to request items they can order.

At an event, they can pick up the items at a pit by scanning their own barcode with the barcode of the item.

### Current state
* Admins can add partners
* Admins can add items
* Partners can log in using a unique link
* Partners can reserve items
* Admins can approve reservations
* Admins can disapprove reservations and give feedback why
* Partners can increase the count of an approved reservation by adding a new reservation for that item
* Partners can see a short overview of their costs, admins can see general reports
* Admins can edit the reservation deadline and email in the settings page

### Roadmap
* Automize the "special requests"
* Create a check-in and check-out system for the material pit

### Local installation
* Clone this repository
* Make sure the Ruby version defined in `.ruby-version` is installed (using `asfd`, just run `asdf install`) 
* Run `bundle install`
* Run `bin/dev` to start a database docker image
* Run `bundle exec rake db:seed` to set up some basic data
* Run `bundle exec rails s` to start the Rails server
* Visit `http://localhost:3000`
* Sign in using `saruman@zeus.ugent.be` and `thewhite` as password

### Deploy update to server
* Push the updates to master
* On your own machine, in the repository, run `bundle exec cap production deploy`

### Debug on the server
* SSH into the server
* run `docker exec -it saruman_web_1 /bin/bash`
* run `RAILS_ENV=production bundle exec rails console`

### Database backup
* SSH into the server
* Exec into the docker container: run `docker exec -it saruman_db_1 /bin/bash`
* Dump the database: run `pg_dump -U postgres saruman > backup.sql`
* exit the container: `exit`
* Copy the file locally: run `docker cp saruman_db_1:/backup.sql backup.sql`

### Snippets

#### Add an admin user
```ruby
User.create!(name: 'Your name', email: 'your email', password: 'your super duper secure password', role: :admin)
```

### Docker

Before Saruman can be run the first time, the migrations need to be run on the
database, you can use the example docker-compose file and execute the following
steps:

```sh
# Start the database
docker-compose up -d mysql

# Find the ip of the database in the docker network
docker network inspect saruman_default | jq '.[0].Containers[] | select(.Name == "saruman-mysql-1") | .IPv4Address [:-3]'

# Change the host ip in the production config
vim config/database.yml

# Run the migrations
RAILS_ENV=production bundle exec rails db:migrate

# Change the host ip back to 'mysql'
vim config/database.yml

# Bring up Saruman
docker-compose up -d
```

After this, you can just use `docker-compose up -d` to run the application.

### Contributors
* Tom Naessens
* Felix Van der Jeugt
* Toon Willems
* Benjamin Cousaert
