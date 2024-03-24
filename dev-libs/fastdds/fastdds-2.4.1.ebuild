# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_ECLASS=cmake
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake

DESCRIPTION="The most complete DDS - Proven: Plenty of success cases."
HOMEPAGE="https://www.eprosima.com/"

LICENSE="Apache-2.0"
IUSE="debug test tools"
SLOT="0/$(ver_cut 1)"
PATCHES=(
	"${FILESDIR}/fix-cmake-libdir-${PV}.patch"
	"${FILESDIR}/fix-missing-headers-${PV}.patch"
)

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/eProsima/Fast-DDS.git"
	inherit git-r3
else
	SRC_URI="https://github.com/eProsima/Fast-DDS/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 x86"
	S="${WORKDIR}/Fast-DDS-${PV}"
fi

DEPEND="
	dev-cpp/asio
	dev-libs/tinyxml2
	dev-libs/foonathan-memory
	dev-libs/fastcdr
"
RDEPEND="${DEPEND}"
BDEPEND=""
RESTRICT="!test? ( test )"

src_configure() {
	CMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
	local mycmakeargs=(
		-DEPROSIMA_BUILD_TESTS=$(usex test 'ON' 'OFF')
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
	)
	cmake_src_configure
}

src_install() {
	# Some installation take effect outside the sandbox, remove it
	sed -i -e '/ln -s fast-discovery-server/d' ${BUILD_DIR}/tools/fds/cmake_install.cmake
	cmake_src_install
	# TODO: Get version from source or patch source code
	dosym fast-discovery-server-1.0.0 /usr/bin/fast-discovery-server
}
