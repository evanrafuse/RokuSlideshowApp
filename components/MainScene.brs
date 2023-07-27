function init()
  m.sliderScreen = m.top.FindNode("sliderScreen")
  m.loadingScreen = m.top.FindNode("loadingScreen")
  m.sliderScreen.ObserveField("screenReady", "showSlider")
  m.sliderScreen.callFunc("buildSlider")
end function

sub showSlider()
  ?"TEST 1"
  m.top.setFocus(true)
  m.sliderScreen.visible = "true"
  m.loadingScreen.visible = "false"
end sub

function OnKeyEvent(key, press) as Boolean
  result = false
  if press
    ? key
    if "OK" = key
      m.sliderScreen.visible = "true"
      m.loadingScreen.visible = "false"
    end if
  end if
  return result
end function