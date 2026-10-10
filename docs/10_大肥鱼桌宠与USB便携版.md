<!--
  来源：Luna_to_DeepSeek_Harness_Handoff_2026-10-09.zip → 10_DA_FEI_YU_PORTABLE.md
  完整性：SHA-256 82f0ec34add73efec70b0483d6ec23f2856c731a24f9cd79eddfffdad5c674e9（4,894 B）
  本副本与原件逐字节一致，未作删改。状态标记严格沿用原件约定。
-->

# 大肥鱼 DesktopPet + USB Portable 交接

## 1. 当前目标与硬约束

目标是让“大肥鱼”可从 U 盘运行、携带 OpenCode/Agent 数据与记忆，并实现真正的 USB-contained portable 行为：

- 重要个人数据、agent 会话、memory 与相关缓存放在 USB 根目录下。
- 用户明确不接受在其他电脑上留下个人数据或 API 凭证，**即使加密保存也不接受**。
- 解锁体验希望为 UI 内解锁，而非启动弹窗阻塞。
- 加密设计的历史方案：PBKDF2-SHA256（390k iterations）→ AES-256-GCM。必须核验当前代码实现，不要只凭设计说明认定安全。

## 2. 最新已知真实路径与迁移状态

- **当前 U 盘盘符：H:**，目标根目录：`H:\大肥鱼-Portable\`。
- 2026-10-08 报告：从旧路径 `F:\大肥鱼-Portable\` 移动到 `H:\大肥鱼-Portable\`，采取复制 → 全量 SHA-256 校验 → 删除源的顺序。
- 迁移报告中的总量：50 个文件 / 2,744,260,540 bytes；目标数量和大小一致，SHA-256 校验通过；旧路径 `F:\大肥鱼-Portable\` 已不存在。
- 曾出现过历史路径 `F:\lym\Zhang\大肥鱼-Portable\`，不得再把它写成当前路径。
- 过去的基础版本曾命名为 `DesktopPet-v1.18.37-teacher.zip`，v1.18.37 是近期 portable 工作版本的来源；v1.18.34 曾修 Agent pill 的 z-index。**不得修改旧 v1.18.33**（用户明确要求保护旧版本）。实际 USB 上当前二进制版本、构建时间与 hash 待核验。

## 3. 已知数据规模 / 目录结构

先前迁移清单报告：

- OpenCode DB 约 2.17 GB；86 sessions / 3963 messages / 16282 parts。
- memory 文件夹包含 16 个 Markdown 文件，含 `00_CORE_MEMORY.md`、`AI_MEMORY_RULES.md`。
- portable 根结构曾列有：`DesktopPet.exe`（约 387.9 MB）、`opencode-windows-x64.zip`、`portable.flag`、`启动-大肥鱼-Portable.cmd`、`data/`、`agent/`、`memory/`、`temp/`。
- 曾报告 portable server 使用端口 `4099`，health 版本报告为 `1.18.35`。版本号与旧基础包 v1.18.37 可能有构建/服务版本差异，应核验实际当前启动项和 health endpoint，不要假设它们相同。

## 4. 历史技术与设计线索

- 早期目标：把 OpenCode Agent 的运行状态显示给桌宠，而不只是普通 DeepSeek 聊天宠物。
- 曾使用/核对本地 OpenCode 服务：`opencode serve`，默认 `127.0.0.1:4096`；有关 `/global/health`、`/session/status`、`/event` 的集成概念曾被讨论。当前 portable server 也曾报告使用 4099，需区分本地开发默认端口与 portable 服务端口。
- 旧版曾优化 `web_view` 避免固定每 1.5 秒无条件 redraw，并把 OpenCode health polling 设为 OFFLINE 2 秒、ONLINE 10 秒（仅作为历史实现线索，需检查当前分支代码）。
- 用户曾要求移除左键 CPU/system metrics 弹窗，禁用粉色 Remielle 宠物，并排查桌宠“抖动”。历史审计曾发现 roaming disabled 且未见窗口位置变化，推测可能是状态动画/注意力动画，但不是已证实的根因。

## 5. 历史开发项目状态与旧判断的更新

旧 2026-09-29 GPT Memory Export 把大肥鱼写成“开发项目已完成”且提到 Harness bridge 被放弃。这**已经不足以代表当前状态**：之后继续开发了 USB Portable 版本并在 2026-10-08 移动到 H 盘。因此当前应该视为 **Portable 安全验证/迁移后的验收项目仍需核验**，不是简单封存。

旧报告中关于 Harness 1.8.0 / dsh 0.1.7-rc.2 曾经发生 Electron/V8 `EXCEPTION_BREAKPOINT` 崩溃，并在移除 pet bridge、clean userData 和 `--disable-gpu` 后仍未解决。那是旧集成尝试的历史问题，不应直接推断当前 DeepSeek Harness/DSH 状态或当前大肥鱼一定仍复现同样崩溃。

## 6. 接管后第一轮验收

在 H 盘接入后，只读核验：

1. H 盘是否仍存在，真实根路径、文件数量、总字节数、关键文件 hash。
2. `DesktopPet.exe`、启动脚本、`portable.flag`、`data/agent/memory/temp` 的实际结构。
3. USB 拔出/换盘符场景的路径构造方式是否使用相对路径/启动脚本盘符，而非硬编码 F: 或 H:。
4. 程序运行时是否在宿主 `%APPDATA%`、`%LOCALAPPDATA%`、`%USERPROFILE%`、临时目录、注册表、系统任务或日志中产生可持久的个人数据/API 凭证。
5. API key 是否仅在用户授权的临时/内存流程使用，退出后不留在 host；检查配置文件、日志、crash dump、browser cache 和环境变量。
6. PBKDF2/AES-GCM 实现、nonce 唯一性、tag 校验、失败处理、密钥清理与 UI 解锁流程是否经过安全审查。
7. `4099` health endpoint 是否来自当前 USB 根的服务，版本与数据路径是否匹配。

不允许为了验证而删除原有数据；先检查，在批准后设计无风险、可回滚测试。
