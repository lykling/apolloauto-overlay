# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-utils

DESCRIPTION="STL compatible C++ memory allocator library using a new \
	RawAllocator concept that is similar to an Allocator but easier to use and write."
HOMEPAGE="https://memory.foonathan.net/"

LICENSE="Zlib"
IUSE="test"
SLOT="0/$(ver_cut 1)"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/foonathan/memory.git"
	inherit git-r3
else
	SRC_URI="https://github.com/foonathan/memory/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
	S="${WORKDIR}/memory-${PV}"
fi

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DFOONATHAN_MEMORY_BUILD_TESTS=$(usex test 'ON' 'OFF')
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
