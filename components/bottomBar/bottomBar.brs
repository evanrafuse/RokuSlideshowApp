function init()
  m.timeLbl = m.top.FindNode("timeLbl")
  m.titleLbl = m.top.FindNode("titleLbl")
  m.weatherLb = m.top.FindNode("weatherLbl")
  updateTime()
  updateWeather()
end function

sub titleChanged(obj)
  title = obj.getData()
  m.titleLbl.text = title
end sub

sub updateTime()
  clock = CreateObject("roDateTime")
  clock.ToLocalTime()
  date = clock.asDateStringLoc("EEEE, MMMM d")
  time = clock.asTimeStringLoc("h:mm a")
  m.timeLbl.text = date + chr(10) + time
  if "00" = clock.asTimeStringLoc("mm")
    updateWeather()
  end if
end sub

sub updateWeather()
  ? "update weather!"
end sub