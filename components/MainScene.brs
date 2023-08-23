function init()

  m.slider = m.top.FindNode("slider")
  m.slider.ObserveField("slideTitle", "changeTitle") 'updates the title in the bottom section
  m.slider.ObserveField("slidesReady", "hideSplash") 'hides the screen until the pictures are ready to go

  m.bottomBar = m.top.FindNode("bottomBar")
  m.bottomBar.ObserveField("weatherReady", "hideSplash") 'hides the screen until the weather is finished updating

  m.refreshOverlay = m.top.FindNode("refreshOverlay")

  m.optionsScreen = m.top.FindNode("optionsScreen")
  m.optionsAnim = m.top.FindNode("optionsAnim")
  m.optionsSlideAnim = m.top.FindNode("optionsSlideAnim")
  m.optionsScreen.ObserveField("optionsShowing", "animateOptions") 'slides the options screen up from below
  m.optionsScreen.ObserveField("speed", "setSpeed") 'sets the length of time slides are shown
  m.optionsScreen.ObserveField("category", "setCategory") 'sets the the category of pictures to retrieve from the API

  m.refreshTimer = m.top.FindNode("refreshTimer")
  m.refreshTimer.ObserveField("fire", "refreshPing") 'Full page poster slides in and fades out to prevent burn in on screens

  m.top.setFocus(true)
end function

' Hides the splash screen with the fade animation
' Used whenever the screen is shown (startup, loadin new pictures, weather, screen refresh)
sub hideSplash()
  if m.slider.slidesReady and m.bottomBar.weatherReady
    m.refreshOverlay.callFunc("fadeOut")
    m.refreshTimer.control = "start"
  end if
end sub

' Shows the refresh poster every 30 minutes and updates the weather
sub refreshPing()
  m.bottomBar.callFunc("updateWeather")
  m.refreshOverlay.callFunc("slideIn")
end sub

' Updates the bottom section title area to match the current slide
sub changeTitle(obj)
  m.bottomBar.slideTitle = obj.getData()
end sub

'Updates the length of time slides are shown
sub setSpeed(obj)
  speed = obj.getData()
  m.slider.slideSpeed = speed
end sub

'Updates oberved field, starting a process to retrieve the new category of photos
sub setCategory(obj)
  category = obj.getData()
  m.slider.category = category
end sub

' Animates the appearance and disappearance of the options screen
sub animateOptions()
  if m.optionsScreen.optionsShowing
    m.optionsSlideAnim.keyValue = [[0,720],[0,0]]
    m.optionsAnim.control = "start"
    m.optionsScreen.callFunc("setFocus", true)
  else
    m.optionsSlideAnim.keyValue = [[0,0],[0,720]]
    m.optionsAnim.control = "start"
    m.optionsScreen.callFunc("setFocus", false)
    m.top.setFocus(true)
  end if
end sub

sub showExitDialog()
  m.exitDialog = createObject("roSGNode", "Dialog")
  m.exitDialog.backgroundUri = ""
  m.exitDialog.title = "Back Button Pressed"
  m.exitDialog.message = "Are you sure you want to exit?"
  m.exitDialog.buttons = ["Exit", "Cancel"]
  m.exitDialog.ObserveFieldScoped("buttonSelected", "handleExitDialog")
  m.top.dialog = m.exitDialog
end sub

sub handleExitDialog(event)
  btnIndex = event.getData()
  if 0 = btnIndex
    m.top.closeApp = true
  end if
  m.exitDialog.close = true
end sub

function OnKeyEvent(key, press) as Boolean
  result = false
  if press
    if "right" = key or "fastforward" = key
      m.slider.callFunc("incrementSlide") 'Move to next photo
    else if "left" = key or "rewind" = key or "replay" = key
      m.slider.callFunc("decrementSlide") 'Move to previous photo
    else if "play" = key or "OK" = key
      m.slider.sliderRunning = NOT m.slider.sliderRunning 'Pause slideshow
    else if "options" = key or "down" = key
      m.optionsScreen.optionsShowing = NOT m.optionsScreen.optionsShowing 'Show Options Screen
    else if "back" = key
      showExitDialog()
      result = true
    end if
  end if
  return result
end function