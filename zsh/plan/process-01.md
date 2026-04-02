# Process 1: compinit最適化

## Overview
compinit -u（302ms）をキャッシュ利用の -C に変更し、日次で zcompdump を再構築するロジックを追加する。単独で最大250msの改善が見込める最優先タスク。

## Affected Files
- `common/standard.zsh:20-21` — `autoload -Uz compinit` + `compinit -u` を最適化版に置換

## Implementation Notes

現在のコード（common/standard.zsh:20-21）:
```zsh
autoload -Uz compinit
compinit -u
```

変更後:
```zsh
autoload -Uz compinit
# Why: compinit -u は毎回フルスキャン(302ms)。-C はキャッシュ利用で高速化。
# 日付チェックで1日1回だけフルスキャンし、それ以外はキャッシュを使う。
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
```

ポイント:
- `(#qN.mh+24)` は zsh glob qualifier: 24時間以上前に更新されたファイルにマッチ
- マッチした場合（古い）→ フルスキャン `compinit`
- マッチしない場合（新しい）→ キャッシュ利用 `compinit -C`
- `-u` フラグ（insecure directory警告抑制）は環境に応じて追加検討

---

## Red Phase: テスト作成と失敗確認

- [ ] ブリーフィング確認
- [ ] テストケースを作成（実装前に失敗確認）
  - `time zsh -i -c exit` が300ms以上であること（現状確認）
  - compinit が `-u` で呼ばれていること: `zsh -x -i -c exit 2>&1 | grep 'compinit -u'`
- [ ] テストを実行して失敗することを確認

✅ **Phase Complete**

---

## Green Phase: 最小実装と成功確認

- [ ] ブリーフィング確認
- [ ] common/standard.zsh:20-21 を日付チェック付き compinit -C に変更
- [ ] `time zsh -i -c exit` で改善を確認（目標: 50ms以上の短縮）
- [ ] 補完機能が正常動作することを確認（Tab補完テスト）

✅ **Phase Complete**

---

## Refactor Phase: 品質改善

- [ ] Whyコメントが正確か確認
- [ ] `-u` フラグが必要な環境（WSL等）への条件分岐を検討
- [ ] テストが継続して成功することを確認

✅ **Phase Complete**

---

## Dependencies
- Requires: -
- Blocks: Process 10（ベンチマーク）, Process 100（最終検証）
