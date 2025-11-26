# evan

It's template for creating presentation in the style of the title card from Evangelion.

## Usage

```typst
#import "evan.typ": *

#show: slides.with(
  title: [Evangelion],
  subtitle: "Anime series",
  authors: ("Me", "And who"),
  background-color: "black",
  red-stroke: 1
)

= First heading
== Second heading

#lorem(50)
```

## Documentaion
```typst
slides(
  content,
  title: none (str),
  subtitle: none (str),
  authors: none (array or content),
  red-stroke: 0 (0 or 1),
  background-color: "black" ("black" or "white")
)
```

## Hacking

You can specify a lot of parameters like font size for text, scaling factor for title, etc.
