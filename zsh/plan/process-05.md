# Process 5: brew --prefix 固定化

## Overview
platform/mac.zsh:7 の `` `brew --prefix` `` バッククォート（24ms）を固定値 `/opt/homebrew` に変更する。

## Affected Files
- `platform/mac.zsh:7` — `` alias ctags="`brew --prefix`/bin/ctags" `` を固定値に変更

## Implementation Notes

現在のコード（platform/mac.zsh:7）:
```zsh
alias ctags="`brew --prefix`/bin/ctags"
```

変更後:
```zsh
# Why: `brew --prefix` は毎回サブプロセス起動(24ms)。Apple Silicon Mac では
# /opt/homebrew 固定。Intel Mac は /usr/local だが現環境はARM。
alias ctags="/opt/homebrew/bin/ctags"
```

注意: Intel Mac 環境（/usr/local）との互換性が必要な場合は条件分岐を追加:
```zsh
if [[ "$(uname -m)" == "arm64" ]]; then
  alias ctags="/opt/homebrew/bin/ctags"
else
  alias ctags="/usr/local/bin/ctags"
fi
```

---

## Red Phase: テスト作成と失敗確認

- [ ] ブリーフィング確認
- [ ] `time brew --prefix > /dev/null` で現在のコスト確認（~24ms）
- [ ] テストを実行して失敗することを確認

✅ **Phase Complete**

---

## Green Phase: 最小実装と成功確認

- [ ] ブリーフィング確認
- [ ] platform/mac.zsh:7 を固定値に変更
- [ ] `which ctags` で正しいパスが返ることを確認
- [ ] ctags コマンドが動作することを確認

✅ **Phase Complete**

---

## Refactor Phase: 品質改善

- [ ] 他に brew --prefix を使用している箇所がないか確認
- [ ] テストが継続して成功することを確認

✅ **Phase Complete**

---

## Dependencies
- Requires: -
- Blocks: Process 10（ベンチマーク）
