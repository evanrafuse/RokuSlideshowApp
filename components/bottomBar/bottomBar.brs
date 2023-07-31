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

  m.titleLbl = m.top.FindNode("titleLbl")

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
end function

sub titleChanged(obj)
  title = obj.getData()
  m.titleLbl.text = title
end sub

sub updateTime(timeStrings)
  m.dateLbl.text = timeStrings[0]
  m.timeLbl.text = timeStrings[1]
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
end sub