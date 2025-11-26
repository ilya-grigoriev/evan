#let FONT_TEXT = "Cormorant"
#let FONT_COUNTER = "Libertinus Serif"

#let is_gradient_background_color = 0
#let background_color = ()
#if is_gradient_background_color == 1 {
  for x in range(0, 15) {
    background_color.push(luma(x))
  }
} else {
  background_color = (luma(0), luma(0))
}

#let gradient_text_background = ()
#for x in range(150, 200) {
  gradient_text_background.push(luma(x))
}
#let default-color = gradient.linear(..gradient_text_background)

#let title-slide(title, subtitle, authors) = {
  set page(
    footer: none,
    fill: gradient.linear(
      ..background_color,
      angle: 90deg
    )
  )
  set align(horizon)
  set par(leading: -6.0pt)

  set text(fill: default-color, size: 120pt, weight: "semibold", font: FONT_TEXT)
  smallcaps(text(title, tracking: -6pt, stroke: 1pt + color.luma(300)), all: true)

  v(- 4cm) // space between title and subtitle

  set text(size: 40pt)
  if subtitle != none {
    smallcaps(text(subtitle, weight: "extrabold", tracking: -2pt), all: true)
  }

  set align(right)
  set par(leading: - 0.5pt)
  if authors != none { 
    for person in authors {
      smallcaps(person, all: true)
      linebreak()
    }
  }
}

#let heading-slide(heading_title) = {
  set page(
    footer: {
      let page = here().page()
      set align(right)
      set text(size: 30pt, weight: "extrabold", font: FONT_COUNTER)
      [#smallcaps(all: true, text(tracking: -1pt, [:#page]))]
    },
    fill: gradient.linear(
      ..background_color,
      angle: 90deg
    )
  )
  set align(left)
  set text(fill: default-color, size: 63pt, weight: "semibold", font: FONT_TEXT)
  smallcaps(text(heading_title, tracking: -1pt), all: true)

}

#let content-slide(content) = {
  set page(
    header: none,
    footer: context {
      let page = here().page()
      set align(right)
      set text(size: 30pt, weight: "extrabold", font: FONT_COUNTER)
      [#smallcaps(all: true, text(tracking: -1pt, [:#page]))]
    },
    fill: gradient.linear(
      ..background_color,
      angle: 90deg
    )
  )

  set text(fill: default-color, size: 30pt, weight: "semibold", font: FONT_TEXT)
  set par(justify: true)
  align(center + horizon)[
    #smallcaps(text(content, tracking: -1pt), all: true)
  ]
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
    header: context{
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
    heading-slide(x.body)
  }

  content-slide(content)
}
