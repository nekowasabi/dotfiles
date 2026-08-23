# WSL zsh: PATH構築行より後の変数定義は空展開になる罠 ＋ 実読込チェーン

## WSL の zsh 実読込チェーン（2026-08 検証済み）
home-manager 管理の `~/.zshrc` → `zsh/platform/linux.zsh` → `zsh/env/wsl.zsh` の順で読み込まれる。
**旧 `zsh/wsl_zshrc` は読み込まれていないデッドファイル**。そこに GOPATH 等の定義があっても実環境には反映されない。WSL の環境変数・PATH を直すときは `platform/linux.zsh`（Linux/WSL 専用、mac には影響しない）を編集する。

## 事象（GOPATH 空展開）
`platform/linux.zsh` の PATH 構築行が `$GOPATH/bin`（`$GOROOT/bin` も同様）を参照していたが、GOPATH が読込チェーンのどこでも export されておらず空展開され、`~/go/bin` が PATH に入っていなかった。修正は PATH 行の直前に `export GOPATH="$HOME/go"` を追加。

## 根本原因
zsh は上から順に評価するため、PATH 構築行の時点で未定義の変数は空展開される。見た目上は「PATH に追加済み」に見えるので気づきにくい。

## 対処・再発防止
- PATH 参照用の変数（GOPATH / GOROOT 等）を追加・変更するときは、必ず PATH 構築行より**前**に定義を置く。
- grep で定義を見つけても、そのファイルが実際に読込チェーンに入っているか確認する（`wsl_zshrc` のようなデッドファイルに騙されない）。
- 修正後は `zsh -c 'source ~/.zshrc; echo $PATH'` や `echo $PATH | tr ':' '\n' | grep go` で実際に展開されているか確認する。

## 教訓
既存の PATH 行に変数参照を追記するだけの変更でも、定義順と読込チェーンを確認しないと「空展開で無効」という無言の失敗になる。
