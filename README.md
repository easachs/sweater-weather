# README

## Sweater Weather
Sweater Weather is a weather-forecast / book-lookup / roadtrip-planning application where users can register, and receive and use API keys to access search results. It consumed several APIs including two from Mapquest and one from OpenWeather in order to process and respond to JSON requests.

I really enjoyed working on this because it required exploring and combining several tools that I've learned over the last several months - from APIs, to user authentication and authorization, to robust unit and feature testing. I really love exploring and writing user functionality, and this app was my first foray into letting users create and use an API key.

* Ruby version: 2.7.4
* Rails version: 5.2.8

## Set Up
* Fork/clone this repository, enter into the main directory and run `bundle install`.
* To create user database run `rake db:{drop,create,migrate,seed}`.
* To use and test locally, run `rails server` and send JSON requests in the body using the endpoints enumerated below. All responses come in JSON.

## V1 Endpoints (and Params)
### 1. `GET /api/v1/forecast` - receive current, hourly, and daily weather info
  * query params: `location`
  * example request: `GET /api/v1/forecast?location=Barcelona`
  * example response: 
  ```
  {
    "data": {
      "id": null,
      "type": "forecast",
      "attributes": {
        "current_weather": {
          "datetime": "2020-09-30 13:27:03 -0600",
          "temperature": 79.4,
          etc
        },
        "daily_weather": [
          {
            "date": "2020-10-01",
            "sunrise": "2020-10-01 06:10:43 -0600",
            etc
          },
          {...} etc
        ],
        "hourly_weather": [
          {
            "time": "14:00:00",
            "conditions": "cloudy with a chance of meatballs",
            etc
          },
          {...} etc
        ]
      }
    }
  }
  ```
  * uses MapQuest's Geocoding API in tandem with OpenWeather's One Call API

### 2. `POST /api/v1/users` - create a user and receive an API key
  * no query params
  * required request body params: `email`, `password`, `password_confirmation`
  * example request with body: `POST /api/v1/users`
  ```
  Content-Type: application/json
  Accept: application/json

  {
    "email": "whatever@example.com",
    "password": "password",
    "password_confirmation": "password"
  }
  ```
  * example response: 
  ```
  status: 201
  body:

  {
    "data": {
      "type": "users",
      "id": "1",
      "attributes": {
        "email": "whatever@example.com",
        "api_key": "jgn983hy48thw9begh98h4539h4"
      }
    }
  }
  ```
  * an unsuccessful registration will error gracefully with a message

### 3. `POST /api/v1/sessions` - log in to recover an API key
  * no query params
  * required request body params: `email`, `password`
  * example request with body: `POST /api/v1/sessions`
  ```
  Content-Type: application/json
  Accept: application/json

  {
    "email": "whatever@example.com",
    "password": "password"
  }
  ```
  * example response: 
  ```
  status: 200
  body:

  {
    "data": {
      "type": "users",
      "id": "1",
      "attributes": {
        "email": "whatever@example.com",
        "api_key": "jgn983hy48thw9begh98h4539h4"
      }
    }
  }
  ```
  * an un successful/invalid log in will error gracefully with a message

### 4. `POST /api/v1/road_trip` - use an API key to get roadtrip information
  * no query params
  * required request body params: `origin`, `destination`, `api_key`
  * example request with body: `POST /api/v1/road_trip`
  ```
  Content-Type: application/json
  Accept: application/json

  body:

  {
    "origin": "Denver,CO",
    "destination": "Pueblo,CO",
    "api_key": "jgn983hy48thw9begh98h4539h4"
  }
  ```
  * example response: 
  ```
  {
    "data": {
      "id": null,
      "type": "roadtrip",
      "attributes": {
        "start_city": "Denver, CO",
        "end_city": "Estes Park, CO",
        "travel_time": "2 hours, 13 minutes"
        "weather_at_eta": {
          "temperature": 59.4,
          "conditions": "partly cloudy with a chance of meatballs"
        }
      }
    }
  }
  ```
  * roadtrip `weather_at_eta` is based on arrival time
  * accounts for impossible roadtrips

## Limitations
POST endpoints (`users`, `sessions`, `road_trip`) will error gracefully if there is missing data in the body of your request.

## Testing
### RSpec
To run RSpec tests run `bundle exec rspec`. Sad path and edge case testing included. Repo includes Webmock/VCR. To refresh VCR cassettes, delete `spec/fixtures/vcr_cassettes` folder and contents and run `bundle exec rspec`.

## Gem Stack
This project incorporates Ruby/Rails, RSpec, SimpleCov, Shoulda-matchers, Webmock/VCR, Rubocop, Figaro, Faraday, and Bcrypt.