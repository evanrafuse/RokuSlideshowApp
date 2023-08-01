function init()

  m.buttonList = m.top.FindNode("buttonList")
  m.buttonList.buttons = ["Slider Speed", "Photo Category", "Back"]
  m.buttonList.observeField("buttonFocused", "showButtons")
  m.buttonList.observeField("buttonSelected", "focusButtons")

  m.slideSpeedList = m.top.FindNode("slideSpeedList")
  m.slideSpeedList.observeField("checkedItem", "speedChange")

  m.categoryList = m.top.FindNode("categoryList")
  m.categoryList.observeField("checkedItem", "categoryChange")

end function

sub setFocus()
  m.buttonList.setFocus(true)
end sub

sub showButtons(obj)
  index = obj.getData()
  if 0 = index
    m.slideSpeedList.visible = true
    m.categoryList.visible = false
  else if 1 = index
    m.slideSpeedList.visible = false
    m.categoryList.visible = true
  else
    m.slideSpeedList.visible = false
    m.categoryList.visible = false
  end if
end sub

sub focusButtons()
  index = m.buttonList.buttonFocused
  if 0 = index
    m.slideSpeedList.setFocus(true)
  else if 1 = index
    m.categoryList.setFocus(true)
  else
    m.top.optionsShowing = false
  end if
end sub

sub speedChange(obj)
  index = obj.getData()
  if 0 = index
    m.top.speed = 5
  else if 1 = index
    m.top.speed = 30
  else if 2 = index
    m.top.speed = 60
  end if
  m.buttonList.setFocus(true)
end sub

sub categoryChange(obj)
  index = obj.getData()
  if 0 = index
    m.top.category = "hockey"
  else if 1 = index
    m.top.category = "canada"
  else if 2 = index
    m.top.category = "dachsund"
  end if
  m.buttonList.setFocus(true)
end sub

function OnKeyEvent(key, press) as Boolean
  result = false
  if press
    if "back" = key
      m.top.optionsShowing = false
      result=true
    else if "right" = key
      focusButtons()
    else if "left" = key
      m.buttonList.setFocus(true)
    end if
  end if
  return result
end function
