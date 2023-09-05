# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker bash-completion-r1

DESCRIPTION="Apollo Environment Manager"
HOMEPAGE="https://apollo.baidu.com"
SRC_URI="https://apollo-pkg-beta.cdn.bcebos.com/apollo/core/pool/main/a/apollo-neo-env-manager-dev/apollo-neo-env-manager-dev_${PV/_/-}-${PR}_amd64.deb"

LICENSE="Apache-2.0"
IUSE=""
SLOT="0"
KEYWORDS="amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_install() {
  insinto /opt/apollo
  doins -r "${S}"/opt/apollo/neo
  fperms 0755 /opt/apollo/neo/packages/env-manager-dev/${PV/_/-}-${PR}/entry/apollo-env-manager.sh
  scripts=($(ls "${S}"/opt/apollo/neo/packages/env-manager-dev/${PV/_/-}-${PR}/scripts))
  fperms 0755 ${scripts[@]/#//opt/apollo/neo/packages/env-manager-dev/${PV/_/-}-${PR}/scripts/}
  dosym -r /opt/apollo/neo/packages/env-manager-dev/${PV/_/-}-${PR} /opt/apollo/neo/packages/env-manager-dev/latest
  dosym -r /opt/apollo/neo/packages/env-manager-dev/latest/entry/apollo-env-manager.sh /usr/bin/aem
  newbashcomp "${S}"/opt/apollo/neo/packages/env-manager-dev/${PV/_/-}-${PR}/scripts/auto_complete.bash ${PN}

  insinto /usr/share/zsh/site-functions
  newins "${S}"/opt/apollo/neo/packages/env-manager-dev/${PV/_/-}-${PR}/scripts/auto_complete.zsh _aem
}
