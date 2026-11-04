#!/bin/bash
# =================================================================
# FanchmWrt for Xiaomi AX3600 (Big Partition 240MB / Kwrt Matching)
# DIY Script Part 2
# =================================================================

echo ">>> 正在注入小米 AX3600 大分区核心优化..."

# 1. 默认网络配置与主机名
sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/FanchmWrt-AX3600/g' package/base-files/files/bin/config_generate

# 2. 深度包检测与应用过滤特征库自动更新源
if [ -d "package/open-app-filter" ] || [ -d "package/feeds/fanchm/appfilter" ]; then
    echo "FanchmWrt / OpenAppFilter 模块已就绪"
fi

# 3. 强制固化 rootfs 大分区大小至 48MB (360 个 PEB 块，对标 Kwrt 大分区)
echo "CONFIG_TARGET_ROOTFS_PARTSIZE=48" >> .config
echo "CONFIG_TARGET_KERNEL_PARTSIZE=16" >> .config

echo ">>> 大分区参数注入完成！"
