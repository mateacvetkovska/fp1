# FOOD POWER DOCUMENTATION 
## Description:

Food Power is a mobile platform that is designed to offer users the possibility to order different types of meals for a desired day, from their workplace or home. The main mission of this mobile platform is the well-being and happiness of the company's employees.

## Features:

User registration and login: creating a user profile with personal information and logging in with the same profile;

Choice of meals: Users have the option to browse through different meals offered by the restaurant;

Reviews and feedbacks: users have the opportunity to leave a review about the meal and the service, in order to improve the services;

## Installation and start guide:

First of all, installation of Flutter SDK, Dart SDK, Android Studio or Visual Studio Code is required. Then with the git clone command on the repository, we download the project to the computer. The project is opened with a compatible IDE: Android Studio or Visual Studio Code.

## Used technologies:

For the frontend part, we use Flutter, a cross-platform tool that ensures a unified experience for Android and iOS devices. Firebase is used for authentication, for database management - sqlite, and Dart - a programming language used to code Flutter apps. For the maps, we used geolocator and flutter_map dependencies by Flutter. The plugin Image Picker is used for taking and uploading pictures.
## Folder structure:

The lib folder contains the following folders: assets, controllers, database, models, services, views and widgets.
The folder models contains the Dart classes for the models (item, order, review), assets contains the images for the platform, database folder contains the database needed for the platform, services contains the user authentication, controllers contains the business logic for the shopping cart and views contains the screens for the following pages: About Us, Shopping Cart, DateTime, Checkout, Food Menu, Food Delivery, Login, Item Detail, Map, Sign Up, Review, Summary and the User Page. The folder widgets contains components that are reused in the platform like the Add To Cart button, Custom Card, Food Item Cart and the buttons for quantity selection.

## Databases:

In the platform, the following databases are used:

catalog: (id TEXT PRIMARY KEY, name TEXT, description TEXT, price REAL, imageUrl TEXT, rating REAL);

cart_items: (id TEXT PRIMARY KEY, catalogId TEXT, userId TEXT, quantity INTEGER, FOREIGN KEY (catalogId) REFERENCES catalog (id));

orders: (id INTEGER PRIMARY KEY AUTOINCREMENT, userId TEXT, totalPrice REAL, deliveryAddress TEXT, deliveryFee REAL, dateTime TEXT, isPickup INTEGER);

reviews: (id INTEGER PRIMARY KEY AUTOINCREMENT, userId TEXT, orderId INTEGER, photoPath TEXT, reviewText TEXT, FOREIGN KEY (orderId) REFERENCES orders(id));