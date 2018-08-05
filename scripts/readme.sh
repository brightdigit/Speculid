#!/bin/sh

SOURCE=gh-pages/README.md 
DESTINATION=README.md

cat $SOURCE | \
	perl -pe 's/\{\:height="[^"]+"\}//g' | \
	perl -pe 's/\]\(\//\]\(\/gh-pages\//g' | \
	#perl -pe 's/\\{\:class="html-only"\}//g' | \
	#![Multiple Images](/images/mechanic.svg){:height="100px"}{:class="html-only"}
	perl -pe 's/\!.+\{\:class="html-only"\}//g' | \
	perl -0pe 's/\<\!-- HTML-ONLY BEGIN --\>.*\<\!-- HTML-ONLY END --\>//gms' | \
	cat > $DESTINATION