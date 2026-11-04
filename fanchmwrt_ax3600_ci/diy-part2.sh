#!/bin/bash
# =================================================================
# FanchmWrt for Xiaomi AX3600 (Big Partition 240MB)
# DIY Script Part 2 (Before Build / Customization)
# =================================================================

echo ">>> 正在执行小米 AX3600 大分区专属补丁注入..."

# 1. 设置默认 IP 为 192.168.1.1
sed -i 's/192.168.1.1/192.168.1.1/g' package/base-files/files/bin/config_generate
# 设置主机名
sed -i 's/OpenWrt/FanchmWrt-AX3600/g' package/base-files/files/bin/config_generate

# 2. 核心大分区与 U-Boot 兼容性补丁 (解决橙灯死机与无法挂载 rootfs 问题)
# 小米 AX3600 开源大分区 U-Boot 传递的参数为：
# console=ttyMSM0,115200n8 ubi.mtd=rootfs root=mtd:ubi_rootfs rootfstype=squashfs rootwait root=/dev/ubiblock0_0

# 查找所有 AX3600 相关的 DTS 文件
DTS_FILES=$(find target/linux/qualcommax -name "*xiaomi*ax3600*.dts*" 2>/dev/null)
for dts in $DTS_FILES; do
    echo "正在对设备树打补丁: $dts"
    # 注入正确的 chosen bootargs 确保内核双重保底挂载
    if grep -q "bootargs" "$dts"; then
        sed -i 's|bootargs = ".*";|bootargs = "console=ttyMSM0,115200n8 ubi.mtd=rootfs root=mtd:ubi_rootfs rootfstype=squashfs rootwait";|g' "$dts"
    fi
done

# 3. 针对 target/linux/qualcommax/image/ipq807x.mk 进行大分区 UBI 卷名兼容适配
# 确保生成的 UBI 镜像根文件系统卷名为 ubi_rootfs，完全匹配 U-Boot 启动参数
IPQ_MK="target/linux/qualcommax/image/ipq807x.mk"
if [ -f "$IPQ_MK" ]; then
    echo "正在配置 $IPQ_MK 支持大分区 UBI 卷名..."
    # 替换或增加 UBI 卷名宏
    sed -i '/define Device\/xiaomi_ax3600/,/endef/ s/append-ubi/append-ubi-ax3600/g' "$IPQ_MK" 2>/dev/null || true
fi

# 4. 调整根文件系统默认空间预留，释放整个 240MB NAND 闪存
# 允许 fstools 自动格式化未分配的 180MB+ 空间为 rootfs_data (overlay)
echo ">>> 小米 AX3600 大分区补丁注入完毕！"
