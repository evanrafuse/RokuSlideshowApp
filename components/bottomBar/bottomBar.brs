function init()
  weatherKey = ParseJson(ReadAsciiFile("pkg:/assets/api_keys.json")).keys.openWeather
  url = "https://api.openweathermap.org/data/2.5/weather?lat=45.3755&lon=-63.2602&appid=" + weatherKey + "&units=metric"

  ' Clock Group Styles
  m.timeLbl = m.top.FindNode("timeLbl")
  m.dateLbl = m.top.FindNode("dateLbl")
  m.dateLbl.drawingStyles = {
    default: {
      "fontUri": "pkg:/assets/fonts/Gotham-Bold.otf"
      "fontSize":25
      "color": "#FFFFFF"
    }
  }
  m.timeLbl.drawingStyles = {
    default: {
      "fontUri": "pkg:/assets/fonts/Gotham-Bold.otf"
      "fontSize":30
      "color": "#FFFFFF"
    }
  }
  ' Slide Title Styles
  m.titleLbl = m.top.FindNode("titleLbl")
  m.titleLbl.drawingStyles = {
    default: {
      "fontUri": "pkg:/assets/fonts/Gotham-Bold.otf"
      "fontSize":15
      "color": "#FFFFFF"
    }
  }
  ' Weather Group Styles
  m.weatherLbl = m.top.FindNode("weatherLbl")
  m.weatherLbl.drawingStyles = {
    default: {
      "fontUri": "pkg:/assets/fonts/Gotham-Bold.otf"
      "fontSize":26
      "color": "#FFFFFF"
    }
  }

  m.weatherPoster = m.top.FindNode("weatherPoster")
  m.weatherTask = createObject("roSGNode", "restTask")
  m.weatherTask.observeField("response", "onWeatherResponse")
  m.weatherTask.request = {"url":url}
  updateWeather() 'Retrieves weather info on app launch

  m.clockTimer = m.top.FindNode("clockTimer")
  m.clockTimer.ObserveField("fire", "clockPing") 'Updates the label showing the time
  m.clockTimer.control = "start"
  clockPing() 'Sets the time initially on app launch
end function

'Updates the title and photographer shown for the current slide
sub titleChanged(obj)
  title = obj.getData()
  m.titleLbl.text = title
end sub

' Updates the date and time shown
sub clockPing()
  clock = CreateObject("roDateTime")
  clock.ToLocalTime()
  m.dateLbl.text = clock.asDateStringLoc("EEEE, MMMM d")
  m.timeLbl.text = clock.asTimeStringLoc("h:mm a")
end sub

' Retrieves up to date weather data
sub updateWeather()
  m.weatherTask.control = "RUN"
end sub

' Handles the response from the openWeather API
sub onWeatherResponse(obj)
  response = obj.getData()
  weatherData = ParseJson(response)
  temp = Str(Cint(weatherData.main.temp)) + Chr(176) + "C"
  conditions = weatherData.weather[0].main
  icon = weatherData.weather[0].icon
  m.weatherLbl.text = temp + chr(10) + conditions
  m.weatherPoster.uri = "https://openweathermap.org/img/wn/" + icon + "@2x.png" 'Shows the weather icon
  m.top.weatherReady = true 'Hides the refreshOverlay when weather data is ready
end sub