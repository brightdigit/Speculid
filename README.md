![header](https://raw.githubusercontent.com/brightdigit/speculid/release/1.0.0/assets/images/Logo.png)

# Speculid

[![Twitter](https://img.shields.io/badge/Twitter-@BrightDigit-blue.svg?style=flat)](http://twitter.com/brightdigit)
[![Codecov](https://img.shields.io/codecov/c/github/brightdigit/speuclid.svg?maxAge=2592000)](https://codecov.io/gh/brightdigit/speuclid)
[![homebrew](https://img.shields.io/homebrew/v/speculid.svg?maxAge=2592000)](brew.sh)
[![Travis](https://img.shields.io/travis/brightdigit/speculid.svg)](https://travis-ci.org/brightdigit/speculid)
[![Analytics](https://ga-beacon.appspot.com/UA-33667276-5/brightdigit/speculid)](https://github.com/igrigorik/ga-beacon)

Easily Build Xcode Assets from Image Files

## Installation

Speculid can be installed via `Homebrew <http://brew.sh/>`:

    $ brew tap brightdigit/homebrew-core
    $ brew install speculid

## Features

* Parse App Icon and Image Sets
* Convert SVG Files to Designated Size
* Resize Raster Images to Designated Size
* Command-Line Capabilities for Creating Build Phase Scripts
* Mac OS X 10.10+ support
* Documentation
* Test coverage
    
## Usage

```bash
$ spcld <file>
$ spcld -h | --help
$ spcld --version

Options:
  -h --help     Show this screen.
  --version     Show version.
```

### File Format

The `.splcd` file is a `json` file with the image set or app icon path, the graphic file source, and the basic image geometry (width or height).

```json
{
  "set" : "Assets.xcassets/Raster Image.imageset",
  "source" : "layers.png",
  "geometry" : "128"
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