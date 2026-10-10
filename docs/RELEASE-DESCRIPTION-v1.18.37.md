## 大肥鱼 / DesktopPet v1.18.37

Windows 桌面宠物（DeepSeek 娘 · 大肥鱼）。

**怎么用**

1. 下载下方 `v1.18.37.zip` 并解压到任意目录。
2. 双击 `DesktopPet.exe` 运行 —— 不需要 Python / Node / npm，也不需要管理员权限。
3. 首次启动会弹出「欢迎使用大肥鱼」向导，按提示逐项配置即可。
4. 普通聊天需要你自己的 DeepSeek API Key：右键桌宠 → **设置 → 聊天 API**，填入你的 Key。
   Key 由程序在本机加密保存（Windows DPAPI），**不写入配置或日志，也不随程序发布**。
5. 「呼叫 Agent！」需要 OpenCode：本包已内置官方 CLI，首次启动会自动离线安装并启动
   Agent Server（仅监听 `127.0.0.1:4096`），无需打开 CMD 或 npm。

**包内含什么**

| 文件 | 字节 |
| --- | --- |
| `DesktopPet/DesktopPet.exe` | 383,884,955 |
| `DesktopPet/opencode-windows-x64.zip` | 62,127,126 |
| `DesktopPet/使用说明.txt` | 1,458 |

**完整性校验**

| 项 | 值 |
| --- | --- |
| 附件 | `v1.18.37.zip` |
| 大小 | 443,814,276 B（423.3 MiB） |
| SHA-256 | `929e6595991113561af3aa10755ff2616884887d78562d0ec76cb0dd5306e1a1` |

逐文件比对（需先下载本仓库的清单文件 `releases/manifest-v1.18.37.json`）：

```powershell
pwsh ./tools/verify.ps1 -Root "<解压后的目录>" -Manifest ./releases/manifest-v1.18.37.json
```

**注意**

- 本程序**未数字签名**，部分 Windows 安全设置（如"智能应用控制"）可能提示拦截；
  请在确认来源可信后选择允许运行。
- 本仓库**不含任何 API Key、令牌或会话数据**；本附件亦已逐条核对，无凭据文件。
