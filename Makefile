/*
 *  Minimalistic (auto) mount daemon
 *  Copyright (C) 2015  Ernest Vogelsang <stagprom@posteo.de>
 * 
 *  This file is part of mmountd.
 * 
 *  mmountd is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  mmountd is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 * 
 *  You should have received a copy of the GNU General Public License
 *  along with mmountd.  If not, see <http://www.gnu.org/licenses/>.
 * 
 *  Original provided by fon.com
 *  Copyright (C) 2009 John Crispin <blogic@openwrt.org> 
 *
 */
 

include $(TOPDIR)/rules.mk

PKG_NAME:=mmountd
PKG_VERSION:=v0.1.0

PKG_RELEASE=$(PKG_SOURCE_VERSION)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/stagprom/mmountd.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=ede7b0a72f4ecac510288775e40c77890fed7038
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

CMAKE_INSTALL:=1

PKG_MAINTAINER:=stagprom <stagprom@posteo.de>
PKG_CHECK_FORMAT_SECURITY:=0
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/mmountd
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=OpenWrt minimal automount daemon
  DEPENDS:=@USB_SUPPORT +kmod-usb-storage +kmod-fs-autofs4 +libpthread
  URL:=https://github.com/stagprom/mmountd
endef

define Package/mmountd/description
  openwrt minimal automount daemon
endef

define Package/mmountd/conffiles
/etc/config/mmountd
endef

TARGET_CFLAGS += -ggdb3

define Package/mmountd/install
	$(INSTALL_DIR) $(1)/sbin/ $(1)/etc/config/ $(1)/etc/init.d/ $(1)/etc/hotplug.d/block/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/mmountd $(1)/sbin/
	$(INSTALL_BIN) ./files/mmountd-led-helper $(1)/sbin/
	$(INSTALL_DATA) ./files/mmountd.config $(1)/etc/config/mmountd
	$(INSTALL_BIN) ./files/mmountd.init $(1)/etc/init.d/mmountd
	$(INSTALL_BIN) ./files/50-mmountd $(1)/etc/hotplug.d/block/50-mmountd
endef

$(eval $(call BuildPackage,mmountd))
