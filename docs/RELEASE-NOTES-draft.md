# Release Notes 定稿（待上传）

> 本文件是给 GitHub Release 用的说明文案定稿，同时在发布前充当**脱敏核对清单**。
> 发布操作由执行者按此逐条核对后再上传。

---

## Release 1 — 桌面版

| 字段 | 值 |
|---|---|
| Tag | `v1.18.37` |
| Title | `大肥鱼 DesktopPet v1.18.37` |
| 附件 | `v1.18.37.zip` |
| 附件大小 | 443,814,276 B（423.3 MiB） |
| 附件 SHA-256 | `929e6595991113561af3aa10755ff2616884887d78562d0ec76cb0dd5306e1a1` |
| 附件内容 | 3 个条目：`DesktopPet/DesktopPet.exe`、`DesktopPet/opencode-windows-x64.zip`、`DesktopPet/使用说明.txt` |
| 脱敏核对 | ✅ **无** `*.bin` / `*.db` / `*.log` / `memory/`（已用 `tar -tvf` 逐条检查） |

### 说明正文（可直接粘贴）

```markdown
## 大肥鱼 / DesktopPet v1.18.37

Windows 桌面宠物（DeepSeek 娘 · 大肥鱼）。

- 双击 `DesktopPet.exe` 即可运行；不需要 Python / Node / npm，也不需要管理员权限。
- 普通聊天需要你自己的 DeepSeek API Key：右键桌宠 → 设置 → 聊天 API。
- Agent 功能需要 OpenCode：安装包已内置官方 CLI，首次启动会离线安装并启动
  Agent Server（仅监听 127.0.0.1:4096）。

### 完整性校验

下载后逐文件比对 SHA-256：

    pwsh ./tools/verify.ps1 -Root "<解压后的目录>" -Manifest ./releases/manifest-v1.18.37.json

清单：`releases/manifest-v1.18.37.json`

| 文件 | 字节 | SHA-256 |
|---|---|---|
| DesktopPet/DesktopPet.exe | 383,884,955 | 见清单 |
| DesktopPet/opencode-windows-x64.zip | 62,127,126 | 见清单 |
| DesktopPet/使用说明.txt | 1,458 | 见清单 |

> 本程序未数字签名，部分 Windows 安全设置（如"智能应用控制"）可能提示拦截。
> 请在确认来源可信后选择允许运行。
```

---

## Release 2 — 便携版

| 字段 | 值 |
|---|---|
| Tag | `portable-v1.18.37` |
| Title | `大肥鱼 USB Portable v1.18.37` |
| 附件 | `DaFeiYu-Portable-v1.18.37.tar` |
| 附件大小 | 450,039,808 B（429.2 MiB） |
| 附件 SHA-256 | `0ffd87d799817cecc7574f907e11c4060fa0c677e5362c78ab92b98547620d39` |
| 附件内容 | 10 个文件 + 空目录骨架（共 21 个 tar 条目） |
| 脱敏核对 | ✅ **无** `opencode.db`、**无** `memory/*.md`、**无** `*.bin`、**无** 日志 |

### 附件内文件清单（10 个）

```
DaFeiYu-Portable/
├─ DesktopPet.exe                          387,878,729 B
├─ opencode-windows-x64.zip                 62,127,126 B
├─ portable.flag                                     8 B
├─ 使用说明.txt                                   1,458 B
├─ 启动-大肥鱼-Portable.cmd                        107 B
├─ agent/config/.gitignore                          63 B
├─ agent/config/opencode/.gitignore                 63 B
├─ agent/config/opencode/opencode.jsonc            174 B
├─ agent/config/opencode/package-lock.json      14,633 B
└─ agent/config/opencode/package.json               65 B
```

### 同时包含的空目录骨架（便于首次运行直接写盘）

```
data/  memory/  temp/  agent/data/opencode/  agent/state/opencode/
```

### 说明正文（可直接粘贴）

```markdown
## 大肥鱼 USB Portable v1.18.37

**从 U 盘完整运行**的打包形式：把本包解压到 U 盘任意目录（如 `H:\大肥鱼-Portable\`），
双击 `启动-大肥鱼-Portable.cmd` 即可。启动器使用相对路径（`%~dp0`），
**换盘符后仍然可用**；并把 `TEMP`/`TMP` 重定向到 U 盘内的 `temp\`。

### 本包不含任何个人数据

这是**空骨架**版本：不含会话数据库、不含个人记忆、不含任何 API Key。
`data/`、`memory/`、`temp/` 等目录为空，首次运行时由程序自行生成。

- 你的 DeepSeek API Key 由程序在本机加密保存（Windows DPAPI），**不随包分发**。
- 配置文件请从 `portable/config.template.json`（见 `portable` 分支）复制为
  `data/config.json` 后按需修改。

### 完整性校验

SHA-256：

    0ffd87d799817cecc7574f907e11c4060fa0c677e5362c78ab92b98547620d39

解压：

    tar -xf DaFeiYu-Portable-v1.18.37.tar

### 尚未验证的事项（如实声明）

"所有数据都留在 U 盘、换机不留痕"这一目标**尚未经过独立验证**，仍属待核验：

- 换盘符后能否启动（启动器已用相对路径，但程序内部是否另有绝对路径未验证）
- 是否在宿主 `%APPDATA%` / `%LOCALAPPDATA%` / 用户目录 / 注册表留下可持久数据
- API Key 退出后是否不残留于宿主
- 加密实现是否确为 PBKDF2-SHA256(390k) → AES-256-GCM（设计说明不等于实现）
- DSH 数据根是否真的落在 U 盘（已知当前 DSH 数据根位于 `C:\Users\111\.dsh`）

详见 `portable/docs/portable-acceptance.md`。
```

---

## 发布前最终核对（执行者逐条打勾）

- [ ] 附件 1 是 `C:\Users\111\Desktop\v1.18.37.zip`，SHA-256 以 `929e6595` 开头
- [ ] 附件 2 是 `D:\DSH\dafelyu-release\DaFeiYu-Portable-v1.18.37.tar`，SHA-256 以 `0ffd87d7` 开头
- [ ] 附件 2 **未经任何** 个人数据的复制（本目录由白名单复制生成，不包含 `opencode.db` / `memory` / `*.bin`）
- [ ] 两个附件均 **< 2 GB**（423.3 MB / 429.2 MB）
- [ ] Release 说明里写明了 SHA-256 与解压方式
- [ ] 未改动 v1.18.33（保护旧版本）
- [ ] 发布后用 API 读回，确认 tag、附件名与大小
