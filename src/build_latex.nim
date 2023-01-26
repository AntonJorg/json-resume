import strutils
import strformat
import json
import types


func `$`(a: Summary): string =
  if $a.long != "":
    result = fmt"""\section{{Summary}}

{a.long}"""

func skillSection(resume: Resume): string =
  if $resume.skills == "":
    return ""
  result = """\section{Skills}
  \begin{tabularx}{\linewidth}{@{}l X@{}}
"""
  for skill in @(resume.skills):
    result &= fmt"""{skill.name} & \normalsize{{{join(skill.skills, ", ")}}}\\""" & "\n"
  result &= "\\end{tabularx}"

func workItem(item: Item): string =
  result = fmt"""\begin{{tabularx}}{{\linewidth}}{{ @{{}}l r@{{}} }}
\textbf{{{item.title} at {item.organization}}} & \hfill {item.date} \\[3.75pt]
\multicolumn{{2}}{{@{{}}X@{{}}}}{{{item.description}}}
\end{{tabularx}}"""
  result &= "\n\n"

func projectItem(item: Item): string =
  result = fmt"""\begin{{tabularx}}{{\linewidth}}{{ @{{}}l r@{{}} }}
\textbf{{{item.title}}} & \hfill {item.link}  \\[3.75pt]
\multicolumn{{2}}{{@{{}}X@{{}}}}{{{item.description}}}
\end{{tabularx}}"""
  result &= "\n\n"

func educationItem(item: Item): string =
  result = fmt"""{item.date} & {item.title} at \textbf{{{item.organization}}} \hfill \normalsize {item.grades} \\"""
  result &= "\n\n"

func sectionString(section: Section): string =
  result = fmt"""\section{{{section.title}}}"""
  result &= "\n\n"
  case section.pdfFormatStyle:
    of "project":
      for item in section.content:
        if item.showInPdf:
          result &= projectItem(item)
    of "education":
      result &= "\\begin{tabularx}{\\linewidth}{@{}l X@{}} \n\n"
      for item in section.content:
        if item.showInPdf:
          result &= educationItem(item)
      result &= "\\end{tabularx}"
    of "none":
      return ""
    else:
      for item in section.content:
        if item.showInPdf:
          result &= workItem(item)

func allSections(sections: seq[Section]): string =
  for section in sections:
    result &= sectionString(section)
    result &= "\n\n"

