# 变更记录

本文件只追加，不覆盖。

## 未发布 — 仓库框架建立

- 建立 `main`（发布成品线）与 `portable`（便携包装层）两条分支框架。
- 写入 `.gitignore` 安全闸门：永久排除 `*.bin`、`*.db`、`*.log`、`memory/`、`data/`、`temp/`、`*.exe`、`*.zip`。
- 加入 `docs/SECURITY-BOUNDARY.md`，逐条声明"永不收录"的内容与理由。
- 加入 `tools/make-manifest.ps1`（生成 SHA-256 清单）、`tools/verify.ps1`（下载后自校验）、`tools/secret-scan.ps1`（提交前自检）。
- 收录两份历史文档副本（`docs/10_大肥鱼桌宠与USB便携版.md` 为当前状态交接；`docs/HIST_2026-09-29_大肥鱼.md` 为历史快照，仅追溯）。

**尚未发生**：尚无任何版本发布，尚无 Release 附件。

## 2026-10-10 — 仓库首次发布

> 上一条"尚未发生"已由本节记录取代，原文保留以保持时间线可追溯。

- 仓库上线：<https://github.com/Chinesecanflybro/da-fei-yu>（public）
- 分支：`main`（发布成品线）、`portable`（便携包装层）
- **Release `v1.18.37`** — 桌面版，附件 `v1.18.37.zip`（443,814,276 B）
  SHA-256 `929e6595991113561af3aa10755ff2616884887d78562d0ec76cb0dd5306e1a1`
- **Release `portable-v1.18.37`** — 便携版，附件 `DaFeiYu-Portable-v1.18.37.zip`（447,788,472 B）
  SHA-256 `23f70c77b0d383d286d3d72365590b569a8ebe21f02c8ae2906ebc635d6cab30`
  （该附件为**脱敏空骨架**：无会话数据库、无个人记忆、无 API Key、无日志）
- 加入 `docs/release-guide.md`（发布流程与 100 MB / 2 GB 限制）、
  `docs/RELEASE-DESCRIPTION-*.md`（两份 Release 说明定稿）
- 加入 `docs/VERIFICATION-2026-10-10-usb-audit.md`：对 `H:\大肥鱼-Portable` 的**只读**核验记录

### 核验发现（要点）

- ✅ 迁移完整：U 盘 **50 文件 / 2,744,260,540 B**，与主机副本 **50/50 SHA-256 逐字节一致**
- ✅ 便携行为部分成立：启动器用 `%~dp0`、TEMP 重定向到盘内、OpenCode 工作目录跟随所在位置、记忆用相对路径引用
- ⚠️ 发现反例：宿主 `HKCU\...\Run` 存在自启项 `DeepSeekDesktopPet = "C:\Users\111\Desktop\v1.18.37\DesktopPet\DesktopPet.exe"`，
  而 U 盘配置 `autostart.enabled = true` → **"换机不留痕"尚未达成，属待核验**
- ⚠️ DSH 数据根仍未落在 U 盘

## 说明：为什么没有程序本体

`DesktopPet.exe`（383.9 MB / 387.9 MB）与 `opencode-windows-x64.zip`（62.1 MB）超过 GitHub 单文件 100 MB 硬上限，**不能进入 git 历史**。因此以 GitHub Release 附件形式发布，仓库内只保留清单与文档。
