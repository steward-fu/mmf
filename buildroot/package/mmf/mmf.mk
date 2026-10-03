MMF_SITE = $(TOPDIR)/package/mmf
MMF_SITE_METHOD = local

define MMF_INSTALL_TARGET_CMDS
	mkdir -p $(STAGING_DIR)/usr/include
	mkdir -p $(STAGING_DIR)/usr/lib

	cp -a $(@D)/include/. $(STAGING_DIR)/usr/include/
	cp -a $(@D)/lib/. $(STAGING_DIR)/usr/lib/
endef

$(eval $(generic-package))
