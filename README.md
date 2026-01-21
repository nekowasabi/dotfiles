# dotfiles

chezmoi で管理する dotfiles リポジトリ

## クイックスタート

### 新しいマシンでのセットアップ

```bash
# 1. private_dotfiles をクローン（先に実行）
git clone git@github.com:nekowasabi/private_dotfiles.git ~/repos/private_dotfiles

# 2. chezmoi で dotfiles をセットアップ
chezmoi init --apply https://github.com/nekowasabi/dotfiles.git
```

これだけで以下が自動的にセットアップされます：
- シェル設定 (zshrc)
- Git設定 (gitconfig)
- tmux設定
- ツール設定 (ghostty, lazygit, ripgrep)
- private_dotfiles へのシンボリックリンク

## 日常の運用

### エイリアス

| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `cm` | `chezmoi` | 基本コマンド |
| `cma` | `chezmoi add` | ファイル追加 |
| `cmd` | `chezmoi diff` | 差分確認 |
| `cme` | `chezmoi edit` | ファイル編集 |
| `cmu` | `chezmoi update` | git pull + apply |
| `cms` | `chezmoi status` | 状態確認 |
| `cmc` | `chezmoi-commit` | コミット関数 |

### 設定ファイルを変更した場合

```bash
# 1. 差分を確認
cmd

# 2. 変更をソースに追加
cma ~/.zshrc

# 3. コミット
cmc
```

### 他のマシンの変更を取り込む

```bash
# git pull + apply を一発で
cmu
```

### 新しいファイルを管理対象に追加

```bash
# ファイルを追加
cma ~/.config/newapp/config.yml

# テンプレート化する場合
cma --template ~/.config/newapp/config.yml
```

## ディレクトリ構成

```
dotfiles/
├── .chezmoi.toml.tmpl          # 環境検出テンプレート
├── .chezmoiignore              # 無視ファイル設定
├── dot_gitconfig.tmpl          # ~/.gitconfig
├── dot_zshrc.tmpl              # ~/.zshrc
├── dot_tmux.conf.tmpl          # ~/.tmux.conf
├── dot_config/                 # ~/.config/
│   ├── ghostty/config
│   ├── lazygit/config.yml
│   └── ripgrep/ripgreprc
├── run_once_after_setup_symlinks.sh.tmpl  # 初回セットアップスクリプト
├── zsh/                        # zshrc ソース（環境別）
│   ├── wsl_zshrc
│   ├── mac_zshrc
│   ├── linux_zshrc
│   └── work_zshrc
└── tmux/                       # tmux ソース（環境別）
    ├── common.conf
    ├── wsl.conf
    ├── mac.conf
    └── work.conf
```

## 環境検出

chezmoi は以下の変数で環境を自動検出します：

| 変数 | 説明 | 値の例 |
|------|------|--------|
| `.pc` | PC環境（$PC環境変数） | `wsl`, `private`, `mfs`, `work` |
| `.isWsl` | WSL環境かどうか | `true` / `false` |
| `.isMac` | Mac環境かどうか | `true` / `false` |
| `.isLinux` | Linux環境（WSL除く） | `true` / `false` |

### 環境変数の確認

```bash
chezmoi data | jq '.pc, .isWsl, .isMac'
```

## 管理対象ファイル

```bash
# 現在の管理対象を確認
chezmoi managed
```

現在の管理対象：
- `.gitconfig` - Git設定（delta, 認証情報）
- `.zshrc` - シェル設定（環境別）
- `.tmux.conf` - tmux設定（環境別）
- `.config/ghostty/config` - Ghosttyターミナル
- `.config/lazygit/config.yml` - LazyGit
- `.config/ripgrep/ripgreprc` - ripgrep

## トラブルシューティング

### 差分が出る場合

```bash
# 差分を確認
chezmoi diff

# 強制的に上書き
chezmoi apply --force
```

### テンプレートのデバッグ

```bash
# テンプレート展開結果を確認
chezmoi cat ~/.zshrc

# 環境変数を確認
chezmoi data
```

### ロールバック

```bash
# chezmoi の設定を削除
rm -rf ~/.local/share/chezmoi
rm -rf ~/.config/chezmoi

# バックアップから復元（存在する場合）
cp -r ~/repos/dotfiles.backup ~/repos/dotfiles
```

## private_dotfiles との連携

大容量ディレクトリ（claude/, aichat/ 等）は `run_once_after_setup_symlinks.sh` で
シンボリックリンクとして設定されます。

リンク先：
- `~/.claude/settings.json` → `private_dotfiles/claude/settings.json`
- `~/.claude/CLAUDE.md` → `private_dotfiles/claude/CLAUDE.md`
- `~/.config/aichat/config.yaml` → `private_dotfiles/aichat/config.yaml`

## 参考リンク

- [chezmoi 公式ドキュメント](https://www.chezmoi.io/)
- [chezmoi クイックスタート](https://www.chezmoi.io/quick-start/)
