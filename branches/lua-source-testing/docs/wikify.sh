#!/bin/bash
# Generates static html files for the Microlua documentation from our Google
# Code wiki files.
#
# author: Christophe Gragnic (Grahack), november 2009

# TODO
#######
# override some pages
# try to use the syntax highlighter as in the original template
#  http://alexgorbatchev.com/wiki/SyntaxHighlighter
#  previously http://code.google.com/p/syntaxhighlighter/


if ! test -f 'wikify.py'; then
    echo "Please launch this script from the trunk/docs directory."
    exit 1
    fi

BUILD_DIR='../build/docs'

function wikify {
    LANG=$1
    if ! test -d $BUILD_DIR/$LANG; then
        mkdir -p $BUILD_DIR/$LANG
        echo 'Created a docs build dir: '$BUILD_DIR/$LANG'.'
        fi
    python wikify.py --srcdir=../../wiki/$LANG \
                     --destdir=$BUILD_DIR/$LANG \
                     --template=wikify$LANG.tpl \
                     --mainpage=TableOfContents \
                     --gcproject=microlua \
                     `cat pages.txt`
}

for LANG in '' 'fr'; do
    wikify $LANG
    done

cp screen.css $BUILD_DIR
