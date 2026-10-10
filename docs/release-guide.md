# 发布流程（GitHub Release 指引）

> 本仓库**不放二进制**。`DesktopPet.exe`（383.9 MB / 387.9 MB）与 `opencode-windows-x64.zip`（62.1 MB）
> 超过 GitHub 单文件 **100 MB 硬上限**，一旦进入 git 历史就永远删不掉。
> 因此：**代码与清单进仓库，二进制走 Release 附件。**

---

## 一、先看清限制（实测数值，不是估计）

| 限制 | 数值 | 对本项目的影响 |
|---|---|---|
| git 单文件硬上限 | **100 MB** | `DesktopPet.exe` 383.9 MB ✗、`opencode.db` 2.12 GB ✗ 都不能入库 |
| 仓库建议体积 | < 1 GB | 便携版整包 2.74 GB ✗ |
| Release 单附件上限 | **2 GB** | `v1.18.37.zip` 443.8 MB ✓ 可直传；便携版整包 2.74 GB ✗ 必须拆卷 |
| Release 附件总容量 | 无硬性总上限（软限制） | 拆卷后可分批上传 |

**结论**：桌面成品包可直接作为附件；**便携版整包必须拆成每卷 < 2 GB**。

> **本机实测（2026-10-10）**：**没有安装 7-Zip**（`C:\Program Files\7-Zip\7z.exe` 等三个常见路径均不存在）。
> 已有的是 Windows 自带 **`bsdtar 3.8.8`**（`tar.exe`），下面两种方式都给出。

---

## 二、版本与标签约定

| 发布对象 | 建议 tag | 附件 | 说明 |
|---|---|---|---|
| 桌面成品 v1.18.37 | `v1.18.37` | `v1.18.37.zip`（443.8 MB） | 使用者解压即用 |
| 便携版（USB 布局） | `portable-0.1` | 拆卷包 `DaFeiYu-Portable.7z.001/002` | 含 `agent/` `memory/` `temp/` 空骨架，**不含个人数据** |
| 早期保护版本 v1.18.33 | **不要动** | — | 用户明确要求保护旧版本，仅存档 |

---

## 三、桌面成品发布（最简单，一次搞定）

1. 仓库页面 → 右侧 **Releases** → **Create a new release**
2. **Choose a tag** → 输入 `v1.18.37` → **Create new tag on publish**
3. **Release title**：`大肥鱼 DesktopPet v1.18.37`
4. **Describe this release**（可直接用）：

```markdown
## 大肥鱼 / DesktopPet v1.18.37

Windows 桌面宠物（DeepSeek 娘）。

- 双击 `DesktopPet.exe` 即可运行；不需要 Python / Node / npm，也不需要管理员权限。
- 普通聊天需要你自己的 DeepSeek API Key（右键桌宠 → 设置 → 聊天 API）。
- Agent 功能需要 OpenCode：安装包已内置官方 CLI，首次启动会离线安装并启动 Agent Server（仅监听 127.0.0.1:4096）。

### 完整性校验

下载后逐文件比对 SHA-256：

```powershell
pwsh ./tools/verify.ps1 -Root "<解压后的目录>" -Manifest ./releases/manifest-v1.18.37.json
```

清单文件：[`releases/manifest-v1.18.37.json`](../blob/main/releases/manifest-v1.18.37.json)

> 本程序未数字签名，部分 Windows 安全设置（如"智能应用控制"）可能提示拦截。
```

5. **Attach binaries** → 上传 `v1.18.37.zip`
6. **Publish release**

> 注意：`v1.18.37` 本体 443.8 MB < 2 GB，**无需拆卷**。

---

## 四、便携版发布（需要拆卷）

便携版整包 **50 文件 / 2,744,260,540 B（≈ 2.56 GiB）**，超过单个附件 2 GB 上限。

### 4.1 关键前提：先做脱敏

**绝不能**把当前使用中的便携版原样打包上传 —— 里面含：

