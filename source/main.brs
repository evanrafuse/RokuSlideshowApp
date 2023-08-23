sub Main()
    ' showChannelSGScreen()
  screen = CreateObject("roSGScreen")
  port = CreateObject("roMessagePort")
  input = CreateObject("roInput")
  screen.setMessagePort(port)
  input.setMessagePort(port)
  scene = screen.CreateScene("MainScene")
  screen.show()

  scene.observeField("closeApp", port)

  while(true)
    msg = wait(0, port)
    msgType = type(msg)
    if "roSGNodeEvent" = msgType
      msgField = msg.GetField()
      msgData = msg.getData()
      if "closeApp" = msgField AND true = msgData
        return
      end if
    else if msgType = "roSGScreenEvent"
      if msg.isScreenClosed() then return
    end if
  end while
end sub
