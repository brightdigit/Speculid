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

## Related projects

### Dependencies

* `Requests <http://python-requests.org>`_
  — Python HTTP library for humans
* `Pygments <http://pygments.org/>`_
  — Python syntax highlighter

### Friends

* `jq <https://stedolan.github.io/jq/>`_
  — CLI JSON processor that
  works great in conjunction with HTTPie
* `http-prompt <https://github.com/eliangcs/http-prompt>`_
  —  interactive shell for HTTPie featuring autocomplete
  and command syntax highlighting


### Thanks

**hicat** © 2014+, Rico Sta. Cruz. Released under the [MIT License].<br>
Authored and maintained by Rico Sta. Cruz with help from [contributors].

> [ricostacruz.com](http://ricostacruz.com) &nbsp;&middot;&nbsp;
> GitHub [@rstacruz](https://github.com/rstacruz) &nbsp;&middot;&nbsp;
> Twitter [@rstacruz](https://twitter.com/rstacruz)

[MIT License]: http://mit-license.org/
[contributors]: http://github.com/rstacruz/hicat/contributors
[highlight.js]: http://highlightjs.org