# Little Esty Shop Bulk Discount Extension

## About This Project

## Built With
  - Rails
  - Ruby
  - HTML
  - PostgreSQL

## Deployed On
 - Heroku

## Background and Description
"Little Esty Shop" Bulk Discount is an extension upon the "Little Esty Shop" group project. Bulk Discounts requires requires students to build a fictitious e-commerce platform where merchants now have functionality to create bulk discounts for their items. A bulk discount is determined upon the quantity of items the customer buys, for examply, "20% off orders of 10 or more items".

## Learning Goals
- Write migrations to create tables and relationships between tables
- Implement CRUD functionality for a resource using forms (form_tag or form_with), buttons, and links
- Use MVC to organize code effectively, limiting the amount of logic included in views and controllers
- Use built-in ActiveRecord methods to join multiple tables of data, make calculations, and group data based on one or more attributes
- Write model tests that fully cover the data logic of the application
- Write feature tests that fully cover the functionality of the application

## Set Up
- This project was built upon a pre-existing repo. The main implementation will involve the Bulk Discount merchant.
- Run These Following Steps to Run this program on local machine
- As a pre-requisite the project requires Rails 5.2.4.3 to be installed locally.
- Heres how to install Rails
```
gem install rails -v 5.2.4.3
```

- Next Clone The Repo - https://github.com/klatour324/little_esty_shop_bulk_discounts
- Then ```bundle install```
- Create The Database With ```rails db:{create, migrate}```
- Run The Rake Task With ```rake import```, This Command Loads All The CSV Files Into Your Database
- Make Sure Rails Server is Running With The Following Command: ```rails s```
- Go to ```localhost:3000``` on Browser and path ```localhost:3000/merchant/1/dashboard```

## Project Overview
### Welcome Page
-When visiting our application welcome page, it does not have direct links to direct you to the admin or the merchant. In the future, we would like to add these to make it more user friendly and could allow for authentication for logins for an admin or a specific merchant user.

### Dashboards
-Merchant Dashboard
Provides Link to My Discounts to see further statistics on each bulk discount for a merchant's invoices.
Visiting here will allow user to create, edit and delete a bulk discount for a merchant. A user can also visit a bulk discount show page for more details about the bulk discount. The main dashboard will also list the next US public holidays for a merchant to keep in mind should they wish to create a new discount revolving around that holiday.

-Admin Dashboard
To get to Admin Dashboard, a user can do so through the dashboard links at top left of the site.
It will show the invoices that are incomplete, and more importantly, a breakdown of the total revenue.
Will also provide the Top Five Customers in General with the Most Successful Transactions in the Database
Also provides links to a Index with all the Merchants and an Index with all Invoices

### Show Page
-Item Show Page
Displays an Item's Description and the Current Price
-Invoice Show Page
 Displays an Invoice's Status, Created On Date, and Total Revenue
 Allows for the Item Status to be Updated
 -Admin Merchant Show Page
 Displays Name of Merchant and ability to update that Name
