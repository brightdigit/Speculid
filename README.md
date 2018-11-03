

<!--ts-->
   * [Introduction](#introduction)
      * [Challenges Managing Graphic Assets](#challenges-managing-graphic-assets)
         * [<a href="https://camo.githubusercontent.com/5dd7caafd8ae359f85705403ace571735caf980c/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f6d656368616e69632e737667" target="_blank" rel="nofollow"><img src="https://camo.githubusercontent.com/5dd7caafd8ae359f85705403ace571735caf980c/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f6d656368616e69632e737667" height="25pt" data-canonical-src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/mechanic.svg" style="max-width:100\x;"></a> Manually Create Multiple Sizes](#-manually-create-multiple-sizes)
         * [<a href="https://camo.githubusercontent.com/508ccc55cbff013ae8658a4129a187b2d9ef850a/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f617263686976652e737667" target="_blank" rel="nofollow"><img src="https://camo.githubusercontent.com/508ccc55cbff013ae8658a4129a187b2d9ef850a/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f617263686976652e737667" height="25pt" data-canonical-src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/archive.svg" style="max-width:100\x;"></a> Store Generated Image Files](#-store-generated-image-files)
         * [What If You Had...](#what-if-you-had)
            * [Care-Free Graphic Management Where...](#care-free-graphic-management-where)
      * [What Speculid Does](#what-speculid-does)
         * [<a href="https://camo.githubusercontent.com/4f78f8aad8e564f2d18fec26b56eb5704e19111b/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f6d616368696e6572792e737667" target="_blank" rel="nofollow"><img src="https://camo.githubusercontent.com/4f78f8aad8e564f2d18fec26b56eb5704e19111b/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f6d616368696e6572792e737667" height="25pt" data-canonical-src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/machinery.svg" style="max-width:100\x;"></a> Automate the process](#-automate-the-process)
         * [<a href="https://camo.githubusercontent.com/29334f2cc761c3891de4cd5e6865b09c64d26c05/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f636c65616e2d636f64652e737667" target="_blank" rel="nofollow"><img src="https://camo.githubusercontent.com/29334f2cc761c3891de4cd5e6865b09c64d26c05/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f636c65616e2d636f64652e737667" height="25pt" data-canonical-src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/clean-code.svg" style="max-width:100\x;"></a> Tidy Your Repo](#-tidy-your-repo)
         * [Features](#features)
            * [Input File Types Supported](#input-file-types-supported)
            * [Modifiers](#modifiers)
            * [Output File Types Supported](#output-file-types-supported)
   * [Download](#download)
   * [Table of Contents](#table-of-contents)
   * [Installation](#installation)
   * [Usage](#usage)
      * [File Format and Properties](#file-format-and-properties)
         * [Set set](#set-set)
         * [Source source](#source-source)
         * [Geometry <em>optional</em> geometry](#geometry-optional-geometry)
         * [Background <em>optional</em> background](#background-optional-background)
         * [Remove Alpha <em>optional</em>  remove-alpha](#remove-alpha-optional--remove-alpha)
      * [Exporting SVGs for Speculid](#exporting-svgs-for-speculid)
         * [<a href="https://camo.githubusercontent.com/c4927857dc237bf89384c088d756947123fc99ac/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f7376672d6578706f72742f736b657463682f6c6f676f2e737667" target="_blank" rel="nofollow"><img src="https://camo.githubusercontent.com/c4927857dc237bf89384c088d756947123fc99ac/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f7376672d6578706f72742f736b657463682f6c6f676f2e737667" height="25pt" data-canonical-src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/svg-export/sketch/logo.svg" style="max-width:100\x;"></a> Sketch](#-sketch)
         * [<a href="https://camo.githubusercontent.com/9d31aa3af7de5ff522c42117c2a5b6bd631ed636/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f7376672d6578706f72742f70686f746f73686f702f6c6f676f2e737667" target="_blank" rel="nofollow"><img src="https://camo.githubusercontent.com/9d31aa3af7de5ff522c42117c2a5b6bd631ed636/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f7376672d6578706f72742f70686f746f73686f702f6c6f676f2e737667" height="25pt" data-canonical-src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/svg-export/photoshop/logo.svg" style="max-width:100\x;"></a> Photoshop](#-photoshop)
         * [<a href="https://camo.githubusercontent.com/b12eea760a21557d856ae2c3a0dcfc65070fe560/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f7376672d6578706f72742f696c6c7573747261746f722f6c6f676f2e737667" target="_blank" rel="nofollow"><img src="https://camo.githubusercontent.com/b12eea760a21557d856ae2c3a0dcfc65070fe560/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f7376672d6578706f72742f696c6c7573747261746f722f6c6f676f2e737667" height="25pt" data-canonical-src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/svg-export/illustrator/logo.svg" style="max-width:100\x;"></a> Illustrator](#-illustrator)
      * [Xcode Integration and Automation](#xcode-integration-and-automation)

<!-- Added by: leo, at:  -->

<!--te-->

# Introduction

## Challenges Managing Graphic Assets

Part of the process of building an app for **watchOS**, **iOS**, or **macOS** is including all the image assets and app icons  in your application. Each image assets or app icons requires **several copies for different resolutions, different devices, and different sizes.** Right now, this needs to be done by exporting all the various similar images from a major graphics application. 

That means developers need to:

<section class="cards" markdown="1">

<section class="card half" markdown="1">



### <img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/mechanic.svg" height="25pt"/> Manually Create Multiple Sizes

Each graphic must be **manually converted and resized several times for each update**.

</section>
<section class="card half" markdown="1">



### <img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/archive.svg" height="25pt"/> Store Generated Image Files

An asset catalog image set will need a 1x, 2x, 3x of each graphic and **App Icons may need as many 30 different sizes**.

</section>
</section>

### What If You Had...

<section class="cards" markdown="1">

<section class="card whole" markdown="1">








<img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/emoji.svg" height="100px"/><img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/emoji.svg" height="75px"/><img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/emoji.svg" height="50px"/><img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/emoji.svg" height="25px"/><img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/emoji.svg" height="12px"/><img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/emoji.svg" height="6px"/>

#### Care-Free Graphic Management Where...

* **Only one file is needed** _for each Image Set and App Icon._
* **Graphic Designers need only export a single file change** _each time rather than as many as serveral scaled copies._
* **Resizing and conversion is done behind the scenes** _based on a single source image._

</section>
</section>

## What Speculid Does

**Speculid** links a single graphic file to an Image Set or App Icon and automatically renders different resolutions, file types, and sizes for all the image specifications required.

![diagram](https://rawcdn.githack.com/brightdigit/Speculid/master/images/Diagram.png)

<section class="cards" markdown="1">
<section class="card half" markdown="1">



### <img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/machinery.svg" height="25pt"/> Automate the process 

Speculid automates the process so **only one graphic file is needed**. Add Speculid to your build process and now the **conversions and resizing are automated** as part of the build process. Now there is no need for anyone to manually create each size for each device every time.

</section>
<section class="card half" markdown="1">



### <img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/clean-code.svg" height="25pt"/> Tidy Your Repo

**Reduce the size of your repository** by including a single vector or raster image and ignore all your automated png and pdf files at compile. That means **faster remote pulls, less redundancy, and complete syncronization between sizes.**

</section>
</section>

### Features

This means **Speuclid** can...

* **take multiple input file types including SVG vector files** and raster PNG files
* **automatically create each necessary resized raster file**
* **remove transparencies from PNG and SVG file** for App Icons
* **export to PDF for vector images in Image Sets** as well as PNG

#### Input File Types Supported 

* **SVG** - Scalable Vector Graphics
* **PNG** - Portable Network Graphics

#### Modifiers 

* [Adding Background Colors](#background-optional-background)
* [Transparency Removal](#remove-alpha-optional--remove-alpha)

#### Output File Types Supported 

* **PNG** - Portable Network Graphics  
* **PDF** - Portable Document Format 

# Download



<div class="readme-only" markdown="1">

Enter your email address [here](https://speculid.com#download) to request access to the latest version.

</div>

# Table of Contents



# Installation

Once you have unzipped the file, go ahead, and **copy the application *Speculid.App* to the Applications folder**.

A command line tool is included in the application bundle. Copy the command line tool to your /bin/ folder:

```base
$ sudo cp /Applications/Speculid.app/Contents/SharedSupport/speculid /usr/local/bin
```

# Usage

**Right now**, Speculid only supports being called through a command line terminal for now. Once you have copied the command to your */usr/local/bin* folder you should be able to access it easy.

```bash
$ speculid --process <file>
$ speculid --help
$ speculid --version

Options:
  --help     Show this screen.
  --version  Show version.
```

## File Format and Properties

The `.speculid` file is a `json` file with the image set or app icon path, the graphic file source, and optionally basic image geometry (width or height). All paths specified in the json file could be relative to the `.speculid` file or an absolute path. Such as

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
  "source" : "geometry.svg",
  "background" : "#FFFFFFFF",
  "remove-alpha" : true
}
```

### Set `set`

![Image Set Examples from Xcode](https://rawcdn.githack.com/brightdigit/Speculid/master/images/SetExample.png)

A set is an image set or app icon used by Xcode.

### Source `source`

The image source file which could be a SVG or PNG file.

### Geometry *optional* `geometry`

The destination geometry of image if needed (i.e. image set). It must be in the format of:

* *width* (ex. "128") - for specifying the width of the destination image
* x*height* (ex. "x128") - for specifying the height of the destination image

You can only specify the height or the width. The other dimension is automatically calculated based on the aspect ration of the image.

### Background *optional* `background`

As a requirement, **App Icons are required to exclude any alpha channels**. In order to remove a transparency from a source PNG or SVG file, you can specify to remove the alpha channel and add a background color. 

The background color can be set in a standard rgb, rgba, or hex code format (#RRGGBB or #AARRGGBB). If no alpha is specified an alpha of 1.0 is assumed.

### Remove Alpha *optional*  `remove-alpha`

To specifically remove the alpha channel, a true boolean value must be specified. This will remove the alpha channel from the file. Make sure to specify an opaque background color when removing the alpha channel.

## Exporting SVGs for Speculid

<div id="exporting-svgs-section" markdown="1">

<header markdown="1">
 

### <img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/svg-export/sketch/logo.svg" height="25pt"/> Sketch 
</header>

![Sketch iOS App Icon Template Window][sketch-step-1]
1. Open **Sketch** and create a new document using the **iOS App Icon** Template. If you are using an existing project, you can skip to step 3.

    ![Sketch Slice Panel][sketch-step-2]
2. Once you are in the template, duplicate one of the icon size slices on the left side.

    ![Sketch Present Format][sketch-step-3]
3. On the right size, change the **preset format** to **SVG**.

    ![Sketch Export Menu][sketch-step-4]
4. In the top menu, select **File**...**Export**. 

    ![Sketch Export Window][sketch-step-5]
5. Select your duplicated slice and select **Export**.

6. Select the destination for your **SVG file** and **Save**.


<header markdown="1">


### <img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/svg-export/photoshop/logo.svg" height="25pt"/> Photoshop
</header>

![Photoshop Export Menu][photoshop-step-1]
1. Open your **Photoshop** document, select **File**...**Export**...**Export As...**.

    ![Photoshop Export Format][photoshop-step-2]
2. Under the **File Settings** on the right, change the format to **SVG**.

    ![Photoshop Save Dialog][photoshop-step-3]
3. Select **Export All** and choose the destination for your **SVG file** and **Save**.

<header markdown="1">


### <img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/svg-export/illustrator/logo.svg" height="25pt"/> Illustrator
</header>

![Illustrator Export Menu][illustrator-step-1]
1. Open your **Illustrator** document, select **File**...**Export**...**Export for Screens...**.

    ![Illustrator Export Format][illustrator-step-2]
2. Under **Formats**, update the format to **SVG**.

3. Select **Export Artboard** and choose the destination for your **SVG file** and **Save**.

</div>

## Xcode Integration and Automation

With **Speculid**, the process of building image assets can be automated in **Xcode**.

1. **Create the speculid file** and add it to your project folder as well as your source graphic files. 

    ![Xcode Target Membership](https://rawcdn.githack.com/brightdigit/Speculid/master/images/XcodeTargetMembership.png)

    * *Note: you don't need to add these files to any target membership*

2. **Edit the speculid file.**

    1. **Add the property for the source** - the path to the SVG or PNG file.
        ```json
        {
          "source" : "geometry.svg",
          ...
        }
        ```
    1. **Add the property for the set** - the path to the Image Set or App Icon folder.
        ```json
        {
          "set" : "Assets.xcassets/iOS AppIcon.appiconset",
          ...
        }
        ```
    1. *optional* **Add the property for the geometry** - if this a conversion from a vector graphic (SVG) to an Image Set, you may want to supply the *1x* size.
        ```json
        {
          "set" : "Assets.xcassets/Raster Image.imageset",
          "source" : "layers.png",
          "geometry" : "128"
        }
        ```
        If you specify *128* in the *geometry* property, that means the width for the *1x* image will be *128 pixels*, the width for the *2x* image will be *256 pixels*, and the width for the *3x* image will be *384 pixels*. Heights will be calculated based on the aspect ratio of the SVG file.
        Vector images in an image set will be converted to a iOS compatible PDF file.
        
    1. *optional* **Add the properties for the background color and alpha removal** - if this a conversion to an App Icon, you should remove any background transpareny and add a background color.
        ```json
        {
          "set" : "Assets.xcassets/iOS AppIcon.appiconset",
          "source" : "geometry.svg",
          "background" : "#FFFFFFFF",
          "remove-alpha" : true
        }
        ```

    See the [file format section](#file-format) for more details.

2. **Add the *Run Script* Build Phase** to the top of your project with the following code:

    ```bash
    find "${SRCROOT}" -name "*.speculid" -print0 |
    while IFS= read -r -d $'\0' line; do
    /Applications/Speculid/Contents/MacOS/Speculid --process "$line" &
    done
    wait
    ```
    ![Xcode Build Phase Run Script](https://rawcdn.githack.com/brightdigit/Speculid/master/images/XcodeBuildPhaseRunScript.png)

3. **Build the application.** This will create the graphics which you will use in your asset image set or app icon.

    ![Xcode Unorganized Assets](https://rawcdn.githack.com/brightdigit/Speculid/master/images/XcodeUnorganizedAssets.png)

4. **After the first build**, drag the images to the correct asset slot. Each rendered image file is suffixed denoting its slot.

    *(source file base name)*.*(size)*@*(scale)*~*(idiom)*.(extension)

    **Examples**

    * **logo.20x20@1x~ipad.png** - 20x20 size 1x scale for iPad
    * **logo.60x60@3x~iphone.png** - 60x60 size 3x scale for iPhone
    * **logo.83.5x83.5@2x~ipad.png** - 83.5x83.5 size 2x scale for iPad

5. Build and Run. Done.

-----

**Speculid** ©2018, BrightDigit, LLC. 

[sketch-step-1]:       /images/svg-export/sketch/step-1.jpg "Sketch iOS App Icon Template Window"
[sketch-step-2]:       /images/svg-export/sketch/step-2.jpg "Sketch Slice Panel"
[sketch-step-3]:       /images/svg-export/sketch/step-3.jpg "Sketch Present Format"
[sketch-step-4]:       /images/svg-export/sketch/step-4.jpg "Sketch Export Menu"
[sketch-step-5]:       /images/svg-export/sketch/step-5.jpg "Sketch Export Window"
[photoshop-step-1]:    /images/svg-export/photoshop/step-1.jpg "Photoshop Export Menu"
[photoshop-step-2]:    /images/svg-export/photoshop/step-2.jpg "Photoshop Export Format"
[photoshop-step-3]:    /images/svg-export/photoshop/step-3.jpg "Photoshop Save Dialog"
[illustrator-step-1]:  /images/svg-export/illustrator/step-1.jpg "Illustrator Export Menu"
[illustrator-step-2]:  /images/svg-export/illustrator/step-2.jpg "Illustrator Export Format"
