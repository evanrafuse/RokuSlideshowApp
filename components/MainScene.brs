function init()
  m.slider = m.top.FindNode("slider")
  m.slider.ObserveField("slideTitle", "changeTitle")
  m.bottomBar = m.top.FindNode("bottomBar")
  m.refreshOverlay = m.top.FindNode("refreshOverlay")
  m.optionsScreen = m.top.FindNode("optionsScreen")

  m.slideTimer = m.top.FindNode("slideTimer")
  m.slideTimer.ObserveField("fire", "sliderPing")
  m.slideTimer.control = "start"

  m.top.setFocus(true)
end function

sub sliderPing()
  clock = CreateObject("roDateTime")
  clock.ToLocalTime()
  if 2 = m.slideTimer.duration
    updateClockLabel(clock)
    m.slideTimer.duration = 5
    m.refreshOverlay.callFunc("fadeOut")
    m.slideTimer.control = "start"
  end if
  if 0 = clock.GetSeconds()
    updateClockLabel(clock)
  end if
  if 30 = clock.GetMinutes() or 0 = clock.GetMinutes()
    m.slideTimer.control = "stop"
    refreshScreen()
  end if
  if m.top.playSlides
    m.slider.callFunc("incrementSlide")
  end if
end sub

sub updateClockLabel(clock)
  date = clock.asDateStringLoc("EEEE, MMMM d")
  time = clock.asTimeStringLoc("h:mm a")
  m.bottomBar.callFunc("updateTime", [date, time])
end sub

sub refreshScreen()
  m.slideTimer.duration = 2
  m.bottomBar.callFunc("updateWeather")
  m.refreshOverlay.callFunc("slideIn")
  m.slideTimer.control = "start"
end sub

sub changeTitle(obj)
  m.bottomBar.slideTitle = obj.getData()
end sub

function OnKeyEvent(key, press) as Boolean
  result = false
  if press
    if "right" = key or "fastforward" = key
      m.slider.callFunc("incrementSlide")
    else if "left" = key or "rewind" = key or "replay" = key
      m.slider.callFunc("decrementSlide")
    else if "play" = key or "OK" = key
      m.top.playSlides = NOT m.top.playSlides
    else if "options" = key or "down" = key
      ' show options screen
      ? "Show Options Screen!"
    end if
  end if
  return result
end function