function init()
  m.refreshPoster = m.top.FindNode("refreshPoster")
  m.refreshAnimIn = m.top.FindNode("refreshAnimIn")
  m.refreshSlideAnim = m.top.FindNode("refreshSlideAnim")
  m.refreshAnimOut = m.top.FindNode("refreshAnimOut")
  m.refreshFadeAnim = m.top.FindNode("refreshFadeAnim")
  m.refreshTimer = m.top.FindNode("refreshTimer")
  m.refreshTimer.ObserveField("fire", "fadeOut")
end function

sub slideIn()
  m.refreshPoster.translation = [0, -720]
  m.refreshPoster.opacity = 1.0
  m.refreshAnimIn.control = "start"
  m.refreshTimer.control = "start"
end sub

sub fadeOut()
  m.refreshAnimOut.control = "start"
end sub

function OnKeyEvent(key, press) as Boolean
  result = false
  if press
    ? key
  end if
  return result
end function
