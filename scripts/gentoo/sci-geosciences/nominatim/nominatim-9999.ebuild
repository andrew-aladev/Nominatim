# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit cmake-utils git-2

DESCRIPTION="Open Source search based on OpenStreetMap data."
HOMEPAGE="https://github.com/andrew-aladev/Nominatim"
EGIT_REPO_URI="https://github.com/andrew-aladev/Nominatim.git"

LICENSE="GPL-2"
SLOT="0/9999"
KEYWORDS=""

IUSE="internal-osm2pgsql test"

RDEPEND="
    sys-libs/zlib
    app-arch/bzip2
    dev-libs/libxml2
    dev-db/postgresql
    !internal-osm2pgsql? ( sci-geosciences/osm2pgsql )
    test? (
        dev-python/behave
        dev-python/nose
        dev-python/pip
        dev-python/pytidylib
        dev-python/psycopg:2
        dev-php/phpunit
    )
"
DEPEND="${RDEPEND}"

src_unpack() {
    git-2_src_unpack
}

src_configure() {
    local mycmakeargs=(
        $(cmake-utils_use !internal-osm2pgsql EXTERNAL_OSM2PGSQL)
        $(cmake-utils_use test                BUILD_TESTS)
    )
    cmake-utils_src_configure
}

src_test() {
    pip install lettuce || die "lettuce is required"
    cmake-utils_src_test
}

src_install() {
    cmake-utils_src_install
}