proc build_latex*(filename: string) =
  let jsonResume = parseFile("resume.json")

  let resume: Resume = to(jsonResume, Resume)

  let output = fmt"""%-----------------------------------------------------------------------------------------------------------------------------------------------%
  %	The MIT License (MIT)
  %
  %	Copyright (c) 2021 Jitin Nair
  %
  %	Permission is hereby granted, free of charge, to any person obtaining a copy
  %	of this software and associated documentation files (the "Software"), to deal
  %	in the Software without restriction, including without limitation the rights
  %	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  %	copies of the Software, and to permit persons to whom the Software is
  %	furnished to do so, subject to the following conditions:
  %	
  %	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  %	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  %	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  %	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  %	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  %	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  %	THE SOFTWARE.
  %	
  %
  %-----------------------------------------------------------------------------------------------------------------------------------------------%

  %----------------------------------------------------------------------------------------
  %	DOCUMENT DEFINITION
  %----------------------------------------------------------------------------------------

  % article class because we want to fully customize the page and not use a cv template
  \documentclass[a4paper,12pt]{{article}}

  %----------------------------------------------------------------------------------------
  %	FONT
  %----------------------------------------------------------------------------------------

  % % fontspec allows you to use TTF/OTF fonts directly
  % \usepackage{{fontspec}}
  % \defaultfontfeatures{{Ligatures=TeX}}

  % % modified for ShareLaTeX use
  % \setmainfont[
  % SmallCapsFont = Fontin-SmallCaps.otf,
  % BoldFont = Fontin-Bold.otf,
  % ItalicFont = Fontin-Italic.otf
  % ]
  % {{Fontin.otf}}

  %----------------------------------------------------------------------------------------
  %	PACKAGES
  %----------------------------------------------------------------------------------------
  \usepackage{{url}}
  \usepackage{{parskip}} 	

  %other packages for formatting
  \RequirePackage{{color}}
  \RequirePackage{{graphicx}}
  \usepackage[usenames,dvipsnames]{{xcolor}}
  \usepackage[scale=0.9]{{geometry}}

  %tabularx environment
  \usepackage{{tabularx}}

  %for lists within experience section
  \usepackage{{enumitem}}

  % centered version of 'X' col. type
  \newcolumntype{{C}}{{>{{\centering\arraybackslash}}X}} 

  %to prevent spillover of tabular into next pages
  \usepackage{{supertabular}}
  \usepackage{{tabularx}}
  \newlength{{\fullcollw}}
  \setlength{{\fullcollw}}{{0.47\textwidth}}

  %custom \section
  \usepackage{{titlesec}}				
  \usepackage{{multicol}}
  \usepackage{{multirow}}

  %CV Sections inspired by: 
  %http://stefano.italians.nl/archives/26
  \titleformat{{\section}}{{\Large\scshape\raggedright}}{{}}{{0em}}{{}}[\titlerule]
  \titlespacing{{\section}}{{0pt}}{{10pt}}{{10pt}}

  %for publications
  %\usepackage[style=authoryear,sorting=ynt, maxbibnames=2]{{biblatex}}

  %Setup hyperref package, and colours for links
  \usepackage[unicode, draft=false]{{hyperref}}
  \definecolor{{linkcolour}}{{rgb}}{{0,0.2,0.6}}
  \hypersetup{{colorlinks,breaklinks,urlcolor=linkcolour,linkcolor=linkcolour}}
  %\addbibresource{{citations.bib}}
  %\setlength\bibitemsep{{1em}}

  %for social icons
  \usepackage{{fontawesome5}}

  %debug page outer frames
  %\usepackage{{showframe}}

  \usepackage{{bookmark}}

  %----------------------------------------------------------------------------------------
  %	BEGIN DOCUMENT
  %----------------------------------------------------------------------------------------
  \begin{{document}}

  % non-numbered pages
  \pagestyle{{empty}} 

  %----------------------------------------------------------------------------------------
  %	TITLE
  %----------------------------------------------------------------------------------------

  \begin{{tabularx}}{{\linewidth}}{{@{{}} C @{{}}}}
  \Huge{{{resume.name}}} \\[7.5pt]
  \href{{https://github.com/{resume.github}}}{{\raisebox{{-0.05\height}}\faGithub\ {resume.github}}} \ $|$ \ 
  \href{{https://linkedin.com/in/{resume.linkedin}}}{{\raisebox{{-0.05\height}}\faLinkedin\ {resume.linkedin}}} \ $|$ \ 
  \href{{resume.website}}{{\raisebox{{-0.05\height}}\faGlobe \ {resume.website[resume.website.find('.')+1..^1]}}} \ $|$ \ 
  \href{{mailto:{resume.email}}}{{\raisebox{{-0.05\height}}\faEnvelope \ {resume.email}}} \ $|$ \ 
  \href{{tel:resume.phone.replace(" ", "")}}{{\raisebox{{-0.05\height}}\faMobile \ {resume.phone}}} \\
  \end{{tabularx}}

  %----------------------------------------------------------------------------------------
  % EXPERIENCE SECTIONS
  %----------------------------------------------------------------------------------------

  %Interests/ Keywords/ Summary
  {resume.summary}

  {allSections(resume.sections)}

  %----------------------------------------------------------------------------------------
  %	PUBLICATIONS
  %----------------------------------------------------------------------------------------
  %\section{{Publications}}
  %\begin{{refsection}}[citations.bib]
  %\nocite{{*}}
  %\printbibliography[heading=none]
  %\end{{refsection}}

  %----------------------------------------------------------------------------------------
  %	SKILLS
  %----------------------------------------------------------------------------------------
  {skillSection(resume)}

  \vfill
  \center{{\footnotesize Last updated: \today}}

  \end{{document}}"""

  writeFile(filename, output)
  
  echo "LaTeX built successfully!"
