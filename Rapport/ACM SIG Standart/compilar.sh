#!/bin/bash    
# http://www.csee.umbc.edu/~kunliu1/research/latex.html
latex sigproc-sp
bibtex sigproc-sp
latex sigproc-sp
latex sigproc-sp
dvips -P cmz -t A4 -o sigproc.ps sigproc-sp.dvi

ps2pdf sigproc.ps FINAL.pdf

evince FINAL.pdf &
