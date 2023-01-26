import options
import strformat

type
  Link* = object of RootObj
    title*: string
    url*: string

  IconLink = object of Link
    icon*: string

  SideBar* = object
  
  Date* = object
    start*: string
    until*: Option[string]

  Item* = object
    title*: string
    organization*: string
    link*: Option[Link]
    description*: Option[string]
    image*: Option[string]
    date*: Option[Date]
    grades*: Option[string]
    showInPdf*: bool

  Section* = object
    title*: string
    pdfFormatStyle*: string
    content*: seq[Item]

  Summary* = object
    short*: string
    long*: Option[string]

  Skill* = object
    name*: string
    skills*: seq[string]

  Resume* = object
    image*: Option[string]
    name*: string
    email*: string
    phone*: string
    website*: string
    github*: string
    linkedin*: string
    summary*: Summary
    links*: seq[IconLink]
    sections*: seq[Section]
    skills*: Option[seq[Skill]]

func `@`*(a: Option[seq[Skill]]): seq[Skill] =
  result = a.get(newSeq[Skill]())

func `$`*[T](a: Option[T]): string =
  if a.isSome:
    result = $a.get()

func `$`*(link: Link): string =
  result = fmt"""\href{{{link.url}}}{{{link.title}}}"""

func `$`*(a: Date): string =
  if a.until.isSome:
    result = $a.start & " - " & $a.until.get()
  else:
    result = $a.start
