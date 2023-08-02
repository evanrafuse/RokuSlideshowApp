function init()
  m.urlbase = "https://api.unsplash.com/photos/random?count=10&orientation=landscape&query="
  m.apiKey = "&client_id=" + ParseJson(ReadAsciiFile("pkg:/assets/api_keys.json")).keys.unsplash
  m.photoTask = createObject("roSGNode", "restTask")
  m.photoTask.observeField("response", "onUnsplashResponse")
  m.top.observeField("category", "retrievePhotos")
  m.sliderTimer = m.top.FindNode("sliderTimer")
  m.sliderTimer.ObserveField("fire", "incrementSlide")
  m.top.observeField("slideSpeed", "setSpeed")
  m.top.observeField("sliderRunning", "startSlider")
  m.posterGrp = m.top.FindNode("posterGrp")
  m.carouselAnim = m.top.FindNode("carouselAnim")
  m.carouselSlideAnim = m.top.FindNode("carouselSlideAnim")
  m.slideCount = 0
  m.currentPos = 0
  m.nextPos = 0
  retrievePhotos()
end function

sub retrievePhotos()
  m.top.sliderRunning = false
  url = m.urlbase + m.top.category + m.apiKey
  m.photoTask.request = {"url":url}
  m.photoTask.control = "RUN"
end sub

sub onUnsplashResponse(obj)
  response = obj.getData()
  photoData = ParseJson(response)
  if invalid <> m.slides
    for i=0 to m.slideCount
      m.posterGrp.removeChildIndex(0)
    end for
  end if
  m.slides = []
  for each photo in photoData
    if invalid <> photo.description
      desc = photo.description
    else
      desc = photo.alt_description
    end if
    title = desc + chr(10) + photo.user.name
    url = photo.urls.regular
    photoParsed = {"title": title, "filename": url}
    m.slides.push(photoParsed)
  end for

  m.slideCount = m.slides.count() - 1

  for each slide in m.slides
    poster = CreateObject("roSGNode", "Poster")
    poster.width = 1280
    poster.height = 640
    poster.loadWidth = 1280
    poster.loadHeight = 640
    poster.loadDisplayMode = "scaleToZoom"
    poster.uri = slide.filename
    m.posterGrp.appendChild(poster)
  end for
  m.top.slideTitle = m.slides[0].title
  poster.observeField("loadStatus", "photosReady")
end sub

sub photosReady(obj)
  status = obj.getData()
  if "ready" = status
    m.top.sliderRunning = true
    m.top.slidesReady = true
  end if
end sub

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

sub setSpeed(obj)
  speed = obj.getData()
  m.sliderTimer.duration = speed
end sub

sub startSlider(obj)
  start = obj.getData()
  if start
    m.sliderTimer.control = "start"
  else
    m.sliderTimer.control = "stop"
  end if
end sub
