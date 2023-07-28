function init()
  m.slider = m.top.FindNode("slider")
  m.bottomBar = m.top.FindNode("bottomBar")
  m.refreshOverlay = m.top.FindNode("refreshOverlay")
  m.slideTimer = m.top.FindNode("slideTimer")
  m.clockTimer = m.top.FindNode("clockTimer")
  m.startTimer = m.top.FindNode("startTimer")

  m.slider.ObserveField("slideTitle", "changeTitle")

  m.slideTimer.ObserveField("fire", "sliderPing")
  ' m.slideTimer.control = "start"

  m.clockTimer.ObserveField("fire", "clockPing")
  m.clockTimer.control = "start"

  m.startTimer.ObserveField("fire", "startPing")
  m.startTimer.control = "start"

  m.top.setFocus(true)
end function

sub sliderPing()
  m.slider.callFunc("incrementSlide")
end sub

sub clockPing()
  m.bottomBar.callFunc("updateTime")
  m.refreshOverlay.callFunc("slideIn")
end sub

sub startPing()
  m.refreshOverlay.callFunc("fadeOut")
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
      if "start" = m.slideTimer.control
        m.slideTimer.control = "stop"
      else
        m.slideTimer.control = "start"
      end if
    else if "options" = key or "play" = key
      ' show options screen
    end if
  end if
  return result
end function