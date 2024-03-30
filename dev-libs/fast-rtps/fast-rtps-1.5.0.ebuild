# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The most complete DDS - Proven: Plenty of success cases."
CMAKE_ECLASS=cmake
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake toolchain-funcs

HOMEPAGE="https://www.eprosima.com/"

LICENSE="Apache-2.0"
IUSE="android +thirdparty_asio +thirdparty_fastcdr +thirdparty_tinyxml2 debug test"
SLOT="0/$(ver_cut 1)"
PATCHES=(
  "${FILESDIR}/FastRTPS_${PV}.patch"
  "${FILESDIR}/fix-tinyxml2_ld_issue-${PV}.patch"
)
KEYWORDS="amd64 arm arm64 x86"

EGIT_REPO_URI="https://github.com/eProsima/Fast-DDS.git"
EGIT_COMMIT="v1.5.0"
EGIT_SUBMODULES=("-*")
inherit git-r3

DEPEND="
!thirdparty_asio? ( dev-cpp/asio )
!thirdparty_fastcdr? ( dev-libs/fastcdr )
!thirdparty_tinyxml2? ( dev-libs/tinyxml2 )
"
RDEPEND="${DEPEND}"
BDEPEND=""
RESTRICT="!test? ( test )"

src_unpack() {
  local EGIT_SUBMODULES=(
    thirdparty/idl
    $(usex thirdparty_asio thirdparty/asio "")
    $(usex thirdparty_fastcdr thirdparty/fastcdr "")
    $(usex thirdparty_tinyxml2 thirdparty/tinyxml2 "")
    $(usex android thirdparty/android-ifaddrs "")
  )
  elog "EGIT_SUBMODULES: ${EGIT_SUBMODULES[@]}"
  git-r3_src_unpack
}

src_configure() {
  CMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
  local mycmakeargs=(
    $(use android "-DANDROID=ON")
    -DEPROSIMA_BUILD=ON
    -DEPROSIMA_BUILD_TESTS=$(usex test 'ON' 'OFF')
    -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/local/fast-rtps"
  )
  cmake_src_configure
}
