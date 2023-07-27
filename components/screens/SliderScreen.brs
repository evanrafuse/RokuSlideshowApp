function init()
  m.slider = m.top.FindNode("slider")
  m.bottomBar = m.top.FindNode("bottomBar")
  m.slideTimer = m.top.FindNode("slideTimer")
  m.clockTimer = m.top.FindNode("clockTimer")

  m.slider.ObserveField("slideTitle", "changeTitle")

  m.slideTimer.ObserveField("fire", "sliderPing")
  ' m.slideTimer.control = "start"

  m.clockTimer.ObserveField("fire", "clockPing")
  ' m.clockTimer.control = "start"

end function

sub buildSlider()
  m.slider.callFunc("getSlides")
  m.top.screenReady = true
end sub

sub sliderPing()
  m.slider.callFunc("incrementSlide")
end sub

sub clockPing()
  m.bottomBar.callFunc("updateTime")
end sub

sub changeTitle(obj)
  m.bottomBar.slideTitle = obj.getData()
end sub

function OnKeyEvent(key, press) as Boolean
  result = false
  if press
    ? key
  end if
  return result
end function