# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils git-r3

DESCRIPTION="Open Source search based on OpenStreetMap data."
HOMEPAGE="https://github.com/andrew-aladev/Nominatim"
EGIT_REPO_URI="https://github.com/andrew-aladev/Nominatim.git"

LICENSE="GPL-2"
SLOT="0/9999"
KEYWORDS=""

IUSE="internal-osm2pgsql deploy doc test"

RDEPEND="
    sys-libs/zlib
    app-arch/bzip2
    dev-libs/libxml2
    dev-db/postgresql
    deploy? (
        !internal-osm2pgsql? ( sci-geosciences/osm2pgsql )
        dev-lang/php
        dev-php/PEAR-DB
    )
    test? (
        dev-db/postgresql[server]
        dev-lang/php[cgi]
        dev-php/phpunit
        =dev-lang/python-3*
        dev-python/behave
        dev-python/nose
        dev-python/pytidylib
        dev-python/psycopg:2
    )
"
DEPEND="${RDEPEND}"

src_configure() {
    local mycmakeargs=(
        -DEXTERNAL_OSM2PGSQL=$(usex !internal-osm2pgsql)

        -DBUILD_DEPLOY=$(usex deploy)
        -DBUILD_DOC=$(usex doc)
        -DBUILD_TESTS=$(usex test)
    )
    cmake-utils_src_configure
}