| 必须剔除 | 大小 | 原因 |
|---|---|---|
| `agent\data\opencode\opencode.db` | 2.12 GB | 使用者的全部会话历史 |
| `agent\data\opencode\log\` | 7.3 MB | 运行日志 |
| `agent\data\opencode\tool-output\` | 3.1 MB | 工具输出原文 |
| `agent\state\opencode\prompt-history.jsonl` | 1.1 MB | 提问原文 |
| `memory\*.md` | — | 个人记忆 |
| `*.bin` | 596 B | API Key / 令牌 |
| `data\config.json` | 1.5 KB | 使用者配置（改用 `portable/config.template.json`） |

留下的应是**空骨架**：

```
DaFeiYu-Portable/
├─ DesktopPet.exe
├─ opencode-windows-x64.zip
├─ portable.flag
├─ 使用说明.txt
├─ 启动-大肥鱼-Portable.cmd
├─ data/            ← 只放 config.template.json 复制成 config.json
├─ agent/
│   ├─ config/opencode/   ← 空骨架或模板
│   ├─ data/opencode/     ← 空目录
│   └─ state/opencode/    ← 空目录
├─ memory/          ← 空目录（使用者自己的记忆由使用者产生）
└─ temp/            ← 空目录
```

### 4.2 拆卷

#### 方式 A：用 Windows 自带的 tar（本机已确认可用，无需安装任何东西）

```powershell
# 每卷 1900 MB（留余量，必须 < 2048 MB）
cd <便携骨架所在目录>
tar -c -L 1900m -f "DaFeiYu-Portable.tar" "DaFeiYu-Portable"
```

- 产物：`DaFeiYu-Portable.tar`、`DaFeiYu-Portable.tar.1`、`DaFeiYu-Portable.tar.2`…
- 每个都要检查 < 2 GB。
- **使用者解压方式**（必须按顺序合并，缺一卷会失败）：

```powershell
# 下载全部卷到同一目录后
tar -x -f "DaFeiYu-Portable.tar"
```

#### 方式 B：7-Zip（若要最小体积，需你自行安装）

本机当前**没有** 7-Zip。若愿意安装，从官方站点 <https://www.7-zip.org/> 下载安装后：

```powershell
7z a -t7z -mx=1 -v1900m "DaFeiYu-Portable.7z" ".\DaFeiYu-Portable\"
```

`-mx=1` 是**最快/最低压缩**：内含已压缩的 `.exe`，高压缩比收益极小但耗时极长。
产物形如 `DaFeiYu-Portable.7z.001`、`.002`，逐个检查**每一个都 < 2 GB**，使用者用 7-Zip 解第 `.001` 卷即可自动串联。

> ⚠️ 不要用 PowerShell 的 `Compress-Archive`：它对单文件 > 2 GB 与总包 > 4 GB 会失败。

### 4.3 上传

1. **Create a new release** → tag `portable-0.1` → title `大肥鱼 USB Portable 0.1`
2. 说明里写明：**这是空骨架，不含任何个人数据**；使用者首次运行时自行生成 `data/`、`memory/`
3. 逐个附加 `.7z.001`、`.7z.002` …（GitHub 不自动拆卷，需全部下载后本地解压）
4. 附上 [`releases/manifest-portable.json`](../blob/portable/releases/manifest-portable.json) 供校验

---

## 五、发布前检查清单

- [ ] `git status` 干净，没有未提交改动
- [ ] 跑过 `& ./tools/secret-scan.ps1 -Root .` → **[PASS]**
- [ ] `git ls-tree -r --name-only <分支>` 里**没有** `.bin` / `.db` / `.log` / `memory/` / `tool-output` / `prompt-history`
- [ ] 所有被跟踪文件**均 < 100 MB**（本仓库实测最大 12.5 KB）
- [ ] 待上传附件的**每一个**都 < 2 GB
- [ ] 便携版附件已剔除 `opencode.db`、`memory/`、`prompt-history.jsonl`、`*.bin`
- [ ] 发布说明里写清了 SHA-256 与校验命令
- [ ] **没有**修改或删除 v1.18.33

---

## 六、如果误传了敏感文件（应急）

1. **立即轮换该凭据**（去 DeepSeek 控制台重新生成 API Key）——这比清理历史更重要，因为泄漏已发生。
2. 从当前分支删除文件并提交。
3. 若已推送，需重写历史（`git filter-repo`）并强推；注意 GitHub 的 fork/缓存可能仍保留旧对象。
4. 记录到 `CHANGELOG.md`，写明时间与影响范围。

> **预防永远优于补救**：`.gitignore` 是路径级排除，不依赖内容识别，这是本仓库的第一道闸门。
