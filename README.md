

#  ClimateApp

## Tools

 Working with Application Programming Interfaces (APIs) to grab live data from the internet. 

## About this app

It is weather app. You'll be able to check the weather for the current location based on the GPS data from the iPhone as well as by searching for a city manually. However you can save favorit cities and see weather data without internet connection.

## Preview video:
https://www.youtube.com/watch?v=lu-tGB7_sUo&ab_channel=Naugh7y

## Weather Conditions
```
switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }

