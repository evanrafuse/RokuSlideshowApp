function init()

  m.buttonList = m.top.FindNode("buttonList") 'The top level menu on the options screen
  m.buttonList.buttons = ["Slider Speed", "Photo Category", "Back"]
  m.buttonList.observeField("buttonFocused", "showButtons") 'Updates the visible submenu next to the top menu
  m.buttonList.observeField("buttonSelected", "focusButtons") 'Shifts focus to the selected submenu

  m.slideSpeedList = m.top.FindNode("slideSpeedList") 'For setting the duration of the slide timer
  m.slideSpeedList.observeField("checkedItem", "speedChange")

  m.categoryList = m.top.FindNode("categoryList") 'For setting the category of photos shown
  m.categoryList.observeField("checkedItem", "categoryChange")

end function

' Give focus to the top level menu
sub setFocus()
  m.buttonList.setFocus(true)
end sub

' Update which submenu is visible on the right
sub showButtons(obj)
  index = obj.getData()
  if 0 = index 'Slider Speed is focused
    m.slideSpeedList.visible = true
    m.categoryList.visible = false
  else if 1 = index 'Category is focused
    m.slideSpeedList.visible = false
    m.categoryList.visible = true
  else 'Back button is focused
    m.slideSpeedList.visible = false
    m.categoryList.visible = false
  end if
end sub

' For focusing on selected submenu or exiting options screen
sub focusButtons()
  index = m.buttonList.buttonFocused
  if 0 = index 'selected Slider speed
    m.slideSpeedList.setFocus(true)
  else if 1 = index 'selected Category
    m.categoryList.setFocus(true)
  else 'Selected back button
    m.top.optionsShowing = false
  end if
end sub

' Update observed field to change the slide timer duration
sub speedChange(obj)
  index = obj.getData()
  if 0 = index
    m.top.speed = 5
  else if 1 = index
    m.top.speed = 30
  else if 2 = index
    m.top.speed = 60
  end if
  m.buttonList.setFocus(true) 'refocus on top menu afterwards
end sub

' Update observed field to change the photo category
sub categoryChange(obj)
  index = obj.getData()
  if 0 = index
    m.top.category = "hockey"
  else if 1 = index
    m.top.category = "canada"
  else if 2 = index
    m.top.category = "dachsunds"
  end if
  m.buttonList.setFocus(true) 'refocus on top menu afterwards
end sub

function OnKeyEvent(key, press) as Boolean
  result = false
  if press
    if "back" = key 'User wants to exit screen
      m.top.optionsShowing = false
      result=true 'But not exit app
    else if "right" = key
      focusButtons() 'Alternative way to navigate to submenu other than pressing OK
    else if "left" = key
      m.buttonList.setFocus(true) 'Alternative way to navigate to top menu from submenus other than pressing back
    end if
  end if
  return result
end function
