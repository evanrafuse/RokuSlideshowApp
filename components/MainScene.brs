function init()

  m.slider = m.top.FindNode("slider")
  m.slider.ObserveField("slideTitle", "changeTitle")
  m.slider.ObserveField("slidesReady", "hideSplash")

  m.bottomBar = m.top.FindNode("bottomBar")
  m.bottomBar.ObserveField("weatherReady", "hideSplash")

  m.refreshOverlay = m.top.FindNode("refreshOverlay")

  m.optionsScreen = m.top.FindNode("optionsScreen")
  m.optionsAnim = m.top.FindNode("optionsAnim")
  m.optionsSlideAnim = m.top.FindNode("optionsSlideAnim")
  m.optionsScreen.ObserveField("optionsShowing", "animateOptions")
  m.optionsScreen.ObserveField("speed", "setSpeed")
  m.optionsScreen.ObserveField("category", "setCategory")

  m.refreshTimer = m.top.FindNode("refreshTimer")
  m.refreshTimer.ObserveField("fire", "refreshPing")

  m.top.setFocus(true)
end function

sub hideSplash()
  if m.slider.slidesReady and m.bottomBar.weatherReady
    m.refreshOverlay.callFunc("fadeOut")
    m.refreshTimer.control = "start"
  end if
end sub

sub refreshPing()
  m.bottomBar.callFunc("updateWeather")
  m.refreshOverlay.callFunc("slideIn")
end sub

sub changeTitle(obj)
  m.bottomBar.slideTitle = obj.getData()
end sub

sub setSpeed(obj)
  speed = obj.getData()
  m.slideTimer.duration=speed
end sub

sub setCategory(obj)
  category = obj.getData()
  m.slider.category = category
end sub

sub animateOptions()
  if m.optionsScreen.optionsShowing
    m.optionsSlideAnim.keyValue = [[0,720],[0,0]]
    m.optionsAnim.control = "start"
    m.optionsScreen.callFunc("setFocus")
  else
    m.optionsSlideAnim.keyValue = [[0,0],[0,720]]
    m.optionsAnim.control = "start"
    m.top.setFocus(true)
  end if
end sub

function OnKeyEvent(key, press) as Boolean
  result = false
  if press
    if "right" = key or "fastforward" = key
      m.slider.callFunc("incrementSlide")
    else if "left" = key or "rewind" = key or "replay" = key
      m.slider.callFunc("decrementSlide")
    else if "play" = key or "OK" = key
      m.slider.sliderRunning = NOT m.slider.sliderRunning
    else if "options" = key or "down" = key
      m.optionsScreen.optionsShowing = NOT m.optionsScreen.optionsShowing
    end if
  end if
  return result
end function