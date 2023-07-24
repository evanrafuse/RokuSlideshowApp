function init()
  ? "Initializing slider"
  m.poster = m.top.FindNode("poster")
  m.slides = []
  m.slideCount = 0
  m.top.ObserveField("currentSlide", "changeSlide")
  getSlides()
end function

sub getSlides()
  jsonAsString = ReadAsciiFile("pkg:/assets/slidelist.json")
  m.slides = ParseJson(jsonAsString).slides
  m.slideCount = m.slides.count() - 1
end sub

sub incrementSlide()
  if m.slideCount = m.top.currentSlide
    m.top.currentSlide = 0
  else
    m.top.currentSlide = m.top.currentSlide + 1
  end if
end sub

sub changeSlide()
  m.poster.uri = "pkg:/assets/slides/"+m.slides[m.top.currentSlide].filename
  m.top.slideTitle = m.slides[m.top.currentSlide].title
end sub