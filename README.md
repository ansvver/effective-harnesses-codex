# Effective Harnesses Codex

基于长期运行代理工作流整理的 Codex Skill，用于在多会话开发任务里稳定保存上下文、推进单一活跃 feature，并留下可恢复的执行记录。

这个仓库构建于以下工作之上：

- https://github.com/Suibosama/effective-harnesses
- https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents

感谢原始思路与实现提供的启发。

## 安装

```bash
git clone git@github.com:ansvver/effective-harnesses-codex.git ~/.codex/skills/effective-harnesses
```

## 适用场景

- 需要跨多次会话持续推进的工程任务
- 需要明确 feature 拆分、状态追踪和交接记录的项目
- 需要在实现前后保留验证结果与下一步建议的仓库

## 仓库结构

```text
.
├── SKILL.md
├── commands/
│   ├── add-feature.md
│   ├── complete.md
│   ├── init.md
│   ├── run-to-pass.md
│   └── status.md
├── references/
│   └── usage.md
└── templates/
    ├── HARNESS.md
    ├── agent-progress.md
    ├── feature-list.json
    └── init.sh
```

## 核心能力

- 初始化项目级 harness 文件
- 维护单一活跃 feature 与可恢复的进度日志
- 在实现前记录基线，在完成后记录验证结果
- 为后续会话提供明确的启动顺序和交接信息

## 使用方式

在目标项目中直接告诉 Codex：

- `Use effective-harnesses to adopt this repository.`
- `Use effective-harnesses to add a feature: ...`
- `Use effective-harnesses to complete feat-001.`
- `Use effective-harnesses to summarize project progress.`

更完整的使用说明见 `references/usage.md`。
