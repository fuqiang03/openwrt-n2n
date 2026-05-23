#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=n2n
PKG_VERSION:=3.0.1
PKG_RELEASE:=5

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/ntop/n2n.git
PKG_SOURCE_DATE:=2026-03-03
PKG_SOURCE_VERSION:=31936c8728028ae9bc60e47267cfd5f890b71d06
PKG_MIRROR_HASH:=a4feb027252e222119f92a53c5a4e3443a2b6f19c52151f82f738667bdf00b08

PKG_LICENSE:=GPL-3.0
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Emanuele Faranda <faranda@ntop.org>

include $(INCLUDE_DIR)/package.mk

define Package/n2n/template
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  TITLE:=N2N Peer-to-peer VPN
  URL:=http://www.ntop.org/n2n
  DEPENDS:=+libopenssl +libpthread +libzstd
endef

define Package/n2n
  $(call Package/n2n/template)
  DEPENDS+=+libcap +kmod-tun +resolveip
endef

define Package/n2n/description
  This package contains client node and supernode for the N2N infrastructure.
endef

define Package/n2n/conffiles
/etc/config/n2n
endef

define Package/n2n-utils
  $(call Package/n2n/template)
  TITLE+= (Utilities)
  DEPENDS+=+n2n +libpcap
endef

define Package/n2n-utils/description
  This package contains extend utilities for the N2N infrastructure.
endef

define Package/n2n/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/edge $(1)/usr/sbin/n2n-edge
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/supernode $(1)/usr/sbin/n2n-supernode
endef

define Package/n2n-utils/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/utils/n2n-benchmark $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/utils/n2n-decode $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/utils/n2n-keygen $(1)/usr/bin/
endef

define Build/Configure
	(cd $(PKG_BUILD_DIR); autoreconf -f -i -Wall,no-obsolete)
	$(call Build/Configure/Default)
endef

$(eval $(call BuildPackage,n2n))
$(eval $(call BuildPackage,n2n-utils))