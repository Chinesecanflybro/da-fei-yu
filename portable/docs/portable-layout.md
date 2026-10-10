# 便携分支：预期目录结构

> ⚠️ **本仓库不包含下列任何实际数据**，这里只是"框架说明"。
> `memory/`、`agent/data/`、`*.bin`、`temp/` 在 `.gitignore` 中被强制排除。

```
<便携根>\                       ← U 盘任意盘符下的目录，如 H:\大肥鱼-Portable\
├─ DesktopPet.exe               ← 程序本体（走 Release，不入库，约 388 MB）
├─ opencode-windows-x64.zip     ← 内置 OpenCode CLI（走 Release，不入库，约 62 MB）
├─ portable.flag                ← 内容：portable（存在即启用便携模式）
├─ 使用说明.txt
├─ 启动-大肥鱼-Portable.cmd      ← 相对路径启动器（见 scripts/）
├─ data\                        ← 【个人数据，绝不入库】
│   ├─ config.json              ← 由 config.template.json 复制而来
│   └─ desktop_pet_usage.json
├─ agent\                       ← 【个人数据，绝不入库】
│   ├─ config\opencode\
│   ├─ data\opencode\
│   │   ├─ opencode.db          ← 会话数据库（约 2.12 GB）
│   │   ├─ log\
│   │   └─ tool-output\
│   └─ state\opencode\
├─ memory\                      ← 【个人记忆，绝不入库】16 个 Markdown
└─ temp\                        ← 【运行期临时文件，绝不入库】由启动器重定向至此
```

## 为什么这样设计

| 设计 | 目的 |
|---|---|
| `portable.flag` | 让程序用"存在性判断"启用便携模式，而不是靠命令行参数或注册表 |
| `set "ROOT=%~dp0"` | 换盘符后仍然指向自身，不写死 `F:` / `H:` |
| `set "TEMP=%ROOT%temp"` | 把临时文件也留在 U 盘，减少宿主残留 |
| `data/` `agent/` `memory/` 并列在根 | 便于"整盘带走"，也便于用一份排除清单把它们挡在仓库外 |
