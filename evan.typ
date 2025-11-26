#let FONT_TEXT = "Cormorant"
#let FONT_COUNTER = "Libertinus Serif"

#let is_gradient_background_color = 0
#let background-color = ()
#if is_gradient_background_color == 1 {
  for x in range(0, 15) {
    background-color.push(luma(x))
  }
} else {
  background-color = (luma(0), luma(0))
}

#let is_gradient_text_color = 0
#let text-color = none
#if is_gradient_text_color == 1 {
  let gradient_text_background = ()
  for x in range(150, 200) {
    gradient_text_background.push(luma(x))
  }
  text-color = gradient.linear(..gradient_text_background)
} else {
  text-color = color.white
}

#let scale-int = 175%


#let title-slide(title, subtitle, authors) = {
  set page(
    footer: none,
    fill: gradient.linear(
      ..background-color,
      angle: 90deg
    )
  )
  set align(horizon)
  set par(leading: -6.0pt)

  set text(fill: text-color, size: 80pt, weight: "semibold", font: FONT_TEXT)
  scale(y: scale-int, smallcaps(text(title, stroke: 0.5pt + color.luma(300)), all: true))

  v(- 1cm) // space between title and subtitle

  set text(size: 36pt)
  if subtitle != none {
    scale(y: scale-int, smallcaps(text(subtitle, weight: "extrabold"), all: true))
  }

  set align(right)
  if authors != none { 
    for person in authors {
      scale(y: scale-int, smallcaps(text(weight: "extrabold", person), all: true))
      linebreak()
      v(- 3.5cm)
    }
  }
}

#let counter-style() = {
  let page = here().page()
  set align(right)
  set text(size: 30pt, weight: "semibold", font: FONT_COUNTER)
  scale(y: scale-int - 50%, smallcaps(all: true, [:#page]))
}

#let heading-counter-style() = {
  let page = here().page()
  set text(size: 36pt, weight: "semibold", font: FONT_COUNTER)
  scale(y: scale-int, smallcaps(all: true, [EPISODE:#page]))
}

#let heading-1-slide(heading_title) = {
  set page(
    header: none,
    footer: none,
    fill: gradient.linear(
      ..background-color,
      angle: 90deg
    )
  )
  set align(left)
  set text(fill: text-color, size: 63pt, weight: "semibold", font: FONT_TEXT)
  scale(y: scale-int, smallcaps(heading_title, all: true))

  v(- 0.5cm) // space between heading and counter

  heading-counter-style()
}

#let heading-2-slide(heading_title) = {
  set align(left)
  set text(fill: text-color, size: 40pt, weight: "semibold", font: FONT_TEXT)
  scale(y: scale-int, smallcaps(heading_title, all: true))
}

#let content-slide(content) = {
  set page(
    header: none,
    footer: context { counter-style() },
    fill: gradient.linear(
      ..background-color,
      angle: 90deg
    )
  )

  set align(center + horizon)
  set par(justify: true, leading: 0.1cm)
  set text(fill: text-color, size: 30pt, weight: "semibold", font: FONT_TEXT)
  smallcaps(content, all: true)
}


#let slides(
  content,
  title: none,
  subtitle: none,
  authors: none,
) = {
  set page(
    paper: "presentation-4-3",
    margin: (x: 0.6cm, top: 0.0cm, bottom: 1.7cm),
    header: context {
      let page = here().page()
      let headings = query(selector(heading.where(level: 2)))
      let heading = headings.rev().find(x => x.location().page() <= page)
    }
  )

  if title != none {
    if (type(authors) != array) {
      authors = (authors,)
    }
    title-slide(title, subtitle, authors)
  }
  else {
    panic("Title not found")
  }

  show heading.where(level: 1): x => {
    heading-1-slide(x.body)
  }

  show heading.where(level: 2): x => {
    heading-2-slide(x.body)
  }

  content-slide(content)
}
