# 记事：2026-10-10 U 盘只读核验

> 核验对象：`H:\大肥鱼-Portable`（U 盘）
> 核验方式：**全程只读**，未创建、修改、删除 U 盘或宿主上任何文件
> 对照物：`C:\Users\111\Desktop\大肥鱼-Portable`（U 盘内容在主机的副本）
> 状态标记沿用：`当前已知`（有实测证据）/ `待核验`（未验证）

---

## 一、迁移完整性 → `当前已知`（逐字节通过）

| 检查项 | 实测结果 |
|---|---|
| 真实根路径 | `H:\大肥鱼-Portable` |
| 文件数 | **50** |
| 总字节 | **2,744,260,540 B** |
| 与迁移报告比对 | 数量与总字节**完全一致** |
| 与桌面副本比对 | 相对路径集合**完全相同**（无单向多出文件） |
| 逐文件 SHA-256 比对 | **50 / 50 全部一致**，含 `agent\data\opencode\opencode.db`（2,277,351,424 B） |

**结论**：U 盘内容与主机副本逐字节相同，迁移完整。

---

## 二、便携行为 → `当前已知`（相对路径成立）

| # | 检查项 | 实测证据 | 结论 |
|---|---|---|---|
| B1 | 启动器不硬编码盘符 | `启动-大肥鱼-Portable.cmd` 内容：`set "ROOT=%~dp0"` | ✅ |
| B2 | 临时目录重定向到 U 盘内 | 同文件：`set "TEMP=%ROOT%temp"`、`set "TMP=%ROOT%temp"` | ✅ |
| B3 | 便携标记 | `portable.flag`，内容 `portable` | ✅ |
| B4 | OpenCode 工作目录跟随程序位置 | 当天日志（当时位于 `F:\lym\Zhang\大肥鱼-Portable`）：<br>`creating instance directory="F:\\lym\\Zhang\\大肥鱼-Portable"`<br>`bootstrapping directory="F:\\lym\\Zhang\\大肥鱼-Portable"` | ✅ 跟随所在位置，不写死 |
| B5 | 记忆跟随 U 盘 | `agent\config\opencode\opencode.jsonc` 用相对路径：<br>`"../../../memory/00_CORE_MEMORY.md"`、`"../../../memory/03_CONTEXT/AI_MEMORY_RULES.md"` | ✅ |
| B6 | U 盘 `memory\` 实际有记忆 | **16 个 Markdown 文件**（与交接包所述 16 个一致） | ✅ |
| B7 | 数据写在 U 盘内 | 存在 `data\logs\`、`data\webengine\cache\`、`data\webengine\storage\`、`data\config.json`、`data\desktop_pet_usage.json` | ✅ |
| B8 | U 盘内配置/日志是否引用宿主路径 | 全盘扫描 `C:\Users` / `AppData`：**仅 `agent\state\opencode\prompt-history.jsonl` 命中 7 行**，且那是**提问原文**（不是程序写宿主） | ✅ 无 |

**附带确认**：历史路径 `F:\lym\Zhang\大肥鱼-Portable` **确实被使用过**（日志为证），与交接包"曾出现该历史路径"的说法一致 —— 但它**不是当前路径**，当前是 `H:\大肥鱼-Portable`。

---

## 三、宿主残留 → `当前已知`（**发现反例**）

### 证据 1：宿主注册表存在开机自启项

```
HKCU\Software\Microsoft\Windows\CurrentVersion\Run
  DeepSeekDesktopPet = "C:\Users\111\Desktop\v1.18.37\DesktopPet\DesktopPet.exe"
```

- 该指向路径**确实存在**。
- 说明该程序的"开机自启"机制**会写宿主注册表 `HKCU\...\Run`**。
- 当前这一条来自**桌面版安装**（不是 U 盘便携版），但它证明了这个机制的存在与形态。

### 证据 2：U 盘配置里自启是开启的

`H:\大肥鱼-Portable\data\config.json` → `"autostart": { "enabled": true }`

- 与证据 1 相互印证：自启开启时程序会往宿主注册表写项。
- ⚠️ 因此**有必要验证**：从 U 盘运行时，它写的是 U 盘路径还是宿主路径 —— 见第四节。

### 证据 3：宿主有一个旧缓存目录

`C:\Users\111\AppData\Local\DesktopPet\cache\qtpipelinecache-x86_64-little_endian-llp64`

- 时间戳为 **2026-09-28**，**早于**便携版（2026-10-07），属**旧安装遗留**，非便携版运行痕迹。

---

## 四、仍属 `待核验`

| # | 事项 | 为什么还没验证 | 验证方法 |
|---|---|---|---|
| C1 | 从 U 盘运行时是否写宿主注册表（写的是哪个路径） | 需要"清掉旧项 → 启动 U 盘版 → 复查注册表"，属于**写操作**，需用户授权 | 受控实验（见第五节） |
| C2 | 是否在宿主 `%APPDATA%` / `%LOCALAPPDATA%` 产生**新**数据 | 同上，需要运行前后快照对比 | 受控实验 |
| C3 | API Key 退出后是否残留于宿主 | 需要运行程序并填入 Key | 受控实验 + 检查配置/日志/注册表/环境变量 |
| C4 | 加密实现是否真为 PBKDF2-SHA256(390k) → AES-256-GCM | **本机无源码**（只有编译好的 `DesktopPet.exe`），无法做代码级审查 | 取得源码后审查；或按行为测试 |
| C5 | portable server 端口 `4099` / health 版本 `1.18.35` | 未运行程序 | 运行后查 health endpoint |
| C6 | 换到另一台电脑 / 换盘符后能否启动 | 需要换机测试 | 换机实验 |
| C7 | 配置目录缺少 `config.json` 是否影响下次启动 | 日志显示程序会尝试加载 `agent\config\opencode\config.json`，但当前该目录**没有**此文件 | 下次启动观察，或补齐后复测 |

---

## 五、建议的受控实验（需授权，未执行）

目标是干净地回答 C1–C3、C6，且**可回滚**。

0. **前置**：先导出注册表备份
   `reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" run-backup.reg`
1. **记录基线**：列出宿主 `%APPDATA%`、`%LOCALAPPDATA%`、`%USERPROFILE%` 中与桌宠相关的目录及时间戳
2. **删除**旧自启项 `DeepSeekDesktopPet`（这是桌面版留下的，删掉不影响便携版）
3. **启动** U 盘的 `启动-大肥鱼-Portable.cmd`
4. **复查**：注册表是否被重新写入、写的是哪个路径；宿主目录是否出现**新**时间戳
5. **退出程序**，再次复查；并检查 API Key 是否在宿主任何位置残留
6. **回滚**：如需恢复，用第 0 步的备份导入

> 该实验会**修改宿主注册表**并**运行程序**，因此必须先取得用户明确同意。
> 全程建议先用一次快照（`tools/baseline.py` 或手工清单）固定基线。

---

## 六、本次核验的边界（诚实声明）

- 本次**没有**运行 U 盘上的任何程序，因此"运行期行为"全部未验证。
- 本次**没有**修改 U 盘、宿主目录或注册表的任何内容。
- "U 盘内容完整"是**逐字节验证**的结论；"换机不留痕"**不是** —— 目前只找到宿主存在旧自启项与旧缓存，尚不能判定便携版运行时的行为。
