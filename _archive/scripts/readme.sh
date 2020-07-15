#!/bin/sh

SOURCE=index.md 
DESTINATION=README.md

cat $SOURCE | \
	perl -pe 's/\{\:height="[^"]+"\}//g' | \
	perl -pe 's/\]\(\/([^\/])/\]\(https\:\/\/rawcdn.githack.com\/brightdigit\/Speculid\/master\/$1/g' | \
	perl -pe 's/src="\//src="https\:\/\/rawcdn.githack.com\/brightdigit\/Speculid\/master\//g' | \
	perl -pe 's/\!?\[.+\{\:class="html-only"\}//g' | \
	perl -0pe 's/\<\!-- HTML-ONLY BEGIN --\>.*\<\!-- HTML-ONLY END --\>//gms' | \
	perl -0pe 's/\* TOC.*{:toc}//gms' | \

	cat > $DESTINATION

"${BASH_SOURCE%/*}/github-markdown-toc/gh-md-toc"  --insert $DESTINATION