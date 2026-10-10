# 大肥鱼 / DesktopPet

一只 Windows 桌面宠物（DeepSeek 娘 · 大肥鱼），支持普通聊天，以及通过内置 OpenCode CLI 呼叫 Agent。

本仓库**只放框架与文档**：不含任何 API Key、令牌、会话数据库、个人记忆或日志。

---

## 一、本仓库是什么 / 不是什么

| | |
|---|---|
| ✅ 是 | 版本档案、发布清单与 SHA-256 校验、便携化（USB Portable）设计与验收文档、脱敏配置模板、自校验脚本 |
| ❌ 不是 | 程序源码（本机上没有源码工程，只有编译成品）、不是成品二进制（走 Release）、**不含任何个人数据** |

### 为什么仓库里没有程序和数据

| 内容 | 大小 | 处理方式 | 原因 |
|---|---|---|---|
| `DesktopPet.exe` | 383.9 MB / 387.9 MB | **不入库**，走 GitHub Release | 超过 GitHub 单文件 100 MB 硬上限 |
| `opencode-windows-x64.zip` | 62.1 MB | **不入库**，走 Release | 与程序本体一同分发 |
| `agent\data\opencode\opencode.db` | 2.12 GB | **不入库，永不** | 是使用者的全部会话历史（个人数据） |
| `memory\*.md` | — | **不入库，永不** | 是使用者的个人记忆 |
| `*.bin`（API Key / 令牌） | 298 B ×2 | **不入库，永不** | 凭据。`.gitignore` 已强制排除 |

---

## 二、分支结构

| 分支 | 用途 | 内容 |
|---|---|---|
| `main` | **发布成品线** | README、使用说明、Release 清单与 SHA-256、下载后自校验脚本 |
| `portable` | **真正 USB Portable** | 相对路径启动器、脱敏配置模板、便携化设计与验收文档 |

从 `portable` 分支可以看到"怎么做到全数据在 U 盘"，但**看不到任何实际数据**。

---

## 三、下载与校验

### 已发布版本

| Release | 内容 | 附件 |
|---|---|---|
| `v1.18.37` | 桌面版（解压即用） | `v1.18.37.zip`（443,814,276 B） |
| `portable-v1.18.37` | U 盘便携版（**脱敏空骨架**） | `DaFeiYu-Portable-v1.18.37.zip`（447,788,472 B） |

> 便携版附件**不含**会话数据库、个人记忆、API Key 或日志；`data/`、`memory/`、`temp/` 为空目录，首次运行时由程序生成。

### 校验方法

1. 到本仓库 **Releases** 页面下载发行包。
2. 解压后运行自校验脚本，逐文件比对 SHA-256：

```powershell
# 桌面版
pwsh ./tools/verify.ps1 -Root "<解压后的目录>" -Manifest ./releases/manifest-v1.18.37.json
# 便携版
pwsh ./tools/verify.ps1 -Root "<解压后的目录>" -Manifest ./releases/manifest-portable.json
```

3. 全部一致 → 文件未被篡改或损坏。任何一项不一致 → 停止使用并重新下载。

### 关于"真正 USB Portable"的现状（如实说明）

已核实**成立**：启动器使用相对路径（换盘符可用）、临时目录重定向到 U 盘内、
OpenCode 工作目录与记忆引用都跟随 U 盘位置、U 盘内容与备份**逐字节一致**（50/50 SHA-256）。

**尚未达成 / 待核验**：换机"零残留"。已在宿主注册表发现自启项
（`HKCU\...\Run` → `DeepSeekDesktopPet`），且 U 盘配置中 `autostart.enabled = true`；
DSH 数据根也**尚未**落在 U 盘。

完整证据见 `docs/VERIFICATION-2026-10-10-usb-audit.md`；
待核验清单见 `portable/docs/portable-acceptance.md`（在 `portable` 分支）。

---

## 四、安全约定（本仓库的硬规则）

1. **绝不**把 API Key、令牌、密码、cookie、私钥提交进仓库或写进日志。
2. **绝不**把会话数据库（`*.db`）、个人记忆（`memory/`）、运行日志（`*.log`）提交进仓库。
3. 使用者自己的 Key 由程序在本机加密保存（Windows DPAPI），**不随程序发布**。
4. 本仓库的 `.gitignore` 是安全闸门；如需新增例外，必须先确认该路径不含个人数据。

---

## 五、状态标记约定

本仓库文档沿用证据分级，**不允许把"没验证过"写成事实**：

- `已报告完成` — 有报告但未经本轮独立复核
- `当前已知` — 有可复现的实测证据
- `待核验` — 尚未验证，不得当作事实使用
- `历史快照` — 仅作追溯，不代表当前状态
- `建议方案` — 提案，未实施
