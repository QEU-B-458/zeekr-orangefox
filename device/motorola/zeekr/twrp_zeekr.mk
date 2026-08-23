#
# Copyright (C) 2023 The Android Open Source Project
# Copyright (C) 2023 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
# These AOSP full-OS product includes are not present in the OrangeFox/TWRP
# minimal source tree (e.g. gsi_keys.mk is missing -> dumpvars/lunch fails).
# A recovery build does not need them; use -if-exists so a missing file is
# skipped silently instead of aborting the build.
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/gsi_keys.mk)
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/updatable_apex.mk)
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from zeekr device
$(call inherit-product, device/motorola/zeekr/device.mk)

PRODUCT_DEVICE := zeekr
PRODUCT_NAME := twrp_zeekr
PRODUCT_BRAND := motorola
PRODUCT_MODEL := motorola razr 40 ultra
PRODUCT_MANUFACTURER := motorola

# ===== Product 级变量 =====
# AOSP 预编译二进制对齐检查(magiskboot)关闭：
# Android 16 的 check_elf_file 要求 16384 对齐，上游预编译的 magiskboot 为 4096 对齐。
# 这是 AOSP 上游预编译在 A16 下的已知不兼容，关闭对齐检查绕过。
# 此变量属于 PRODUCT_* 命名空间，必须写在 product makefile (twrp_zeekr.mk) 中，
# 严禁写入 BoardConfig.mk（Board 阶段 Soong 解析时 Product 变量尚未生效，静默失效）。
PRODUCT_CHECK_PREBUILT_MAX_PAGE_SIZE := false

# Android 16 defaults PRODUCT_MAX_PAGE_SIZE_SUPPORTED to 16384, which makes
# check_elf_file reject the 4096-aligned prebuilt magiskboot. This SoC (SM8475)
# runs a 4K-page kernel, and a recovery does not need 16K page support, so pin
# the product to 4096 — this makes every 16K ELF-alignment check pass at once.
PRODUCT_MAX_PAGE_SIZE_SUPPORTED := 4096

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="zeekr_gu-user 13 T2TV33.45-83-2 b6410-dddbd9 release-keys"

BUILD_FINGERPRINT := motorola/zeekr_g/msi:13/T1TZ33M.3-62-45/fc8bb:user/release-keys
