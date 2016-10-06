![header](https://raw.githubusercontent.com/brightdigit/speculid/release/1.0.0/assets/images/Logo.png)

# Speculid

[![Twitter](https://img.shields.io/badge/Twitter-@BrightDigit-blue.svg?style=flat)](http://twitter.com/brightdigit)
[![Codecov](https://img.shields.io/codecov/c/github/brightdigit/speculid/release%2F1.0.0.svg?maxAge=2592000)]((https://codecov.io/gh/brightdigit/speuclid))
[![homebrew](https://img.shields.io/badge/homebrew-v1.0.0alpha12-orange.svg)](https://github.com/brightdigit/homebrew-brightdigit)
[![Travis](https://img.shields.io/travis/brightdigit/speculid/release%2F1.0.0.svg)](https://travis-ci.org/brightdigit/speculid)
[![Beerpay](https://img.shields.io/beerpay/brightdigit/speculid.svg?maxAge=2592000)](https://beerpay.io/brightdigit/speculid)
[![Gitter](https://img.shields.io/gitter/room/speculid/Lobby.js.svg?maxAge=2592000)](https://gitter.im/speculid/Lobby)
[![Analytics](https://ga-beacon.appspot.com/UA-33667276-5/brightdigit/speculid)](https://github.com/igrigorik/ga-beacon)

Build Xcode Image and App Icon Assets from Graphic Files.

## Installation

Speculid can be installed via `Homebrew <http://brew.sh/>`:

    $ brew tap brightdigit/speculid
    $ brew install speculid

## Features

* Parse App Icon and Image Sets
* Convert SVG Files to Designated Size
* Resize Raster Images to Designated Size
* Command-Line Capabilities for Creating Build Phase Scripts
* Mac OS X 10.10+ support
* Documentation
    
## Usage

```bash
$ speculid <file>
$ speculid --help
$ speculid --version

Options:
  -h --help     Show this screen.
  --version     Show version.
```

### File Format

The `.speculid` file is a `json` file with the image set or app icon path, the graphic file source, and optionally the basic image geometry (width or height). Such as

```json
{
  "set" : "Assets.xcassets/Raster Image.imageset",
  "source" : "layers.png",
  "geometry" : "128"
}
```
or
```json
{
"set" : "Assets.xcassets/iOS AppIcon.appiconset",
"source" : "geometry.svg"
}
```

#### Set

<img src="https://raw.githubusercontent.com/brightdigit/speculid/release/1.0.0/assets/images/SetExample.png" width="320" height="240" alt="Image Set Examples from Xcode">

A set is an image set or app icon set used by Xcode. That path specified in the json could be relative to the `.spcld` file.

#### Source 

The image source file which could be a SVG or any bitmap image type compatible with [imagemagick](http://www.imagemagick.org).

#### Geometry

The destination geometry of image if needed (i.e. image set). It must be in the format of:

* *width* (ex. "128") - for specifying the width of the destination image
* x*height* (ex. "x128") - for specifying the height of the destination image

You can only specify the height or the width. The other dimension is automatically calculated based on the aspect ration of the image.

## Dependencies

* [Inkscape](https://inkscape.org) — a professional vector graphics editor
* [Imagemagick](http://www.imagemagick.org) - a software suite to create, edit, compose, or convert bitmap images

## Thanks

**Speculid** © 2016, BrightDigit, LLC. Released under the [MIT License].<br>

> [brightdigit.com](http://brightdigit.com) &nbsp;&middot;&nbsp;
> GitHub [@brightdigit](https://github.com/brightdigit) &nbsp;&middot;&nbsp;
> Twitter [@brightdigit](https://twitter.com/brightdigit)

[MIT License]: http://mit-license.org/
