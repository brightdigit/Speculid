#!/bin/sh

SOURCE=gh-pages/README.md 
DESTINATION=README.md

cat $SOURCE | \
	perl -pe 's/\{\:height="[^"]+"\}//g' | \
	perl -pe 's/\]\(\/([^\/])/\]\(https\:\/\/cdn.rawgit.com\/brightdigit\/Speculid\/gh-pages\/$1/g' | \
	perl -pe 's/src="\//src="https\:\/\/cdn.rawgit.com\/brightdigit\/Speculid\/gh-pages\//g' | \
	perl -pe 's/\!.+\{\:class="html-only"\}//g' | \
	perl -0pe 's/\<\!-- HTML-ONLY BEGIN --\>.*\<\!-- HTML-ONLY END --\>//gms' | \
	perl -0pe 's/\* TOC.*{:toc}/<!--ts-->\n<!--te-->/gms' | \

	cat > $DESTINATION

"${BASH_SOURCE%/*}/github-markdown-toc/gh-md-toc"  --insert $DESTINATION