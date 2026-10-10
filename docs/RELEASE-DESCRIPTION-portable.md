## 大肥鱼 USB Portable v1.18.37

**从 U 盘完整运行**的打包形式：解压到 U 盘任意目录（例如 `H:\大肥鱼-Portable\`），
双击 `启动-大肥鱼-Portable.cmd` 即可。

启动器使用**相对路径**（`%~dp0`），不硬编码任何盘符，**换盘符后仍然可用**；
并把 `TEMP` / `TMP` 重定向到 U 盘内的 `temp\`，减少宿主残留。

**本包不含任何个人数据（空骨架版本）**

- ❌ 无会话数据库（`opencode.db`）
- ❌ 无个人记忆（`memory/*.md`）
- ❌ 无任何 API Key / 令牌（`*.bin`）
- ❌ 无运行日志
- ✅ `data/`、`memory/`、`temp/`、`agent/data/`、`agent/state/` 为**空目录**，首次运行时由程序自行生成

配置请从 `portable` 分支的 `portable/config.template.json` 复制为 `data/config.json` 后按需修改。
你的 DeepSeek API Key 由程序在本机加密保存（Windows DPAPI），不随包分发。

**包内含什么（10 个文件）**

| 文件 | 字节 |
| --- | --- |
| `DesktopPet.exe` | 387,878,729 |
| `opencode-windows-x64.zip` | 62,127,126 |
| `portable.flag` | 8 |
| `使用说明.txt` | 1,458 |
| `启动-大肥鱼-Portable.cmd` | 107 |
| `agent/config/.gitignore` | 63 |
| `agent/config/opencode/.gitignore` | 63 |
| `agent/config/opencode/opencode.jsonc` | 174 |
| `agent/config/opencode/package-lock.json` | 14,633 |
| `agent/config/opencode/package.json` | 65 |

外加空目录骨架：`data/`、`memory/`、`temp/`、`agent/data/opencode/`、`agent/state/opencode/`

**完整性校验**

| 项 | 值 |
| --- | --- |
| 附件 | `DaFeiYu-Portable-v1.18.37.zip` |
| 大小 | 447,788,472 B（427.0 MiB） |
| SHA-256 | `23f70c77b0d383d286d3d72365590b569a8ebe21f02c8ae2906ebc635d6cab30` |

**⚠️ 尚未验证的事项（如实声明）**

"所有数据都留在 U 盘、换机不留痕"这一目标**尚未经过独立验证**，以下均属**待核验**：

- 换盘符后能否启动（启动器已用相对路径，但程序内部是否另有绝对路径未验证）
- 是否在宿主 `%APPDATA%` / `%LOCALAPPDATA%` / 用户目录 / 注册表中留下可持久数据
- API Key 退出后是否不残留于宿主
- 加密实现是否确为 PBKDF2-SHA256(390k) → AES-256-GCM（**设计说明不等于实现**）
- 便携版服务端口 `4099` / health 版本 `1.18.35` 是否仍成立
- **DSH 数据根是否真的落在 U 盘**（已知当前 DSH 数据根仍位于本机用户目录下，而非 U 盘）

详见仓库 `portable` 分支的 `portable/docs/portable-acceptance.md`。

**注意**：本程序未数字签名，部分 Windows 安全设置可能提示拦截，请在确认来源可信后允许运行。
