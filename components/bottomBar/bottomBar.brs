function init()
  weatherKey = ParseJson(ReadAsciiFile("pkg:/assets/api_keys.json")).keys.openWeather
  url = "https://api.openweathermap.org/data/2.5/weather?lat=45.3755&lon=-63.2602&appid=" + weatherKey + "&units=metric"

  ' Clock Group
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

  ' Slide Title
  m.titleLbl = m.top.FindNode("titleLbl")
  m.titleLbl.drawingStyles = {
    default: {
      "fontUri": "pkg:/assets/fonts/Gotham-Bold.otf"
      "fontSize":15
      "color": "#FFFFFF"
    }
  }

  ' Weather Group
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
  updateWeather()

  m.clockTimer = m.top.FindNode("clockTimer")
  m.clockTimer.ObserveField("fire", "clockPing")
  m.clockTimer.control = "start"
  clockPing()
end function

sub titleChanged(obj)
  title = obj.getData()
  m.titleLbl.text = title
end sub

sub clockPing()
  clock = CreateObject("roDateTime")
  clock.ToLocalTime()
  m.dateLbl.text = clock.asDateStringLoc("EEEE, MMMM d")
  m.timeLbl.text = clock.asTimeStringLoc("h:mm a")
end sub

sub updateWeather()
  m.weatherTask.control = "RUN"
end sub

sub onWeatherResponse(obj)
  response = obj.getData()
  weatherData = ParseJson(response)
  temp = Str(Cint(weatherData.main.temp)) + Chr(176) + "C"
  conditions = weatherData.weather[0].main
  icon = weatherData.weather[0].icon
  m.weatherLbl.text = temp + chr(10) + conditions
  m.weatherPoster.uri = "https://openweathermap.org/img/wn/" + icon + "@2x.png"
  m.top.weatherReady = true
end sub