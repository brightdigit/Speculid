# hicat :cat:

<img src="http://ricostacruz.com/hicat/hicat.gif">

`cat` with syntax highlighting. The language is auto-detected through the file 
extension.

    hicat index.js

Pipe something to `hicat`. The language will be inferred from the contents.

    curl http://site.com | hicat

If hicat fails to detect a language, specify it using `-l LANG`.

    curl http://site.com | hicat -l xml

[![Status](https://travis-ci.org/rstacruz/hicat.svg?branch=master)](https://travis-ci.org/rstacruz/hicat)  

Installation
------------

    $ npm install -g hicat

[![npm version](https://badge.fury.io/js/hicat.svg)](https://npmjs.org/package/hicat "View this project on npm")

Usage:

    $ hicat --help

      Usage:
          hicat [options] FILE
          ... | hicat [options]

      Options:
          -h, --help         print usage information
          -v, --version      show version info and exit
          -l, --lang LANG    use a given language
              --languages    list available languages
              --no-pager     disable the pager

Tips and tricks
---------------

Add an alias to your `~/.bashrc` to save a few keystrokes.

    alias hi=hicat

Btw
---

[highlight.js] powers the syntax highlighter engine.

Thanks
------

**hicat** © 2014+, Rico Sta. Cruz. Released under the [MIT License].<br>
Authored and maintained by Rico Sta. Cruz with help from [contributors].

> [ricostacruz.com](http://ricostacruz.com) &nbsp;&middot;&nbsp;
> GitHub [@rstacruz](https://github.com/rstacruz) &nbsp;&middot;&nbsp;
> Twitter [@rstacruz](https://twitter.com/rstacruz)

[MIT License]: http://mit-license.org/
[contributors]: http://github.com/rstacruz/hicat/contributors
[highlight.js]: http://highlightjs.org


[![header](https://raw.githubusercontent.com/brightdigit/speculid/assets/images/Logo.png)]
########################################
Speculid: Build Xcode Assets from Image Files
########################################

.. class:: no-web

    HTTPie (pronounced *aitch-tee-tee-pie*) is a **command line HTTP client**.
    Its goal is to make CLI interaction with web services as **human-friendly**
    as possible. It provides a simple ``http`` command that allows for sending
    arbitrary HTTP requests using a simple and natural syntax, and displays
    colorized output. HTTPie can be used for **testing, debugging**, and
    generally **interacting** with HTTP servers.


    .. image:: https://raw.githubusercontent.com/jkbrzt/httpie/master/httpie.png
        :alt: HTTPie compared to cURL
        :width: 100%
        :align: center





.. class:: no-web no-pdf

|pypi| |unix_build| |windows_build| |coverage| |gitter|



.. contents::

.. section-numbering::

.. raw:: pdf

   PageBreak oneColumn


=============
Main features
=============

* Parse App Icon and Image Sets
* Convert SVG Files to Designated Size
* Resize Raster Images to Designated Size
* Command-Line Capabilities for Creating Build Phase Scripts
* Mac OS X 10.10+ support
* Documentation
* Test coverage


============
Installation
============


Speculid can be installed via `Homebrew <http://brew.sh/>`_
(recommended):

.. code-block:: bash

    $ brew tap brightdigit/homebrew-core
    $ brew install speculid

=====
Usage
=====

  spcld <file>
  spcld -h | --help
  spcld --version

Options:
  -h --help     Show this screen.
  --version     Show version.

Hello World:


.. code-block:: bash

    $ http httpie.org


Synopsis:

.. code-block:: bash

    $ http [flags] [METHOD] URL [ITEM [ITEM]]


See also ``http --help``.


--------
Examples
--------

Custom `HTTP method`_, `HTTP headers`_ and `JSON`_ data:

.. code-block:: bash

    $ http PUT example.org X-API-Token:123 name=John


Submitting `forms`_:

.. code-block:: bash

    $ http -f POST example.org hello=World


See the request that is being sent using one of the `output options`_:

.. code-block:: bash

    $ http -v example.org


Use `Github API`_ to post a comment on an
`issue <https://github.com/jkbrzt/httpie/issues/83>`_
with `authentication`_:

.. code-block:: bash

    $ http -a USERNAME POST https://api.github.com/repos/jkbrzt/httpie/issues/83/comments body='HTTPie is awesome! :heart:'


Upload a file using `redirected input`_:

.. code-block:: bash

    $ http example.org < file.json


Download a file and save it via `redirected output`_:

.. code-block:: bash

    $ http example.org/file > file


Download a file ``wget`` style:

.. code-block:: bash

    $ http --download example.org/file

Use named `sessions`_ to make certain aspects or the communication persistent
between requests to the same host:

.. code-block:: bash

    $ http --session=logged-in -a username:password httpbin.org/get API-Key:123

    $ http --session=logged-in httpbin.org/headers


Set a custom ``Host`` header to work around missing DNS records:

.. code-block:: bash

    $ http localhost:8000 Host:example.com

..

------------
User support
------------

Please use the following support channels:

* `GitHub issues <https://github.com/jkbr/httpie/issues>`_
  for bug reports and feature requests.
* `Our Gitter chat room <https://gitter.im/jkbrzt/httpie>`_
  to ask questions, discuss features, and for general discussion.
* `StackOverflow <https://stackoverflow.com>`_
  to ask questions (please make sure to use the
  `httpie <http://stackoverflow.com/questions/tagged/httpie>`_ tag).
* Tweet directly to `@clihttp <https://twitter.com/clihttp>`_.
* You can also tweet directly to `@jkbrzt`_.


----------------
Related projects
----------------

Dependencies
~~~~~~~~~~~~

* `Requests <http://python-requests.org>`_
  — Python HTTP library for humans
* `Pygments <http://pygments.org/>`_
  — Python syntax highlighter

Friends
~~~~~~~

* `jq <https://stedolan.github.io/jq/>`_
  — CLI JSON processor that
  works great in conjunction with HTTPie
* `http-prompt <https://github.com/eliangcs/http-prompt>`_
  —  interactive shell for HTTPie featuring autocomplete
  and command syntax highlighting


----------
Contribute
----------

See `CONTRIBUTING <https://github.com/jkbrzt/httpie/blob/master/CONTRIBUTING.rst>`_.


----------
Change log
----------

See `CHANGELOG <https://github.com/jkbrzt/httpie/blob/master/CHANGELOG.rst>`_.


-------
Artwork
-------

See `claudiatd/httpie-artwork`_


-------
Licence
-------

BSD-3-Clause: `LICENSE <https://github.com/jkbrzt/httpie/blob/master/LICENSE>`_.



-------
Authors
-------

`Jakub Roztocil`_  (`@jkbrzt`_) created HTTPie and `these fine people`_
have contributed.


.. _pip: http://www.pip-installer.org/en/latest/index.html
.. _Github API: http://developer.github.com/v3/issues/comments/#create-a-comment
.. _these fine people: https://github.com/jkbrzt/httpie/contributors
.. _Jakub Roztocil: http://roztocil.co
.. _@jkbrzt: https://twitter.com/jkbrzt
.. _claudiatd/httpie-artwork: https://github.com/claudiatd/httpie-artwork


.. |pypi| image:: https://img.shields.io/pypi/v/httpie.svg?style=flat-square&label=latest%20stable%20version
    :target: https://pypi.python.org/pypi/httpie
    :alt: Latest version released on PyPi

.. |coverage| image:: https://img.shields.io/coveralls/jkbrzt/httpie/master.svg?style=flat-square&label=coverage
    :target: https://coveralls.io/r/jkbrzt/httpie?branch=master
    :alt: Test coverage

.. |unix_build| image:: https://img.shields.io/travis/jkbrzt/httpie/master.svg?style=flat-square&label=unix%20build
    :target: http://travis-ci.org/jkbrzt/httpie
    :alt: Build status of the master branch on Mac/Linux

.. |windows_build|  image:: https://img.shields.io/appveyor/ci/jkbrzt/httpie.svg?style=flat-square&label=windows%20build
    :target: https://ci.appveyor.com/project/jkbrzt/httpie
    :alt: Build status of the master branch on Windows

.. |gitter| image:: https://badges.gitter.im/jkbrzt/httpie.svg
    :target: https://gitter.im/jkbrzt/httpie
    :alt: Chat on Gitter

