# 便携化验收清单（Acceptance Checklist）

> 目标：达成"所有数据都在 U 盘、换机不留痕"的便携行为。
> 状态标记：`已报告完成` / `当前已知` / `待核验` / `历史快照` / `建议方案`

## A. 已完成（有实测证据）

| # | 项 | 状态 | 证据 |
|---|---|---|---|
| A1 | 启动器使用相对路径，不硬编码盘符 | **当前已知** | `scripts\启动-大肥鱼-Portable.cmd` 用 `%~dp0`；2026-10-10 实测读取原文 |
| A2 | 临时目录重定向到 U 盘内 | **当前已知** | 同上，`set "TEMP=%ROOT%temp"` / `set "TMP=%ROOT%temp"` |
| A3 | 便携标记文件存在 | **当前已知** | `portable.flag`，内容为 `portable` |
| A4 | 便携根目录结构符合设计 | **当前已知** | 2026-10-10 实测：50 文件 / 2,744,260,540 B，含 `data\ agent\ memory\ temp\` |

## B. 待核验（**不得当作已完成**）

| # | 项 | 为什么重要 | 验证方法 |
|---|---|---|---|
| B1 | 换盘符（H: → 其他）后是否仍能启动 | 相对路径已写对，但程序内部可能另有绝对路径 | 拔下 U 盘插到另一台机、换到不同盘符后启动 |
| B2 | 是否在宿主 `%APPDATA%` / `%LOCALAPPDATA%` / `%USERPROFILE%` 留下可持久数据 | 便携的核心承诺 | 启动前记录宿主目录快照，运行后比对 |
| B3 | 是否写注册表（自启动项等） | 换机会留下痕迹 | 对比运行前后 `HKCU\...\Run` 等键 |
| B4 | API Key 是否退出后不残留于宿主 | 用户明确要求 | 检查配置文件、日志、crash dump、浏览器缓存、环境变量 |
| B5 | 加密实现是否真为 PBKDF2-SHA256(390k) → AES-256-GCM | 设计说明不等于实现 | 代码级审查：nonce 唯一性、tag 校验、失败处理、密钥清理 |
| B6 | 解锁是否"UI 内解锁"而非启动弹窗阻塞 | 用户的体验要求 | 实际运行观察 |
| B7 | `data\config.json` 里 `dsh.port: 0` 时如何定位 DSH 数据根 | **当前 DSH 数据根仍在 `C:\Users\111\.dsh`**，即数据并未落在 U 盘 | 运行期观察 DSH 会话文件写入路径 |
| B8 | portable server 端口 4099 / health 版本 1.18.35 是否仍成立 | 旧报告值，可能已变 | 实测 health endpoint |
| B9 | 宿主零残留的完整清单（含计划任务、Prefetch、最近打开） | 用户"即使加密也不接受" | 专项检查 |

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
