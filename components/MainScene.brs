function init()
  ? "IN MAINSCENE: Initiating Main Secene"
  m.slider = m.top.FindNode("slider")
  m.bottomBar = m.top.FindNode("bottomBar")
  m.slideTimer = m.top.FindNode("slideTimer")

  m.slider.ObserveField("slideTitle", "changeTitle")

  m.slideTimer.ObserveField("fire", "changeSlide")
  m.slideTimer.control = "start"

  m.top.setFocus(true)
end function

sub changeSlide()
  m.slider.callFunc("incrementSlide")
end sub

sub changeTitle(obj)
  wut = obj.getData()
  ? "slideTitle is: "; wut
end sub

function OnKeyEvent(key, press) as Boolean
  result = false
  if press
    ? key
  end if
  return result
end function