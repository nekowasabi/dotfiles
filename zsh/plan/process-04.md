# Process 4: git wt --init zsh キャッシュ化

## Overview
`eval "$(git wt --init zsh)"`（34ms）を出力キャッシュファイル方式に変更し、起動時コストを削減する。

## Affected Files
- `common/standard.zsh:113` — `eval "$(git wt --init zsh)"` をキャッシュ方式に変更

## Implementation Notes

現在のコード（common/standard.zsh:113）:
```zsh
eval "$(git wt --init zsh)"
```

変更後:
```zsh
# Why: eval "$(git wt --init zsh)" は毎回サブプロセス起動(34ms)。
# キャッシュファイルに保存し source で読み込むことで起動コストをほぼゼロにする。
_git_wt_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/git-wt-init.zsh"
if [[ ! -f "$_git_wt_cache" ]] || [[ -n "$_git_wt_cache"(#qN.mh+24) ]]; then
  mkdir -p "${_git_wt_cache:h}"
  git wt --init zsh > "$_git_wt_cache" 2>/dev/null
fi
source "$_git_wt_cache"
```

ポイント:
- 24時間ごとにキャッシュを再生成
- `git wt` コマンドが存在しない環境でもエラーにならない（2>/dev/null）
- `${_git_wt_cache:h}` は親ディレクトリ（zsh modifier）

---

## Red Phase: テスト作成と失敗確認

- [ ] ブリーフィング確認
- [ ] `time git wt --init zsh > /dev/null` で現在のコスト確認（~34ms）
- [ ] テストを実行して失敗することを確認

✅ **Phase Complete**

---

## Green Phase: 最小実装と成功確認

- [ ] ブリーフィング確認
- [ ] common/standard.zsh:113 をキャッシュ方式に変更
- [ ] git wt 関連コマンドが正常動作することを確認
- [ ] キャッシュファイルが生成されることを確認

✅ **Phase Complete**

---

## Refactor Phase: 品質改善

- [ ] キャッシュ無効化コマンド（手動再生成）の追加を検討
- [ ] テストが継続して成功することを確認

✅ **Phase Complete**

---

## Dependencies
- Requires: -
- Blocks: Process 10（ベンチマーク）
