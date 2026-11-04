# FanchmWrt 小米路由器 AX3600 240MB 大分区云端自动编译系统

本工程专门针对 **小米 AIoT 路由器 AX3600 (Xiaomi AX3600 / R3600)** 定制，基于官方开源行为管理系统 [FanchmWrt (https://github.com/fanchmwrt/fanchmwrt)](https://github.com/fanchmwrt/fanchmwrt)，通过 GitHub Actions 云端服务器自动化编译生成。

---

## 🛠️ 针对本机的专属优化与适配

1. **240MB 专属大分区适配**：
   - 适配当前底层 MIBIB 分区表（`rootfs` 块数 `0x0780` = 240.0MB，单大分区无 `rootfs_1`）；
   - 彻底解决原厂小分区固件刷入后引发的 **Kernel Panic / 长亮橙灯死机** 故障。
2. **U-Boot 引导命令与卷名全匹配**：
   - 适配 U-Boot 引导参数 `ubi.mtd=rootfs root=mtd:ubi_rootfs rootfstype=squashfs rootwait`；
   - 自动生成合规的 `kernel`、`ubi_rootfs` 与 `rootfs_data` 卷。
3. **180MB+ 满血持久化存储空间**：
   - 刷入即用，自动将未占用的 180MB+ 闪存空间挂载为可读写 Overlay，从此插件随心装，配置永不丢失。
4. **高通 IPQ8071A NSS 硬件加速**：
   - 集成高通专用 NSS 与 ECM 硬件加速驱动，千兆与无线全速率线速转发，CPU 占用近乎为零。
5. **企业级上网行为管理全功能**：
   - 深度集成 DPI 应用协议识别、应用过滤、终端管控、上网审计与安全中心 Web 界面。

---

## 🚀 三步开启 GitHub Actions 云端编译（零环境门槛）

### 第一步：在 GitHub 创建一个新仓库
1. 打开浏览器登录 GitHub；
2. 点击右上角 **`+`** -> **`New repository`**；
3. 仓库名称填写例如：`fanchmwrt-ax3600`，选择 **Public**（公开），点击 **Create repository**。

### 第二步：将本工程文件上传到仓库
将 `c:\MJia\fanchmwrt_ax3600_ci` 目录下的所有文件上传至该仓库根目录：
- `.github/workflows/build-ax3600-bigpart.yml`
- `diy-part1.sh`
- `diy-part2.sh`
- `ax3600_bigpart.config`
- `README.md`

*(提示：直接在 GitHub 仓库首页点击「Add file」->「Upload files」，将上述文件及目录拖入即可)*

### 第三步：一键触发云端多核编译
1. 进入仓库页面，点击上方的 **Actions** 标签；
2. 在左侧工作流列表中点击 **Build FanchmWrt for Xiaomi AX3600 (Big Partition 240MB)**；
3. 点击右侧的 **Run workflow** 下拉按钮，再点击绿色的 **Run workflow**；
4. 接下来 GitHub Actions 虚拟机将全自动完成：
   - 自动拉取源码与全套依赖
   - 注入大分区专属设备树与卷表规则
   - 多核心全速编译
   - 自动打包并发布至 Releases

---

## 📥 固件刷入与开机验证（只需 2 分钟）

编译完成后（通常约 50-70 分钟），进入仓库右侧的 **Releases** 页面即可下载固件：

1. **首次刷机（当前状态）**：
   - 路由器当前正处于 U-Boot Web 恢复页面（长亮橙灯，电脑连网线直连 LAN 口）；
   - 浏览器打开 `http://192.168.1.1`（FIRMWARE UPDATE 页面）；
   - 点击「选择文件」，选择 Releases 中下载的：
     **`*squashfs-factory.ubi`**
   - 点击 **Update firmware** 开始上传并刷入；
   - 路由器指示灯将在 2-3 分钟内完成刷写并自动重启，正面指示灯变为正常**蓝灯常亮**！

2. **登录管理后台**：
   - 浏览器直接访问：`http://192.168.1.1`
   - 默认用户名：`root`
   - 默认密码：`password`
   - 进入系统后，前往「系统」->「磁盘管理/挂载点」，即可看到剩余可用空间高达 **180MB+**！

3. **后续升级**：
   - 日后升级固件，可直接在后台「系统」->「备份/升级」中上传 **`*squashfs-sysupgrade.bin`** 无缝升级，无需重新进入 U-Boot。
