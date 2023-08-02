function init()
  m.refreshPoster = m.top.FindNode("refreshPoster")
  m.refreshAnimIn = m.top.FindNode("refreshAnimIn")
  m.refreshSlideAnim = m.top.FindNode("refreshSlideAnim")
  m.refreshAnimOut = m.top.FindNode("refreshAnimOut")
  m.refreshFadeAnim = m.top.FindNode("refreshFadeAnim")
  m.refreshWaitTimer = m.top.FindNode("refreshWaitTimer")
end function

sub slideIn()
  m.refreshPoster.translation = [0, -720]
  m.refreshPoster.opacity = 1.0
  m.refreshAnimIn.control = "start"
  m.refreshWaitTimer.ObserveField("fire", "fadePing")
  m.refreshWaitTimer.control = "start"
end sub

sub fadeOut()
  m.refreshAnimOut.control = "start"
end sub

