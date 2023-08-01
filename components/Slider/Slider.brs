function init()
  m.posterGrp = m.top.FindNode("posterGrp")
  m.carouselAnim = m.top.FindNode("carouselAnim")
  m.carouselSlideAnim = m.top.FindNode("carouselSlideAnim")
  m.slideCount = 0
  m.currentPos = 0
  m.nextPos = 0
  getSlides()
end function

sub getSlides()
  ' local files
  jsonAsString = ReadAsciiFile("pkg:/assets/slidelist.json")
  m.slides = ParseJson(jsonAsString).slides
  m.slideCount = m.slides.count() - 1

  ' remote files
  ' New Get Photos
  ' m.apiKey = "&client_id=" + ParseJson(ReadAsciiFile("pkg:/assets/api_keys.json")).keys.unsplash
  ' m.urlbase = https://api.unsplash.com/search/photos?query=
  ' example - https://api.unsplash.com/search/photos?query=hockey&client_id=SL54WEQNAdDNChE0oGINiYiiJNmkW93gtQ2Voe7EOuk&

  buildSlider()
end sub

sub buildSlider()
  for each slide in m.slides
    poster = CreateObject("roSGNode", "Poster")
    poster.uri = "pkg:/assets/slides/"+slide.filename
    m.posterGrp.appendChild(poster)
  end for
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
