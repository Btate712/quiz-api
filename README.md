# Study-With-Quizzes - API Backend

Built by Bob Tate using Ruby on Rails.

This repository contains the backend API half of my Flatiron School final project. See https://github.com/Btate712/quiz-react for the frontend. 

I deployed this project for a specific group of users who use the product to study for licensing at a nuclear power plant. Since the information stored in the quiz bank for those users is proprietary and confidential, the app is not accessible to the general public at this time.

## Project Models:
The main API Models include:

* User - registered application users
* Question - multiple choice questions that can be created by users and included on quizzes
* Topic - a collection of questions on a particular subject (e.g. there might be a topic "Polymorphism" in a project "Object Oriented Programming")
* Project - a colleciton of topics, typically an entire course or field of study (e.g. there might be a CS-101 project for a CS-101 college course)
* Encounter - a unique user encounter with a question. Each time a user answers a question, the user's response is stored for future analysis.

There are also several combination models used to establish many-to-many relationships between models (e.g. ProjectTopic)

## Available Routes:
The app supports standard ReSTful routes such as:
* GET request to `(Host URL)/questions/` - returns JSON representation of all questions in the DB
* POST request to `(Host URL)/questions/` - attempts to create a new question using the request body data
* GET request to `(Host URL)/questions/(question ID)` - returns JSON representation of a single question identified by "question ID"
* PUT request to `(Host URL)/questions/(question ID)` - attempts to update the question identified by "question ID" using the request body data
* DELETE request to `(Host URL)/questions/(question ID)` - deletes the question identified by "question ID"

## To install and run the app:

* Fork and clone this repository

* Run the command `bundle install` to install dependencies

* Run migrations using the command `rails db:migrate`

* Run the app on the test server using the command `rails s`
