prefix=/usr/local
framework=/Library/Frameworks
build=build/Release

all: spcld

Speculid.framework : 
	xcodebuild -target Speculid	

spcld : Speculid.framework
	xcodebuild -target spcld

clean :
	rm -rf build

install: spcld
	install -m 0755 $(build)/spcld $(prefix)/bin 
	cp -r $(build)/Speculid.framework $(framework)
