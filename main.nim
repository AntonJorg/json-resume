import os
import src/build_html
import src/build_latex

const OUT_DIR = "build"

removeDir(OUT_DIR)
createDir(OUT_DIR)

copyDir("src/images", "build/images")
copyFileToDir("src/styles.css", "build")
copyFileToDir("src/clickable.cards.js", "build")
copyFileToDir("citations.bib", "build")

build_html(OUT_DIR & "/index.html")
build_latex(OUT_DIR & "/cv.tex")
