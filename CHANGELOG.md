# 变更记录

本文件只追加，不覆盖。

## 未发布 — 仓库框架建立

- 建立 `main`（发布成品线）与 `portable`（便携包装层）两条分支框架。
- 写入 `.gitignore` 安全闸门：永久排除 `*.bin`、`*.db`、`*.log`、`memory/`、`data/`、`temp/`、`*.exe`、`*.zip`。
- 加入 `docs/SECURITY-BOUNDARY.md`，逐条声明"永不收录"的内容与理由。
- 加入 `tools/make-manifest.ps1`（生成 SHA-256 清单）、`tools/verify.ps1`（下载后自校验）、`tools/secret-scan.ps1`（提交前自检）。
- 收录两份历史文档副本（`docs/10_大肥鱼桌宠与USB便携版.md` 为当前状态交接；`docs/HIST_2026-09-29_大肥鱼.md` 为历史快照，仅追溯）。

**尚未发生**：尚无任何版本发布，尚无 Release 附件。

## 说明：为什么没有程序本体

`DesktopPet.exe`（383.9 MB / 387.9 MB）与 `opencode-windows-x64.zip`（62.1 MB）超过 GitHub 单文件 100 MB 硬上限，**不能进入 git 历史**。将来应以 GitHub Release 附件形式发布，仓库内只保留清单与文档。
