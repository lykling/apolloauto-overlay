# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake

DESCRIPTION="STL compatible C++ memory allocator library using a new \
	RawAllocator concept that is similar to an Allocator but easier to use and write."
HOMEPAGE="https://memory.foonathan.net/"

LICENSE="ZLIB"
IUSE="debug test"
SLOT="0/$(ver_cut 1)"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/foonathan/memory.git"
	inherit git-r3
else
	SRC_URI="https://github.com/foonathan/memory/archive/refs/tags/v${PV}-${PR#r}.tar.gz -> ${PF}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/memory-${PV}-${PR#r}"
fi

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DFOONATHAN_MEMORY_BUILD_TESTS=$(usex test 'ON' 'OFF')
		-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
	)
	cmake_src_configure
}
