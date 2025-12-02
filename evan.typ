#let FONT_TEXT = "Cormorant"
#let FONT_COUNTER = "Libertinus Serif"
#let BOLDNESS-FOR-TITLE = "semibold"
#let BOLDNESS-FOR-SUBTITLE = "semibold"
#let BOLDNESS-FOR-AUTHORS = "extrabold"
#let BOLDNESS-FOR-HEADING-1 = "semibold"
#let BOLDNESS-FOR-HEADING-2 = "semibold"
#let BOLDNESS-FOR-COUNTER = "semibold"
#let BOLDNESS-FOR-HEADING-COUNTER = "semibold"
#let BOLDNESS-FOR-CONTENT = "semibold"

#let IS-GRADIENT-TEXT-COLOR = 0
#let IS-GRADIENT-BACKGROUND-COLOR = 0
#let SCALE-INT = 175%

#let get-background-color(background-color) = {
  let result-background-color = ()
  if IS-GRADIENT-BACKGROUND-COLOR == 1 {
    for x in range(0, 15) {
      result-background-color.push(luma(x))
    }
  } else {
    if background-color == "black" {
      result-background-color = (luma(0), luma(0))
    } else {
      result-background-color = (color.white, color.white)
    }
  }
  return result-background-color
}

#let get-text-color(background-color) = {
  let result-text-color = none
  if IS-GRADIENT-TEXT-COLOR == 1 {
    let gradient-text-background = ()
    for x in range(150, 200) {
      gradient-text-background.push(luma(x))
    }
    result-text-color = gradient.linear(..gradient-text-background)
  } else {
    if background-color == "black" {
      result-text-color = color.white
    } else {
      result-text-color = color.black
    }
  }
  return result-text-color
}


#let get-red-stroke() = {
  return color.red.transparentize(80%)
}

#let get-stroke(red-stroke, background-color) = {
  if red-stroke == 0 {
    if background-color == "black" {
      0.5pt + color.luma(300)
    } else {
      none
    }
  } else {
    1.5pt + get-red-stroke()
  }
}

#let title-slide(title, subtitle, authors, red-stroke, background-color, text-color) = {
  set page(
    footer: none,
    fill: gradient.linear(
      ..get-background-color(background-color),
      angle: 90deg
    )
  )
  set align(horizon)
  set par(leading: -6.0pt)

  // TITLE
  set text(fill: text-color, size: 80pt, weight: BOLDNESS-FOR-TITLE, font: FONT_TEXT)
  scale(y: SCALE-INT, x: 79%, smallcaps(text(title, stroke: get-stroke(red-stroke, background-color)), all: true))

  v(- 1cm) // space between title and subtitle

  // SUBTITLE
  set text(size: 36pt)
  if subtitle != none {
    scale(y: SCALE-INT, smallcaps(text(subtitle, stroke: get-stroke(red-stroke, background-color), weight: BOLDNESS-FOR-SUBTITLE), all: true))
  }

  // AUTHORS
  set align(right)
  if authors != none { 
    for person in authors {
      scale(y: SCALE-INT, smallcaps(text(weight: BOLDNESS-FOR-AUTHORS, stroke: get-stroke(red-stroke, background-color), person), all: true))
      linebreak()
      v(- 3.5cm)
    }
  }
}

#let counter-style() = {
  let page = here().page()
  set align(right)
  set text(size: 30pt, weight: BOLDNESS-FOR-COUNTER, font: FONT_COUNTER)
  scale(y: SCALE-INT - 50%, smallcaps(all: true, [:#page]))
}

#let heading-counter-style() = {
  let page = here().page()
  set text(size: 36pt, weight: BOLDNESS-FOR-HEADING-COUNTER, font: FONT_COUNTER)
  scale(y: SCALE-INT, smallcaps(all: true, [EPISODE:#page]))
}

#let heading-1-slide(heading_title, red-stroke, background-color, text-color) = {
  set page(
    header: none,
    footer: none,
    fill: gradient.linear(
      ..get-background-color(background-color),
      angle: 90deg
    )
  )
  set align(left)
  set text(fill: text-color, stroke: get-stroke(red-stroke, background-color), size: 63pt, weight: BOLDNESS-FOR-HEADING-1, font: FONT_TEXT)
  scale(y: SCALE-INT, smallcaps(heading_title, all: true))

  v(- 0.5cm) // space between heading and counter

  heading-counter-style()
}

#let heading-2-slide(heading_title, red-stroke, background-color, text-color) = {
  set align(left)
  set text(fill: text-color, stroke: get-stroke(red-stroke, background-color), size: 40pt, weight: BOLDNESS-FOR-HEADING-2, font: FONT_TEXT)
  scale(y: SCALE-INT, smallcaps(heading_title, all: true))
}

#let content-slide(content, background-color, text-color) = {
  set page(
    header: none,
    footer: context { counter-style() },
    fill: gradient.linear(
      ..get-background-color(background-color),
      angle: 90deg
    )
  )

  set align(center + horizon)
  set par(justify: true, leading: 0.1cm)
  set text(fill: text-color, size: 30pt, weight: BOLDNESS-FOR-CONTENT, font: FONT_TEXT)
  smallcaps(content, all: true)
}

#let check-parameters(red-stroke, background-color) = {
  if (red-stroke != 0) and (red-stroke != 1) {
    panic("red-stroke is not set. there are only 1 (true) or 0 (false).")
  }
  if (background-color != "black") and (background-color != "white") {
    panic("background-color is not set, there are only 'black' or 'white'.")
  }
}

#let slides(
  content,
  title: none,
  subtitle: none,
  authors: none,
  red-stroke: 0,
  background-color: "black"
) = {
  check-parameters(red-stroke, background-color)
  let text-color = get-text-color(background-color)

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
    if (type(authors) != array) { authors = (authors,) }
    title-slide(title, subtitle, authors, red-stroke, background-color, text-color)
  } else {
    panic("Title not found")
  }

  show heading.where(level: 1): x => {
    heading-1-slide(x.body, red-stroke, background-color, text-color)
  }

  show heading.where(level: 2): x => {
    heading-2-slide(x.body, red-stroke, background-color, text-color)
  }

  content-slide(content, background-color, text-color)
}
