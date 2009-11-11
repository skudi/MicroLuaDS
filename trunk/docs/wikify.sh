#!/bin/bash
# Generates static html files for the Microlua documentation from our Google
# Code wiki files.
#
# author: Christophe Gragnic (Grahack), november 2009

# TODO
#######
# don't generate <wiki:xxx> (toc and comment)
# spaces for camel case titles
# generate nice message to redirect to wiki for pages not in pages.txt
# if no title in the page, TOC is empty: no 'contents' to display
# localization
# override some pages
# try to use the syntax highlighter as in the original template
#  http://alexgorbatchev.com/wiki/SyntaxHighlighter
#  previously http://code.google.com/p/syntaxhighlighter/


if ! test -f 'wikify.py'; then
    echo "Please launch this script from the trunk/docs directory."
    exit 1
    fi

BUILD_DIR='../build/docs'

if ! test -d $BUILD_DIR; then
    mkdir -p $BUILD_DIR
    echo 'Created the docs build dir.'
    fi

python wikify.py --srcdir=../../wiki/ \
                 --destdir=$BUILD_DIR \
                 --template=wikify.tpl \
                 --mainpage=TableOfContents \
                 `cat pages.txt`
cp screen.css $BUILD_DIR
