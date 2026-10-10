# 便携化验收清单（Acceptance Checklist）

> 目标：达成"所有数据都在 U 盘、换机不留痕"的便携行为。
> 状态标记：`已报告完成` / `当前已知` / `待核验` / `历史快照` / `建议方案`

## A. 已确认（有实测证据）

> 依据：2026-10-10 对 `H:\大肥鱼-Portable` 的**只读**核验，详见仓库 `docs/VERIFICATION-2026-10-10-usb-audit.md`

| # | 项 | 状态 | 证据 |
|---|---|---|---|
| A1 | 启动器使用相对路径，不硬编码盘符 | **当前已知** | `%~dp0`；已从 U 盘实读原文（`set "ROOT=%~dp0"`） |
| A2 | 临时目录重定向到 U 盘内 | **当前已知** | 同上，`set "TEMP=%ROOT%temp"` / `set "TMP=%ROOT%temp"` |
| A3 | 便携标记文件存在 | **当前已知** | `H:\大肥鱼-Portable\portable.flag`，内容 `portable` |
| A4 | 便携根目录结构与体量 | **当前已知** | **50 文件 / 2,744,260,540 B**，与迁移报告完全一致 |
| A5 | U 盘内容与主机副本逐字节相同 | **当前已知** | **50/50 文件 SHA-256 一致**，含 `opencode.db`（2,277,351,424 B） |
| A6 | OpenCode 工作目录跟随程序位置，不写死盘符 | **当前已知** | 当天日志：`creating instance directory="F:\\lym\\Zhang\\大肥鱼-Portable"`（当时所在位置） |
| A7 | 记忆跟随 U 盘（相对路径引用） | **当前已知** | `opencode.jsonc` 用 `"../../../memory/00_CORE_MEMORY.md"` |
| A8 | U 盘 `memory\` 实际含记忆 | **当前已知** | **16 个 Markdown 文件** |
| A9 | 数据写在 U 盘内 | **当前已知** | 存在 `data\logs\`、`data\webengine\{cache,storage}\`、`data\config.json` |
| A10 | U 盘内配置与日志**不引用宿主路径** | **当前已知** | 全盘扫描 `C:\Users` / `AppData`：仅 `prompt-history.jsonl` 命中 7 行，且那是**提问原文** |

## A-2. 已确认的反例（不符合"换机不留痕"）

| # | 项 | 状态 | 证据 |
|---|---|---|---|
| N1 | 程序的自启机制**会写宿主注册表** | **当前已知** | 宿主 `HKCU\...\Run` 存在 `DeepSeekDesktopPet = "C:\Users\111\Desktop\v1.18.37\DesktopPet\DesktopPet.exe"`，该路径确实存在 |
| N2 | U 盘配置里自启处于**开启**状态 | **当前已知** | `H:\大肥鱼-Portable\data\config.json` → `"autostart": { "enabled": true }` |
| N3 | 宿主残留旧安装缓存 | **当前已知** | `%LOCALAPPDATA%\DesktopPet\cache\qtpipelinecache-x86_64-little_endian-llp64`，时间戳 **2026-09-28**（早于便携版 2026-10-07），非便携版痕迹 |
| N4 | DSH 数据根**未**落在 U 盘 | **当前已知（反例）** | DSH 数据根仍为本机用户目录下的 `.dsh`，非 U 盘路径 |

> N1 + N2 合起来意味着：**存在"运行时会往宿主注册表写自启项"的风险**，
> 但**尚未验证**从 U 盘运行时写的是 U 盘路径还是宿主路径 —— 见 B 区第 3 项。

## B. 待核验（**不得当作已完成**）

| # | 项 | 为什么重要 | 验证方法 |
|---|---|---|---|
| B1 | 换盘符（H: → 其他）后是否仍能启动 | 相对路径已写对，但程序内部可能另有绝对路径 | 拔下 U 盘插到另一台机、换到不同盘符后启动 |
| B2 | 是否在宿主 `%APPDATA%` / `%LOCALAPPDATA%` / `%USERPROFILE%` 产生**新**数据 | 便携的核心承诺 | 启动前记录宿主目录快照，运行后比对（受控实验） |
| B3 | 从 U 盘运行时**写的是哪个路径**的自启项 | 已确认自启机制会写宿主注册表（N1），但指向未测 | 清掉旧项 → 启动 U 盘版 → 复查 `HKCU\...\Run` |
| B4 | API Key 是否退出后不残留于宿主 | 用户明确要求 | 检查配置文件、日志、crash dump、浏览器缓存、环境变量 |
| B5 | 加密实现是否真为 PBKDF2-SHA256(390k) → AES-256-GCM | 设计说明不等于实现 | 代码级审查：nonce 唯一性、tag 校验、失败处理、密钥清理 |
| B6 | 解锁是否"UI 内解锁"而非启动弹窗阻塞 | 用户的体验要求 | 实际运行观察 |
| B7 | `data\config.json` 里 `dsh.port: 0` 时如何定位 DSH 数据根 | N4 已证数据未落 U 盘 | 运行期观察 DSH 会话文件写入路径 |
| B8 | portable server 端口 4099 / health 版本 1.18.35 是否仍成立 | 旧报告值，可能已变 | 实测 health endpoint |
| B9 | 宿主零残留的完整清单（含计划任务、Prefetch、最近打开） | 用户"即使加密也不接受" | 专项检查 |
| B10 | `agent\config\opencode\config.json` 缺失是否影响下次启动 | 日志显示程序会尝试加载该文件，但当前目录**没有**它 | 下次启动观察，或补齐后复测 |
| B11 | 本机**无源码**，无法做加密实现的代码级审查 | 只有编译好的 `DesktopPet.exe` | 取得源码工程后审查 |

## C. 建议方案（未实施）

| # | 方案 | 收益 |
|---|---|---|
| C1 | DSH 数据根改为相对便携根（如 `data\dsh-home`） | 真正实现"全部数据在 U 盘" |
| C2 | 启动器启动时设 `DSH_HOME=%ROOT%data\dsh-home` | 不改程序即可切换数据根 |
| C3 | 增加 `--selftest` 模式，自动输出"我往哪里写了什么" | 让 B2/B3/B4 可复现、可自动化 |

## D. 复现命令

```powershell
# 目录结构与体量
Get-ChildItem -LiteralPath <便携根> -Force -Recurse -File |
  Measure-Object -Property Length -Sum

# 校验完整性（需先从本仓库 Releases 下载清单）
pwsh ./tools/verify.ps1 -Root <便携根> -Manifest ./releases/manifest-portable.json
```
