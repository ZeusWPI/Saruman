# [Saruman](http://materiaal.12urenloop.be) [![Code Climate](https://codeclimate.com/github/ZeusWPI/Saruman/badges/gpa.svg)](https://codeclimate.com/github/ZeusWPI/Saruman) [![Travis CI](https://travis-ci.org/ZeusWPI/Saruman.svg)](https://travis-ci.org/ZeusWPI/Saruman) [![Coverage Status](https://coveralls.io/repos/ZeusWPI/Saruman/badge.svg?branch=master&service=github)](https://coveralls.io/github/ZeusWPI/Saruman?branch=master)

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
* Make sure Ruby 2.6.3 and Bundler 2.0 or higher are installed
* Run `bundle install`
* Run `rails s`
* Visit `http://localhost:3000`

### Deploy update to server
Push the updates to master, make sure you have SSH access to the server and just run `cap production deploy` in your local Saruman directory

### Contributors
* Tom Naessens
* Felix Van der Jeugt
* Toon Willems
* Benjamin Cousaert
