# Effective Harnesses Codex

[English](./README.md)

一个面向 Codex 深度优化的长期运行 Agent Harness 工作流版本。

这个仓库将 Anthropic 对长时间运行 Agent 的 harness 思路，进一步落地为更适合 Codex 的工程化流程：一次只聚焦一个活跃 feature、把关键状态持久化到仓库中、严格区分“已完成实现”和“已通过验证”，并通过清晰的交接产物让后续会话可以低成本接续工作，而不是依赖模型记忆重新恢复上下文。

本仓库构建于以下工作之上：

- https://github.com/Suibosama/effective-harnesses
- https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents

感谢原始项目与原始文章提供的思路、结构和启发。

## 为什么需要它

长期运行的编码任务通常会在以下几个地方失控：

- 活跃任务在多次会话之间逐渐漂移
- 验证过程被跳过、弱化，或者只停留在口头判断
- Agent 开始依赖“记得差不多”，而不是依赖仓库里的持久化状态
- 新请求悄悄覆盖掉旧任务，但没有留下明确切换记录
- 下一次会话必须通过提交记录、终端输出和零散注释重新推断进度

`effective-harnesses-codex` 的目标就是降低这些问题的发生概率。它为 Codex 提供一套严格、轻量、可恢复的 repo-local 工作循环，让进度更加稳定、可审计、可继续。

## 核心机制

整体机制延续了 Anthropic 在 harness 文章中的核心思路：

1. 将关键工作状态持久化到仓库文件中。
2. 在每次新会话开始时重新读取这些状态。
3. 每次只处理一个边界清晰的工作单元。
4. 在声明完成之前先做真实验证。
5. 在会话结束前留下结构化交接信息，方便下一次继续。

在本仓库中，这套机制通过 `.effective-harnesses/` 目录下的文件来承载：

- `feature_list.json`：作为 feature 追踪与状态管理的权威来源
- `agent-progress.md`：记录当前焦点、验证结果和交接说明
- `init.sh`：在需要时提供仓库本地启动或初始化辅助脚本
- `HARNESS.md`：提供后续会话可快速读取的简明本地规则

它背后的核心原则很简单：只要仓库可以承载状态，就不要把状态寄托在模型记忆里。

## 这个 Codex 版本做了哪些优化

这不是简单搬运，而是一个面向 Codex 实际工作方式的收敛与增强版本。

相对上游版本，这里重点强化了：

- 更适配 Codex 的执行规则，而不是依赖 Claude 风格的提示习惯
- 明确的单一活跃 feature 协议，避免会话中途无记录切换任务
- 更严格的验证策略，明确区分 `completed` 和 `passes: true`
- `run-to-pass` 模式，让 Codex 可以围绕同一个 feature 持续修复直到通过真实 gate 或遇到明确 blocker
- 现有仓库 adoption 流程，可直接接管成熟代码库，而不是假设所有项目都从空目录开始
- 将 harness 产物统一收敛到隐藏目录 `.effective-harnesses/`，减少根目录污染与命名冲突
- 增加 durable session checklist 和人类可读参考文档，方便团队协作和后续维护
- 在询问用户前优先做仓库命令发现，自动推断启动与验证方式
- 更严格的 handoff-clean 约束，让提交边界和会话状态更一致

## 你能获得什么

- 一套适用于多会话工程任务的可复用 Codex Skill
- 更稳定的 feature 拆分与长期任务推进方式
- 更可重复的会话启动、执行与收尾节奏
- 更安全的自治迭代循环和更明确的停止条件
- 更适合个人开发，也更适合多人协作下的 Agent 工作流

## 安装

```bash
git clone git@github.com:ansvver/effective-harnesses-codex.git ~/.codex/skills/effective-harnesses
```

## 典型用法

你可以直接对 Codex 说：

- `Use effective-harnesses to adopt this repository.`
- `Use effective-harnesses to add a feature: improve the backend smoke checks.`
- `Use effective-harnesses to complete feat-002.`
- `Use effective-harnesses to run feat-003 to pass.`
- `Use effective-harnesses to summarize project progress.`

如果你想看更完整的上手说明，可以参考 `references/usage.md`。

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
│   ├── session-checklist.md
│   └── usage.md
└── templates/
    ├── HARNESS.md
    ├── agent-progress.md
    ├── feature-list.json
    └── init.sh
```

## 适合谁使用

如果你希望得到以下能力，这个项目会比较适合：

- 为长期实现任务建立更清晰的推进流程
- 让 Agent 的决策、状态和验证结果有可追溯记录
- 提升跨会话接续工作的稳定性
- 以更严格的验证纪律来约束 Agent 驱动开发
- 构建一套可以被他人阅读、复用和持续改进的工作方式

## 参与贡献

如果你也认为 Agent 工作流应该更可复现、更少依赖临场发挥，这个仓库值得一起打磨。

欢迎重点改进这些方向：

- 完善 `commands/` 中的流程设计
- 强化 `templates/` 中的模板结构
- 在 `references/` 中补充更真实的使用示例
- 为更多类型的仓库补齐验证与恢复规则
- 在不引入额外重量的前提下，继续优化 Codex 的交互模型

如果这个项目对你有帮助，欢迎 star、提 issue、发 PR，一起把长期运行 Agent 的工作流做得更稳定、更清晰、更容易扩展。
