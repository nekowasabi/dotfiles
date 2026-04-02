# Process 3: PATH重複排除

## Overview
PATH が253エントリ（42重複、2空エントリ）に肥大化しており、全外部コマンドのルックアップが遅延している。`typeset -U path` で重複を自動排除し、不要な旧ユーザーパスを整理する。

## Affected Files
- `entry/work.zsh:26付近（env/work.zsh source直後）` — `typeset -U path` を追加
- `env/work.zsh:7` — PATH構築の確認（重複追加パターンの把握）
- `platform/mac.zsh:10,13` — PATH追加箇所の確認
- `common/standard.zsh:93` — fpath重複の確認（platform/mac.zsh:18と重複）

## Implementation Notes

### 主要変更: typeset -U path

entry/work.zsh の env/work.zsh source 直後（行26付近）に追加:
```zsh
# Why: PATH が253エントリに肥大化（42重複）。typeset -U は配列の重複要素を自動除去。
# path（小文字）は PATH（大文字）と連動する zsh 特殊変数。
typeset -U path
```

### 配置位置の理由
- entry/work.zsh は全sourceの最後に位置する
- 全ファイルのPATH追加完了後に重複排除を適用するのが最も確実
- source順序: zinit → standard → plugins → fzf → zeno → functions → aliases → platform/mac → env/work → **ここ**

### fpath重複の解消
platform/mac.zsh:18 の fpath 追加は common/standard.zsh:93 と重複:
```zsh
# standard.zsh:93 (残す)
fpath=(/usr/local/share/zsh-completions ${fpath})

# platform/mac.zsh:18 (削除候補)
# fpath=(/usr/local/share/zsh-completions ${fpath})  # standard.zshと重複
```

### 追加検討: fpath にも typeset -U
```zsh
typeset -U path fpath
```

---

## Red Phase: テスト作成と失敗確認

- [ ] ブリーフィング確認
- [ ] テストケースを作成（実装前に失敗確認）
  - `zsh -i -c 'echo $PATH | tr ":" "\n" | sort | uniq -d | wc -l'` が0でないこと（現状42）
  - `zsh -i -c 'echo $PATH | tr ":" "\n" | wc -l'` が253であること
- [ ] テストを実行して失敗することを確認

✅ **Phase Complete**

---

## Green Phase: 最小実装と成功確認

- [ ] ブリーフィング確認
- [ ] entry/work.zsh に `typeset -U path fpath` を追加
- [ ] `zsh -i -c 'echo $PATH | tr ":" "\n" | sort | uniq -d | wc -l'` が 0 であること
- [ ] `zsh -i -c 'echo $PATH | tr ":" "\n" | grep -c "^$"'` が 0 であること
- [ ] 既存コマンド（git, nvim, brew, zoxide等）が正常に動作すること

✅ **Phase Complete**

---

## Refactor Phase: 品質改善

- [ ] 旧ユーザー `takets` のパスが残存していないか確認
- [ ] PATH要素数が妥当か確認（目標: 30以下）
- [ ] テストが継続して成功することを確認

✅ **Phase Complete**

---

## Dependencies
- Requires: -
- Blocks: Process 10（ベンチマーク）, Process 100（最終検証）
