

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
      * [Email Signup](#email-signup)
      * [Homebrew](#homebrew)
      * [Github Releases](#github-releases)
   * [Installation](#installation)
      * [Fastlane Integration](#fastlane-integration)
   * [Usage](#usage)
      * [File Format and Properties](#file-format-and-properties)
         * [Set](#set)
         * [Source](#source)
         * [Geometry <em>optional</em>](#geometry-optional)
         * [Background <em>optional</em>](#background-optional)
         * [Remove Alpha <em>optional</em>](#remove-alpha-optional)
      * [Exporting SVGs for Speculid](#exporting-svgs-for-speculid)
         * [<a href="https://camo.githubusercontent.com/c4927857dc237bf89384c088d756947123fc99ac/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f7376672d6578706f72742f736b657463682f6c6f676f2e737667" target="_blank" rel="nofollow"><img src="https://camo.githubusercontent.com/c4927857dc237bf89384c088d756947123fc99ac/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f7376672d6578706f72742f736b657463682f6c6f676f2e737667" height="25pt" data-canonical-src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/svg-export/sketch/logo.svg" style="max-width:100\x;"></a> Sketch](#-sketch)
         * [<a href="https://camo.githubusercontent.com/9d31aa3af7de5ff522c42117c2a5b6bd631ed636/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f7376672d6578706f72742f70686f746f73686f702f6c6f676f2e737667" target="_blank" rel="nofollow"><img src="https://camo.githubusercontent.com/9d31aa3af7de5ff522c42117c2a5b6bd631ed636/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f7376672d6578706f72742f70686f746f73686f702f6c6f676f2e737667" height="25pt" data-canonical-src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/svg-export/photoshop/logo.svg" style="max-width:100\x;"></a> Photoshop](#-photoshop)
         * [<a href="https://camo.githubusercontent.com/b12eea760a21557d856ae2c3a0dcfc65070fe560/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f7376672d6578706f72742f696c6c7573747261746f722f6c6f676f2e737667" target="_blank" rel="nofollow"><img src="https://camo.githubusercontent.com/b12eea760a21557d856ae2c3a0dcfc65070fe560/68747470733a2f2f72617763646e2e6769746861636b2e636f6d2f62726967687464696769742f53706563756c69642f6d61737465722f696d616765732f7376672d6578706f72742f696c6c7573747261746f722f6c6f676f2e737667" height="25pt" data-canonical-src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/svg-export/illustrator/logo.svg" style="max-width:100\x;"></a> Illustrator](#-illustrator)
      * [Xcode Integration and Automation](#xcode-integration-and-automation)

<!-- Added by: leo, at: Mon Apr 13 19:50:41 EDT 2020 -->

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

![Speculid In Use](https://rawcdn.githack.com/brightdigit/Speculid/master/images/Speculid-In-Use.gif)

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

This means **Speculid** can...

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

There are 3 ways to download Speculid: Email Signup, Homebrew, and Github Releases:

## Email Signup

Email signup allows for you to get delivered updates to your email box of new features and updates...

<section class="signup-form-container">
  <div><strong>Sign up below</strong> to get the latest version.</div>
<form action="//brightdigit.us12.list-manage.com/subscribe/post-json?u=cb3bba007ed171091f55c47f0&amp;id=19a8f55024" class="signup-form" method="post">
  <div class="row">
  <input type="email" placeholder="Your Email Address" value="" name="EMAIL" id="mce-EMAIL" required>
  <input type="submit" value="Sign Up">
  </div>
</form>
<div class="message">
  &nbsp;
</div>
</section>

<div class="readme-only" markdown="1">
To download <strong>Speculid</strong>, enter your email address <a href="https://speculid.com#download">here</a> to request access to the latest version.
</div>

## Homebrew

If you are already using [Homebrew](https://brew.sh), installing via the homebrew command allows for easy installation as well as staying up-to-date on new releases. To install, type:

```bash
brew cask install brightdigit/speculid/speculid
```

This will automatically install the terminal command for easy scripting.

## Github Releases

You can directly download the application from the Github Repo releases page.

<a href="{{ site.github.zip_url }}" class="btn">Download .zip</a>
<a href="{{ site.github.tar_url }}" class="btn">Download .tar.gz</a>




# Installation

Once you have downloaded the zip file (i.e *Not Homebrew*), go ahead and **copy the application *Speculid.App* to the Applications folder**.

A command line tool is included in the application bundle. Copy the command line tool to your /bin/ folder:

```base
$ sudo cp /Applications/Speculid.app/Contents/SharedSupport/speculid /usr/local/bin
```

## Fastlane Integration

Once you have the application installed, if you are using [Fastlane](https://fastlane.tools), you can integrate with your actions, by adding the plugin after installation:

```bash
fastlane add_plugin speculid
```

Then in your `Fastfile` add `speculid` to your action:

```ruby
default_platform(:ios)

platform :ios do
  desc "Application Build"
  lane :build do
    ...
    speculid
    ...
  end
end
```

# Usage

<iframe width="560" height="315" src="https://www.youtube.com/embed/Mn4pknYqzH0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" style="display: block; margin: auto;" allowfullscreen></iframe>

**Speculid** only supports being called through a command line terminal for now. Once you have copied the command to your */usr/local/bin* folder you should be able to access it easily.

```bash
$ speculid # opens file dialog in macOS
$ speculid --process <file>
$ speculid --initialize <set-folder> <source-file> <destination-speculid-file>
$ speculid --help
$ speculid --version

Options:
--help            Show this screen.
--version         Show version.
--process <file>  Process the *.speculid file
--initialize ...  Create a new .speculid file with the source image, set folder path, destination speculid files
```

## File Format and Properties

The `.speculid` file is a `json` file with the image set or app icon path, the graphic file source, and optionally basic image geometry (width or height). All paths specified in the json file could be relative to the `.speculid` file `Assets.xcassets/Raster Image.imageset` or an absolute path `/Users/leo/Documents/Projects/Speculid/examples/Assets/Assets.xcassets/Raster Image.imageset`.

Here are some examples of a `.speculid` file:

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

### Set 
`set`

![Image Set Examples from Xcode](https://rawcdn.githack.com/brightdigit/Speculid/master/images/SetExample.png)

Set is the path to the Image Set or App Icon folder used by Xcode. For more information on Image Sets, App Icons, and Asset Catalogs, check out [this article here](https://learningswift.brightdigit.com/asset-catalogs-image-sets-app-icons/).

### Source 
`source`

The path to the image source file. This can be either a SVG or PNG file.

### Geometry *optional* 
`geometry`

The destination geometry of image if needed (i.e. image set). It must be in the format of:

* *width* (ex. "128") - for specifying the width of the destination image
* x*height* (ex. "x128") - for specifying the height of the destination image

You can only specify the height or the width. The other dimension is automatically calculated based on the aspect ratio of the image.

### Background *optional* 
`background`

**App Icons are required to exclude any alpha channels**. In order to remove a transparency from a source PNG or SVG file, you can specify to remove the alpha channel and add a background color. 

The background color can be set in a standard rgb, rgba, or hex code format (#RRGGBB or #AARRGGBB). If no alpha is specified an alpha of 1.0 is assumed.

### Remove Alpha *optional*  
`remove-alpha`

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
4. In the top menu, select **File** > **Export**. 

    ![Sketch Export Window][sketch-step-5]
5. Select your duplicated slice and select **Export**.

6. Select the destination for your **SVG file** and **Save**.


<header markdown="1">


### <img class="readme-only" src="https://rawcdn.githack.com/brightdigit/Speculid/master/images/svg-export/photoshop/logo.svg" height="25pt"/> Photoshop
</header>

![Photoshop Export Menu][photoshop-step-1]
1. Open your **Photoshop** document and select **File** > **Export** > **Export As...**.

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

With **Speculid**, the process of building image assets can be automated in **Xcode**. Here is how to setup your project the first time:

1. **Create the speculid file** and add it to your project folder, along with your source graphic files.

    ![Xcode Target Membership](https://rawcdn.githack.com/brightdigit/Speculid/master/images/XcodeTargetMembership.png)

    *Note: you don't need to add these files to any target membership*

    **NEW *skip to step 4* and use the `--initialize` flag:**

      ```
      $ speculid --initialize \
        "Assets.xcassets/iOS AppIcon.appiconset" geometry.svg app-icon.speculid
      ```

2. In the speculid file, **Add the property for the source** - the path to the SVG or PNG file.
  ```json
  {
    "source" : "geometry.svg",
    ...
  }
  ```
3. In the speculid file, **Add the property for the set** - the path to the Image Set or App Icon folder.
  ```json
  {
    "set" : "Assets.xcassets/iOS AppIcon.appiconset",
    ...
  }
  ```
4. *optional* In the speculid file, **Add the property for the geometry** - if this a conversion from a vector graphic (SVG) to an Image Set, you may want to supply the *1x* size.
  ```json
  {
    "set" : "Assets.xcassets/Raster Image.imageset",
    "source" : "layers.png",
    "geometry" : "128"
  }
  ```

    If you specify *128* in the *geometry* property, that means the width for the *1x* image will be *128 pixels*, the width for the *2x* image will be *256 pixels*, and the width for the *3x* image will be *384 pixels*. Heights will be calculated based on the aspect ratio of the SVG file.

    Vector images in an image set will be converted to a iOS compatible PDF file.
        
5. *optional* In the speculid file, **Add the properties for the background color and alpha removal** - if this a conversion to an App Icon, you should remove any background transparency and add a background color.
  ```json
  {
    "set" : "Assets.xcassets/iOS AppIcon.appiconset",
    "source" : "geometry.svg",
    "background" : "#FFFFFFFF",
    "remove-alpha" : true
  }
  ```

    See the [file format section](#file-format-and-properties) for more details.

2. **Add the *Run Script* Build Phase** to the top of your project with the following code:

    ```bash
    speculid --process "${SRCROOT}"
    ```
    ![Xcode Build Phase Run Script](https://rawcdn.githack.com/brightdigit/Speculid/master/images/XcodeBuildPhaseRunScript.jpg)

    If you are using [fastlane](https://fastlane.tools) to build your application. You can [use the plugin to build every `.speculid` file in your directory](\#fastlane-integration).

3. **Build the application.** This will create the graphics which you will use in your asset image set or app icon.

    ![Xcode Unorganized Assets](https://rawcdn.githack.com/brightdigit/Speculid/master/images/XcodeUnorganizedAssets.png)

    If the asset catalog does not already have file names for each image in the asset, Speculid will automatically update the asset catalog and name the files using the following pattern:

    *(source file base name)*.*(size)*@*(scale)*~*(idiom)*.(extension)

    **Examples**

    * **logo.20x20@1x~ipad.png** - 20x20 size 1x scale for iPad
    * **logo.60x60@3x~iphone.png** - 60x60 size 3x scale for iPhone
    * **logo.83.5x83.5@2x~ipad.png** - 83.5x83.5 size 2x scale for iPad

5. **Enjoy!**

-----

**Speculid**  ©2020, BrightDigit, LLC. 

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
