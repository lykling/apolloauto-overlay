# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_ECLASS=cmake
inherit cmake

DESCRIPTION="eProsima FastCDR library provides two serialization mechanisms."
HOMEPAGE="https://www.eprosima.com/"

LICENSE="Apache-2.0"
IUSE="debug test"
SLOT="0/$(ver_cut 1)"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/eProsima/Fast-CDR.git"
	inherit git-r3
else
	SRC_URI="https://github.com/eProsima/Fast-CDR/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 x86"
	S="${WORKDIR}/Fast-CDR-${PV}"
fi

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DEPROSIMA_BUILD_TESTS=$(usex test 'ON' 'OFF')
		-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
	)
	cmake_src_configure
}
