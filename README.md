![header](https://raw.githubusercontent.com/brightdigit/speculid/master/assets/images/Logo.png)

# Speculid

[![Twitter](https://img.shields.io/badge/Twitter-@BrightDigit-blue.svg?style=flat)](http://twitter.com/brightdigit)
[![Codecov](https://img.shields.io/codecov/c/github/brightdigit/speculid.svg?maxAge=2592000)](https://codecov.io/gh/brightdigit/speuclid)
[![homebrew](https://img.shields.io/badge/homebrew-v1.0.0beta1-yellow.svg)](https://github.com/brightdigit/homebrew-brightdigit)
[![Travis](https://img.shields.io/travis/brightdigit/speculid.svg)](https://travis-ci.org/brightdigit/speculid)
[![Beerpay](https://img.shields.io/beerpay/brightdigit/speculid.svg?maxAge=2592000)](https://beerpay.io/brightdigit/speculid)
[![Gitter](https://img.shields.io/gitter/room/speculid/Lobby.js.svg?maxAge=2592000)](https://gitter.im/speculid/Lobby)
[![Analytics](https://ga-beacon.appspot.com/UA-33667276-5/brightdigit/speculid?flat&useReferer)](https://github.com/igrigorik/ga-beacon)

Easily Build Xcode Image and App Icon Assets from Graphic Files.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Requirements](#requirements)
- [Synopsis](#synopsis)
- [Installation](#installation)
- [Features](#features)
- [Usage](#usage)
  - [File Format](#file-format)
  - [Application Configuration](#application-configuration)
  - [Xcode Integration](#xcode-integration)
- [Thanks](#thanks)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Requirements

* **macOS 10.10 Yosemite**
* **Xcode 8.0**

## Synopsis

![diagram](https://raw.githubusercontent.com/brightdigit/speculid/master/assets/images/Diagram.png)

Part of the process of building an app for **watchOS**, **iOS**, or **macOS** is including all the image assets in your application. That could be done by exporting the various sizes from your graphics application. However including the exporting process in the app build, provides many benefits:

* **Saving Time On Pulling The Repository**: 
  * *exported graphics don't need to be included with source control*
* **New Graphic Will Be Automatically Used After Build**: 
  * *every time a modification is made to the source graphic, the build process will update the assets*
* **Exporting The Image Assets No Longer Part of Graphic Design Process**: 
  * *when editing the source graphic, exporting is moved to build process*

**Speculid** gives you the ability to run a script which builds those assets from a **jpeg**, **png**, or even vector graphics file like **svg**.

## Installation

Speculid can be installed via `Homebrew <http://brew.sh/>`:

    $ brew tap brightdigit/speculid
    $ brew install speculid

## Features

* Parse App Icon and Image Sets
* Convert SVG Files to Designated Sizes
* Resize Raster Images to Designated Sizes
* Command-Line Capabilities for Creating Build Phase Scripts
    
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

<img src="https://raw.githubusercontent.com/brightdigit/speculid/master/assets/images/SetExample.png" width="320" height="240" alt="Image Set Examples from Xcode">

A set is an image set or app icon set used by Xcode. That path specified in the json could be relative to the `.spcld` file.

#### Source 

The image source file which could be a SVG or any bitmap image type compatible with [imagemagick](http://www.imagemagick.org).

#### Geometry *optional*

The destination geometry of image if needed (i.e. image set). It must be in the format of:

* *width* (ex. "128") - for specifying the width of the destination image
* x*height* (ex. "x128") - for specifying the height of the destination image

You can only specify the height or the width. The other dimension is automatically calculated based on the aspect ration of the image.

### Application Configuration

If you install **Speculid** using the standard homebrew path, it should be able to find the nessacary applications needed. However if you need to set the path to the dependency applications, create a `json` file in your home directory `/Users/username/` named `speculid.json`. Then specify the paths to the application dependencies:

```json
{
  "paths" : {
    "inkscape" : "/usr/local/bin/inkscape",
    "convert": "/usr/local/bin/convert"
  }
}
```

If you are uncertain the paths, in your terminal run `which <command>` and it will tell you the complete path to the application.

```bash
$ which inkscape
/usr/local/bin/inkscape
```

If you are interested in a more automated method, up vote [the issue here](https://github.com/brightdigit/speculid/issues/8).

### Xcode Integration

With **Speculid**, the process of building image assets can be automated in **Xcode**.

1. Add the speculid files to your source root as well as your source graphic files. 

![Xcode Target Membership](https://raw.githubusercontent.com/brightdigit/speculid/master/assets/images/XcodeTargetMembership.png)

  * *Note: you don't need to add these files to your target membership*

2. Add the *Run Script* Build Phase to the top of your project with the following code:

  ```bash
  find "${SRCROOT}" -name "*.speculid" -print0 |
  while IFS= read -r -d $'\0' line; do
  speculid "$line" &
  done
  wait
  ```
![Xcode Build Phase Run Script](https://raw.githubusercontent.com/brightdigit/speculid/master/assets/images/XcodeBuildPhaseRunScript.png)

3. Build the application. This will create the graphics which you will use in your asset image set or app icon.

![Xcode Unorganized Assets](https://raw.githubusercontent.com/brightdigit/speculid/master/assets/images/XcodeUnorganizedAssets.png)

4. Drag the images to the correct asset slot. Each rendered image file is suffixed denoting its slot.

  *(source file base name)*.*(size)*@*(scale)*~*(idiom)*.(extension)

  **Examples**

  * **logo.20x20@1x~ipad.png** - 20x20 size 1x scale for iPad
  * **logo.60x60@3x~iphone.png** - 60x60 size 3x scale for iPhone
  * **logo.83.5x83.5@2x~ipad.png** - 83.5x83.5 size 2x scale for iPad

5. Build and Run. Done.

<!--
## Tutorial

### Importing a SVG File as an App Icon

#### 1. Export the Grpahic File (SVG, JPEG, PNG, etc...)

From your graphics application, export your source graphic to whichever format you choose. If you are exporting a **Raster Image** *(jpeg, png, etc...)*, use the highest resolution possible. 



#### 2. Create a `.speculid` File

#### 3. Add a Run Script Phase to Xcode and Build

#### 4. Drag Each File to the Correct Image

#### 5. Build and Run
-->
## Dependencies

* [Inkscape](https://inkscape.org) — a professional vector graphics editor
* [Imagemagick](http://www.imagemagick.org) - a software suite to create, edit, compose, or convert bitmap images

## Thanks

**Speculid** © 2016, BrightDigit, LLC. Released under the [MIT License].<br>

> [brightdigit.com](http://brightdigit.com) &nbsp;&middot;&nbsp;
> GitHub [@brightdigit](https://github.com/brightdigit) &nbsp;&middot;&nbsp;
> Twitter [@brightdigit](https://twitter.com/brightdigit)

[MIT License]: http://mit-license.org/
