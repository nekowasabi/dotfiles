# Process 2: zinit turbo mode導入

## Overview
zinit の同期ロード（140ms合計）を turbo mode（`wait` ice）に変更し、非必須プラグインを遅延ロードする。zeno.zsh(71ms)、fast-syntax-highlighting(34ms)が主要ターゲット。

## Affected Files
- `common/plugins.zsh:23` — zsh-autosuggestions: `zinit light` → `zinit ice wait"0" lucid; zinit light`
- `common/plugins.zsh:27` — zsh-completions: `zinit light` → `zinit ice wait"0" lucid; zinit light`
- `common/plugins.zsh:45` — fast-syntax-highlighting: `zinit light` → `zinit ice wait"0" lucid; zinit light`
- `common/plugins.zsh:52-53` — fzf: `zinit ice from"gh-r" as"program"` → `zinit ice wait"1" lucid from"gh-r" as"program"`
- `common/plugins.zsh:57` — cd-bookmark: `zinit light` → `zinit ice wait"1" lucid; zinit light`
- `common/zeno.zsh` — zeno.zshの読み込み部分を遅延化検討

## Implementation Notes

### turbo化するプラグイン（優先度順）

1. **fast-syntax-highlighting** (34ms) — `wait"0"` で問題なし（入力開始後に有効化）
   ```zsh
   # 現在 (plugins.zsh:45):
   zinit light zdharma-continuum/fast-syntax-highlighting
   # 変更後:
   zinit ice wait"0" lucid
   zinit light zdharma-continuum/fast-syntax-highlighting
   ```

2. **zsh-autosuggestions** (6ms) — `wait"0"` で問題なし
   ```zsh
   # 現在 (plugins.zsh:23):
   zinit light zsh-users/zsh-autosuggestions
   # 変更後:
   zinit ice wait"0" lucid
   zinit light zsh-users/zsh-autosuggestions
   ```

3. **zsh-completions** (4ms) — `wait"0"` + atload で compdef リプレイ
   ```zsh
   # 現在 (plugins.zsh:27):
   zinit light zsh-users/zsh-completions
   # 変更後:
   zinit ice wait"0" lucid
   zinit light zsh-users/zsh-completions
   ```

4. **fzf** — `wait"1"` で遅延（バイナリ取得は非同期OK）
   ```zsh
   # 現在 (plugins.zsh:52-53):
   zinit ice from"gh-r" as"program"
   zinit load junegunn/fzf
   # 変更後:
   zinit ice wait"1" lucid from"gh-r" as"program"
   zinit load junegunn/fzf
   ```

5. **cd-bookmark** — `wait"1"` で遅延
   ```zsh
   # 現在 (plugins.zsh:57):
   zinit light mollifier/cd-bookmark
   # 変更後:
   zinit ice wait"1" lucid
   zinit light mollifier/cd-bookmark
   ```

### turbo化しないプラグイン
- **pure (prompt)**: プロンプトは即時表示が必要。turbo化不可。
- **zinit-annex-***: zinit本体の拡張。turbo化不可（ドキュメント明記）。

### zeno.zsh について
- zeno.zshはcommon/zeno.zshで独自にsourceされており、zinit管理外
- 遅延化にはzeno.zsh自体のlazy-load化が必要（複雑度高、別Process検討）
- 本Processではzinit管理下のプラグインのみ対象

### 注意事項
- `lucid` ice: turboモードのメッセージ表示を抑制
- `wait"0"`: プロンプト表示直後にロード
- `wait"1"`: プロンプト表示後1秒でロード
- `zinit cdreplay`（standard.zsh:107）は維持する（turbo後のcompdef適用に必要）

---

## Red Phase: テスト作成と失敗確認

- [ ] ブリーフィング確認
- [ ] テストケースを作成（実装前に失敗確認）
  - `zinit times` で全プラグインが同期ロードされていること（現状確認）
  - 起動直後に `zinit loaded` で全プラグインがロード済みであること
- [ ] テストを実行して失敗することを確認

✅ **Phase Complete**

---

## Green Phase: 最小実装と成功確認

- [ ] ブリーフィング確認
- [ ] common/plugins.zsh の対象5プラグインに `zinit ice wait lucid` を追加
- [ ] `time zsh -i -c exit` で改善を確認
- [ ] 各プラグイン機能の動作確認（Tab補完、構文ハイライト、fzf Ctrl+R）

✅ **Phase Complete**

---

## Refactor Phase: 品質改善

- [ ] wait値の最適チューニング（体感テスト）
- [ ] turbo化後に `zinit cdreplay` が正しく動作するか確認
- [ ] テストが継続して成功することを確認

✅ **Phase Complete**

---

## Dependencies
- Requires: -
- Blocks: Process 10（ベンチマーク）, Process 100（最終検証）
