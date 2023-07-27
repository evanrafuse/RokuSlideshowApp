function init()
  m.posterGrp = m.top.FindNode("posterGrp")
  m.carouselAnim = m.top.FindNode("carouselAnim")
  m.carouselSlideAnim = m.top.FindNode("carouselSlideAnim")
  m.slideCount = 0
  m.currentPos = 0
  m.nextPos = 0
  ' getSlides()
  ?"Test 5"
end function

sub getSlides()
  jsonAsString = ReadAsciiFile("pkg:/assets/slidelist.json")
  m.slides = ParseJson(jsonAsString).slides
  m.slideCount = m.slides.count() - 1
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
