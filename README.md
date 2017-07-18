[![Build Status](https://travis-ci.org/openstreetmap/Nominatim.svg?branch=master)](https://travis-ci.org/openstreetmap/Nominatim)

Nominatim
=========

Nominatim (from the Latin, 'by name') is a tool to search OpenStreetMap data
by name and address (geocoding) and to generate synthetic addresses of
OSM points (reverse geocoding). An instance with up-to-date data can be found
at http://nominatim.openstreetmap.org. Nominatim is also used as one of the
sources for the Search box on the OpenStreetMap home page and powers the search
on the MapQuest Open Initiative websites.

Documentation
=============

More information about Nominatim, including usage and installation instructions,
can be found in the docs/ subdirectory and in the OSM wiki at:

http://wiki.openstreetmap.org/wiki/Nominatim

Installation
============

There are detailed installation instructions in the /docs directory.
Here is a quick summary of the necessary steps.

1. Compile Nominatim:

        mkdir build
        cd build
        cmake ..
        make

   For more detailed installation instructions see [docs/Installation.md](docs/Installation.md).
   There are also step-by-step instructions for
     [Ubuntu 16.04](docs/Install-on-Ubuntu-16.md) and
     [CentOS 7.2](docs/Install-on-Centos-7.md).

2. Get OSM data and import:

        ./build/utils/setup.php --osm-file <your planet file> --all

   Details can be found in [docs/Import_and_update.md](docs/Import-and-Update.md)

3. Point your webserver to the ./build/website directory.



License
=======

The source code is available under a GPLv2 license.

Contact and Bug reports
======================

For questions you can join the geocoding mailinglist, see
http://lists.openstreetmap.org/listinfo/geocoding

Bugs may be reported on the github project site:
https://github.com/openstreetmap/Nominatim
