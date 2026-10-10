# 安全边界 —— 本仓库**永不收录**的内容

> 本文件是仓库的自我约束声明。若发现下列内容出现在本仓库任何分支、任何提交历史中，**视为事故**，需立即轮换对应凭据。

## 一、绝不入库（永久排除）

| 类别 | 具体路径示例 | 为什么 |
|---|---|---|
| **API Key / 令牌** | `desktop_pet_api_key.bin`、`desktop_pet_platform_token.bin`、`.credentials.yaml`、`.env` | 凭据一旦进 git 历史，删不干净 |
| **会话数据库** | `agent\data\opencode\opencode.db`（约 2.12 GB）、`*.db-shm`、`*.db-wal` | 含全部对话历史，属个人数据 |
| **个人记忆** | `memory\*.md`（`02_ZHANG_RESEARCH.md`、`01_TOTAL_PLAN.md`、`04_PSY.md`、`07_TOEFL\*` 等） | 学业、科研、个人规划 |
| **运行日志** | `opencode.log`、`desktop_pet_startup.log`、`desktop_pet_opencode_serve.log` | 可能含路径、提示原文、错误栈 |
| **提示历史** | `prompt-history.jsonl` | 个人提问原文 |
| **工具输出** | `agent\data\opencode\tool-output\*` | 命令输出原文 |
| **程序本体与发行包** | `DesktopPet.exe`、`opencode-windows-x64.zip`、`*.7z` | 超过 GitHub 单文件 100 MB 上限；走 Release |
| **运行期目录** | `data\`、`temp\`、`logs\`、`locks\` | 每次运行都在变 |

`.gitignore` 已对以上全部模式做强制排除。

## 二、允许入库

- 文档（`docs/`）：设计、验收、历史快照（仅追溯用途）
- 元数据清单（`releases/manifest*.json`）：**只有文件名 / 大小 / SHA-256 / 时间**，不含内容
- 脚本（`tools/`、`scripts/`）：脱敏、可公开
- 配置**模板**（`*.template`）：字段齐全但值留空

## 三、提交前自检

```powershell
pwsh ./tools/secret-scan.ps1 -Root .
```

- 发现被禁文件 → **退出码 1，禁止提交**
- 命中疑似凭据模式 → 警告，人工复核

## 四、已知的"扫不到不等于没有"

模式扫描只能发现**常见格式**的密钥。真正的保证来自：

1. `.gitignore` 的路径级排除（不依赖内容识别）
2. 只从**明确白名单**的路径复制文件进仓库
3. 提交前人工过一遍 `git status` 与 `git diff --cached --stat`

## 五、将来若要在仓库内放"便携发行包"

不要把 `.exe` / `.db` 提交进 git。正确做法：

- 用 7-Zip 分卷压到**每卷 < 2 GB**（GitHub Release 单附件上限）
- 作为 **Release 附件**上传
- 在仓库里只放 `releases/manifest-portable.json` + `CHANGELOG.md` 说明

## 六、使用者须知（沿用程序自带说明）

> API Key / 令牌属于个人凭据，请不要分享给其他人，也不要提交到任何代码仓库。
