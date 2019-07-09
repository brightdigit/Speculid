[{{ site.github.project_tagline }}](#){:class="html-only"}

<!--ts-->

<!--te-->

# Introduction

## Challenges Managing Graphic Assets

Part of the process of building an app for **watchOS**, **iOS**, or **macOS** is including all the image assets and app icons  in your application. Each image assets or app icons requires **several copies for different resolutions, different devices, and different sizes.** Right now, this needs to be done by exporting all the various similar images from a major graphics application. 

That means developers need to:

<section class="cards" markdown="1">

<section class="card half" markdown="1">

![Multiple Images](/images/mechanic.svg){:height="100px"}{:class="html-only"}

### <img class="readme-only" src="/images/mechanic.svg" height="25pt"/> Manually Create Multiple Sizes

Each graphic must be **manually converted and resized several times for each update**.

</section>
<section class="card half" markdown="1">

![Multiple Images](/images/archive.svg){:height="100px"}{:class="html-only"}

### <img class="readme-only" src="/images/archive.svg" height="25pt"/> Store Generated Image Files

An asset catalog image set will need a 1x, 2x, 3x of each graphic and **App Icons may need as many 30 different sizes**.

</section>
</section>

### What If You Had...

<section class="cards" markdown="1">

<section class="card whole" markdown="1">

![Multiple Images](/images/emoji.svg){:height="100px"}{:class="html-only"}
![Multiple Images](/images/emoji.svg){:height="75px"}{:class="html-only"}
![Multiple Images](/images/emoji.svg){:height="50px"}{:class="html-only"}
![Multiple Images](/images/emoji.svg){:height="25px"}{:class="html-only"}
![Multiple Images](/images/emoji.svg){:height="12px"}{:class="html-only"}
![Multiple Images](/images/emoji.svg){:height="6px"}{:class="html-only"}

<img class="readme-only" src="/images/emoji.svg" height="100px"/><img class="readme-only" src="/images/emoji.svg" height="75px"/><img class="readme-only" src="/images/emoji.svg" height="50px"/><img class="readme-only" src="/images/emoji.svg" height="25px"/><img class="readme-only" src="/images/emoji.svg" height="12px"/><img class="readme-only" src="/images/emoji.svg" height="6px"/>

#### Care-Free Graphic Management Where...

* **Only one file is needed** _for each Image Set and App Icon._
* **Graphic Designers need only export a single file change** _each time rather than as many as serveral scaled copies._
* **Resizing and conversion is done behind the scenes** _based on a single source image._

</section>
</section>

## What Speculid Does

**Speculid** links a single graphic file to an Image Set or App Icon and automatically renders different resolutions, file types, and sizes for all the image specifications required.

![diagram](/images/Diagram.png)

<section class="cards" markdown="1">
<section class="card half" markdown="1">

![Multiple Images](/images/machinery.svg){:height="100px"}{:class="html-only"}

### <img class="readme-only" src="/images/machinery.svg" height="25pt"/> Automate the process 

Speculid automates the process so **only one graphic file is needed**. Add Speculid to your build process and now the **conversions and resizing are automated** as part of the build process. Now there is no need for anyone to manually create each size for each device every time.

</section>
<section class="card half" markdown="1">

![Multiple Images](/images/clean-code.svg){:height="100px"}{:class="html-only"}

### <img class="readme-only" src="/images/clean-code.svg" height="25pt"/> Tidy Your Repo

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

<!-- HTML-ONLY BEGIN -->
# Documentation

* TOC
{:toc}

<!-- HTML-ONLY END -->


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

**Speculid** only supports being called through a command line terminal for now. Once you have copied the command to your */usr/local/bin* folder you should be able to access it easily.

```bash
$ speculid --process <file>
$ speculid --help
$ speculid --version

Options:
  --help     Show this screen.
  --version  Show version.
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

![Image Set Examples from Xcode](/images/SetExample.png){:height="240"}

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
![Sketch Logo](images/svg-export/sketch/logo.svg){:class="logo"}{:class="html-only"} 

### <img class="readme-only" src="/images/svg-export/sketch/logo.svg" height="25pt"/> Sketch 
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
![Photoshop Logo](images/svg-export/photoshop/logo.svg){:class="logo"}{:class="html-only"}

### <img class="readme-only" src="/images/svg-export/photoshop/logo.svg" height="25pt"/> Photoshop
</header>

![Photoshop Export Menu][photoshop-step-1]
1. Open your **Photoshop** document and select **File** > **Export** > **Export As...**.

    ![Photoshop Export Format][photoshop-step-2]
2. Under the **File Settings** on the right, change the format to **SVG**.

    ![Photoshop Save Dialog][photoshop-step-3]
3. Select **Export All** and choose the destination for your **SVG file** and **Save**.

<header markdown="1">
![Illustrator Logo](images/svg-export/illustrator/logo.svg){:class="logo"}{:class="html-only"}

### <img class="readme-only" src="/images/svg-export/illustrator/logo.svg" height="25pt"/> Illustrator
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

    ![Xcode Target Membership](/images/XcodeTargetMembership.png)

    * *Note: you don't need to add these files to any target membership*

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
    find "${SRCROOT}" -name "*.speculid" -print0 |
    while IFS= read -r -d $'\0' line; do
    speculid --process "$line" &
    done
    wait
    ```
    ![Xcode Build Phase Run Script](/images/XcodeBuildPhaseRunScript.jpg)

    If you are using [fastlane](https://fastlane.tools) to build your application. You can [use the plugin to build every `.speculid` file in your directory](\#fastlane-integration).

3. **Build the application.** This will create the graphics which you will use in your asset image set or app icon.

    ![Xcode Unorganized Assets](/images/XcodeUnorganizedAssets.png)

4. **After the first build**, drag the images to the correct asset slot. Each rendered image file is suffixed denoting its slot.

    *(source file base name)*.*(size)*@*(scale)*~*(idiom)*.(extension)

    **Examples**

    * **logo.20x20@1x~ipad.png** - 20x20 size 1x scale for iPad
    * **logo.60x60@3x~iphone.png** - 60x60 size 3x scale for iPhone
    * **logo.83.5x83.5@2x~ipad.png** - 83.5x83.5 size 2x scale for iPad

5. **Build, Run, and Done!**

-----

**Speculid** ©2019, BrightDigit, LLC. 

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
