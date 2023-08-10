function init()
  m.urlbase = "https://api.unsplash.com/photos/random?count=10&orientation=landscape&query="
  m.apiKey = "&client_id=" + ParseJson(ReadAsciiFile("pkg:/api_keys.json")).keys.unsplash
  m.photoTask = createObject("roSGNode", "restTask") 'Task for retrieving photos
  m.photoTask.observeField("response", "onUnsplashResponse") 'Handles photo API response
  m.top.observeField("category", "retrievePhotos") 'Retrieves photos again whenever the category is changed
  m.sliderTimer = m.top.FindNode("sliderTimer")
  m.sliderTimer.ObserveField("fire", "incrementSlide") 'Changes slide when the timer fires
  m.top.observeField("slideSpeed", "setSpeed") 'Updates the speed of the slideshow
  m.top.observeField("sliderRunning", "startSlider") 'Used to start or pause the slideshow
  m.posterGrp = m.top.FindNode("posterGrp")
  m.carouselAnim = m.top.FindNode("carouselAnim")
  m.carouselSlideAnim = m.top.FindNode("carouselSlideAnim")
  m.slideCount = 0 'These are for tracking the position to animate the slides
  m.currentPos = 0
  m.nextPos = 0
  retrievePhotos() 'Gets the initial photos with the default category
end function

' Runs the task to retrieve the photos
' Creates the url with the category
sub retrievePhotos()
  m.top.sliderRunning = false
  url = m.urlbase + m.top.category + m.apiKey
  m.photoTask.request = {"url":url}
  m.photoTask.control = "RUN"
end sub

' Handles the Unsplash API Response
sub onUnsplashResponse(obj)
  response = obj.getData()
  photoData = ParseJson(response)
  if invalid <> m.slides 'If this is a response from a category change, this if removes the old slides
    for i=0 to m.slideCount
      m.posterGrp.removeChildIndex(0)
    end for
  end if
  m.slides = []
  if "roAssociativeArray" = Type(photoData) ' This is because the API calls come in as different data formats, it's annoying but they're free
    if invalid <> photoData.error 'Checking for errors in the API response
      m.slides.push({"title": photoData.error, "filename": "pkg:/assets/images/errorSlide.png"}) ' Show the error slide and give the user feedback
    end if
  else
    for each photo in photoData 'Extracts the useful data for each photo and stores in an array
      if invalid <> photo.description 'The descriptions are often null, but the alt never is
        desc = photo.description
      else
        desc = photo.alt_description
      end if
      title = desc + chr(10) + photo.user.name
      url = photo.urls.regular
      photoParsed = {"title": title, "filename": url}
      m.slides.push(photoParsed)
    end for
  end if

  m.slideCount = m.slides.count() - 1 'Important for the animation and navigation to loop to beginning/end

  for each slide in m.slides 'Creates each slide (poster) with the array of parsed photo data
    poster = CreateObject("roSGNode", "Poster")
    poster.width = 1280
    poster.height = 640
    poster.loadWidth = 1280
    poster.loadHeight = 640
    poster.loadDisplayMode = "scaleToZoom" 'Needed because the API doesn't return uniform sized photos
    poster.uri = slide.filename
    m.posterGrp.appendChild(poster)
  end for
  m.top.slideTitle = m.slides[0].title 'Updates Title and Photographer on bottom section before removing the refreshOverlay
  poster.observeField("loadStatus", "photosReady") 'These photos are frustratingly large. This waits until the final photo is done loading.
end sub

' Checks to make sure the photos are actually done loading before starting the slide timer and hiding the refreshOverlay
sub photosReady(obj)
  status = obj.getData()
  if "ready" = status
    m.top.sliderRunning = true
    m.top.slidesReady = true
  end if
end sub

' Moves one slide to the right
' Is callable by the timer or the button presses
sub incrementSlide()
  if m.top.currentSlide < m.slideCount
    m.currentPos = m.nextPos
    m.nextPos = m.nextPos - 1280
    m.carouselSlideAnim.keyValue = [[m.currentPos,0],[m.nextPos,0]]
    m.top.currentSlide = m.top.currentSlide + 1
  else
    m.currentPos = m.nextPos
    m.nextPos = 0
    m.carouselSlideAnim.keyValue = [[m.currentPos,0],[m.nextPos,0]]
    m.top.currentSlide = 0
  end if
  m.carouselAnim.control = "start"
  m.top.slideTitle = m.slides[m.top.currentSlide].title
end sub

' Moves one slide to the left
' Is callable by the timer or the button presses
sub decrementSlide()
  if m.top.currentSlide > 0
    m.currentPos = m.nextPos
    m.nextPos = m.nextPos + 1280
    m.carouselSlideAnim.keyValue = [[m.currentPos,0],[m.nextPos,0]]
    m.top.currentSlide = m.top.currentSlide - 1
  else
    m.currentPos = 0
    m.nextPos = -(m.slideCount)*1280
    m.carouselSlideAnim.keyValue = [[m.currentPos,0],[m.nextPos,0]]
    m.top.currentSlide = m.slideCount
  end if
  m.carouselAnim.control = "start"
  m.top.slideTitle = m.slides[m.top.currentSlide].title
end sub

' Updates the speed of the slideshow by changing the length of time between timer fires
sub setSpeed(obj)
  speed = obj.getData()
  m.sliderTimer.duration = speed
end sub

' Toggles the timer on and off to start or pause the sliding animation
sub startSlider(obj)
  start = obj.getData()
  if start
    m.sliderTimer.control = "start"
  else
    m.sliderTimer.control = "stop"
  end if
end sub
