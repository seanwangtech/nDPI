
include $(TOPDIR)/rules.mk

PKG_NAME:=ndpi
PKG_RELEASE:=0
PKG_VERSION:=2.1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/ntop/nDPI.git
PKG_SOURCE_VERSION:=f664aee00b9610509f8bb217a9c0c6c209e0ea91
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_PROTO:=git

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/ndpi
  SECTION:=net
  CATEGORY:=Network
  TITLE:=nDPI library
  URL:=https://github.com/ntop/nDPI/
  DEPENDS:=+libc +libjson-c +libpcap +libpthread 
  MAINTAINER:=Xiao Wang <xwangai@essex.ac.uk>
endef

define Package/ndpi/description
  nDPI is a ntop-maintain library
endef


define Build/Prepare
	$(call Build/Prepare/Default)
endef

CONFIGURE_ARGS += \
        --with-pic \
	--target=$(GNU_TARGET_NAME) \
        --host=$(GNU_TARGET_NAME) \
        --build=$(GNU_HOST_NAME) 

ifneq ($(CONFIG_USE_EGLIBC),)
  TARGET_CPPFLAGS += -I$(STAGING_DIR)/usr/include 
endif


MAKE_FLAGS += \
	KERNEL_DIR=$(LINUX_DIR) \
	NDPI_PATH=$(PKG_BUILD_DIR) \
	ARCH="$(LINUX_KARCH)" \
	CROSS_COMPILE="$(TARGET_CROSS)" 


define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/

	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libndpi.{a,so*} $(1)/usr/lib/
endef

define Package/ndpi/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libndpi.so* $(1)/usr/lib/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/ndpiReader $(1)/usr/bin/ndpiReader
endef

$(eval $(call BuildPackage,ndpi))
