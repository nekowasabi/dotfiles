---
title: "zsh起動パフォーマンス最適化"
status: planning
created: "2026-04-02"
---

# Commander's Intent

## Purpose
zsh起動時間が310-360msかかっており、体感で遅い。compinit(302ms)、zinit同期ロード(140ms)、PATH肥大化(253エントリ)が主因。最適化により100ms以下を目指す。

## End State
`time zsh -i -c exit` が安定して100ms以下、PATH重複ゼロ、既存機能の退行なし。

## Key Tasks
- compinit -u → -C 化（最大効果: -250ms）
- zinit turbo mode導入（zeno/fast-syntax-highlighting/autosuggestions）
- typeset -U path によるPATH重複排除 + brew --prefix/git wt 固定化

## Constraints
- 既存のプラグイン機能・補完機能を損なわない
- macOS ARM (Apple Silicon) 環境前提（/opt/homebrew）
- entry/work.zsh のsource順序を維持

---

# Progress Map

| Process | Title | Status | File |
|---------|-------|--------|------|
| 1 | compinit最適化 | ☐ planning | [-> plan/process-01.md](plan/process-01.md) |
| 2 | zinit turbo mode導入 | ☐ planning | [-> plan/process-02.md](plan/process-02.md) |
| 3 | PATH重複排除 | ☐ planning | [-> plan/process-03.md](plan/process-03.md) |
| 4 | git wt --init zsh キャッシュ化 | ☐ planning | [-> plan/process-04.md](plan/process-04.md) |
| 5 | brew --prefix 固定化 | ☐ planning | [-> plan/process-05.md](plan/process-05.md) |
| 10 | パフォーマンスベンチマーク | ☐ planning | [-> plan/process-10.md](plan/process-10.md) |
| 100 | 最終検証・回帰確認 | ☐ planning | [-> plan/process-100.md](plan/process-100.md) |
| 300 | OODA振り返り | ☐ planning | [-> plan/process-300.md](plan/process-300.md) |

**Overall**: ☐ 0/8 completed

---

# References

| @ref | @target | @test |
|------|---------|-------|
| common/standard.zsh:20-21 | compinit -u → -C | `time zsh -i -c exit` |
| common/standard.zsh:113 | git wt eval → cache | git wt 機能動作確認 |
| common/plugins.zsh:23,27,45,52 | zinit light → ice wait | プラグイン動作確認 |
| platform/mac.zsh:7 | brew --prefix → /opt/homebrew | ctags alias確認 |
| entry/work.zsh:26付近 | typeset -U path 追加 | PATH重複数=0 |
| env/work.zsh:7 | PATH構築元 | PATH要素数確認 |
| /tmp/zsh-perf-report.md | 調査レポート | — |

---

# Risks

| リスク | 対策 |
|--------|------|
| compinit -C でzcompdumpが古いまま使われ補完が壊れる | 日次再構築ロジック追加（日付チェック） |
| zinit turbo化でプラグイン読み込み順序が崩れる | wait値を段階的に設定、cdreplay維持 |
| brew --prefix固定がIntel Mac環境で動かない | 条件分岐（uname -m）で対応 |
