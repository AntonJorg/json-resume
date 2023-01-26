import htmlgen
import json
import types
import options


func `$`(a: Item): string =
  var l = ""
  if a.link.isSome:
    l = a(href=a.link.get().url, a.link.get().title) & br()

  var d = ""
  if a.description.isSome:
    d = `div`(class="card-expand",
        i(class="fa fa-angle-down")
      ) &
      `div`(class="card-body",
        `div`(class="card-text",
          l,
          a.description.get()
        )
      )

  var i = ""
  if a.image.isSome:
    i = img(class="card-logo",
      src="images/" & a.image.get(),
      alt="Logo"
    )

  var date = ""
  if a.date.isSome:
    date = i($a.date.get())

  result = `div`(class="card",
      `div`(class="card-header",
        `div`(class="card-title",
          h2(a.title),
          h4(a.organization,
            date
          )
        ),
        i
      ),
      d
    )

func linkList(resume: Resume): string =
  result = "<ul>"
  result &= li(i(class="fab fa-linkedin"), a(href="https://linkedin.com/in/" & resume.linkedin, "LinkedIn"))
  result &= li(i(class="fab fa-github"), a(href="https://github.com/" & resume.github, "GitHub"))
  for l in resume.links:
    result &= li(i(class=l.icon), a(href=l.url, l.title))
  result &= "</ul>"

func itemList(its: seq[Item]): string =
  result = "<div class=\"cards-container\">"
  for i in its:
    result &= $i
  result &= "</div>"

func sections(secs: seq[Section]): string =
  result = "<section class=\"content\">"
  for s in secs:
    result &= `div`(
      h1(s.title),
      hr(),
      itemList(s.content)
    )
  result &= "</section>"

func optionalImg(url: Option[string]): string =
  if url.isSome:
    result = img(
      src=url.get(),
      alt="Profile Picture"
    )

proc build_html*(filename: string) =
  let jsonResume = parseFile("resume.json")

  let resume: Resume = to(jsonResume, Resume)

  let page = html(
    head(
      link(rel="stylesheet", href="styles.css"),
      link(rel="stylesheet", href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css")
    ),
    `div`(class="wrapper",
      `div`(class="sidebar",
        header(
          optionalImg(resume.image),
          h1(
            a(href=resume.website,
              resume.name
            )
          ),
          p(class="addr",
            "✉ " & resume.email
          ),
          p(
            resume.summary.short
          ),
          `div`(class="link-wrapper",
            linkList(resume)
          )
        )
      ),
      sections(resume.sections)
    ),
    script(src="clickable.cards.js")
  )

  writeFile(filename, "<!DOCTYPE html>" & page)

  echo "HTML built successfully!"
