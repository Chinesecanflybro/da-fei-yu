# 便携版（USB Portable）

> 本目录**只有框架**：启动器、脱敏配置模板、目录结构说明与验收清单。
> 不含程序本体、不含任何数据。

## 目标

让"大肥鱼"从 U 盘运行：**个人数据、Agent 会话、记忆与缓存全部留在 U 盘**，
换一台电脑后不在宿主留下可持久的个人数据或 API 凭证。

## 目录内容

| 文件 | 作用 |
|---|---|
| `启动-大肥鱼-Portable.cmd` | 启动器：全部路径相对自身（`%~dp0`），不硬编码盘符；并把 `TEMP`/`TMP` 重定向到 U 盘内 |
| `config.template.json` | 配置模板（**脱敏**，无任何 Key、无真实机器路径）。复制为 `<便携根>\data\config.json` 使用 |
| `docs/portable-layout.md` | 便携根应有的目录结构（含"哪些目录绝不入库"） |
| `docs/portable-acceptance.md` | 验收清单：已确认 / 待核验 / 建议方案三段 |
| `tools/verify.ps1`（仓库根 `tools/`） | 下载发行包后逐文件比对 SHA-256 |

## 已确认 / 未确认（摘要，详见 `docs/portable-acceptance.md`）

**已确认（有实测证据）**

- 启动器使用 `%~dp0` 相对路径，不写死 `F:` / `H:`
- `TEMP` / `TMP` 已重定向到 U 盘内 `temp\`
- `portable.flag` 存在（内容 `portable`）
- 便携根结构符合设计（50 文件 / 2,744,260,540 B）

**待核验（不得当作已完成）**

- 换盘符后能否正常启动
- 是否在宿主 `%APPDATA%` / `%LOCALAPPDATA%` / `%USERPROFILE%` / 注册表留下痕迹
- API Key 退出后是否不残留于宿主
- 加密实现是否真为 PBKDF2-SHA256(390k) → AES-256-GCM
- 是否"UI 内解锁"而非启动弹窗阻塞
- **DSH 数据根是否真的落在 U 盘**（已知当前 DSH 数据根在 `C:\Users\111\.dsh`，即尚未落实）

## 安全边界

本目录及其所在分支**永不收录**：

```
*.bin                 凭据（API Key / 令牌）
*.db  *.db-shm  *.db-wal   会话数据库（个人对话历史）
memory/               个人记忆
*.log                 日志
agent/state/          提问历史（prompt-history.jsonl）
data/  temp/          运行期数据
DesktopPet.exe        程序本体（走 Release，超 100 MB 上限）
```

详见仓库根 `docs/SECURITY-BOUNDARY.md`，以及强制排除清单 `.gitignore`。
