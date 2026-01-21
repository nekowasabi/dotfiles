# chezmoi 移行ガイド

rsync 管理から chezmoi 管理への移行手順

## 前提条件

- dotfiles リポジトリが `~/repos/dotfiles` にクローン済み
- private_dotfiles リポジトリが `~/repos/private_dotfiles` にクローン済み

## 移行手順

### Step 1: chezmoi インストール

#### Mac (Homebrew)
```bash
brew install chezmoi
```

#### Linux (Nix)
```bash
nix-env -iA nixpkgs.chezmoi
```

#### その他の方法
```bash
# 公式インストーラー
sh -c "$(curl -fsLS get.chezmoi.io)"
```

### Step 2: chezmoi 初期化

```bash
# dotfiles リポジトリから初期化
chezmoi init --apply ~/repos/dotfiles
```

これで以下が自動的にセットアップされます：
- `~/.zshrc` - シェル設定
- `~/.gitconfig` - Git設定
- `~/.tmux.conf` - tmux設定
- `~/.config/ghostty/`, `~/.config/lazygit/`, `~/.config/ripgrep/` - ツール設定
- private_dotfiles へのシンボリックリンク

### Step 3: 動作確認

```bash
# 環境変数を確認
chezmoi data | jq '.pc, .isWsl, .isMac'

# 管理対象ファイルを確認
chezmoi managed

# 差分がないことを確認
chezmoi diff
```

### Step 4: シェル再読み込み

```bash
source ~/.zshrc
```

これで chezmoi エイリアスが使えるようになります。

## 移行後の運用

### 従来の rsync との対応

| 操作 | rsync（従来） | chezmoi（新） |
|------|--------------|--------------|
| 保存 | `rsync_commit` | `cmr` + `cmc` + `git push` |
| 反映 | `rsync_deploy` | `cmu` |
| 差分確認 | `git diff` | `cmd` |

### 日常の運用コマンド

```bash
# ファイル変更後
cmr       # 全変更をソースに反映
cmc       # コミット
git push  # プッシュ

# 他の環境の変更を取り込み
cmu       # git pull + apply
```

### エイリアス一覧

| エイリアス | コマンド | 説明 |
|-----------|---------|------|
| `cm` | `chezmoi` | 基本コマンド |
| `cma` | `chezmoi add` | ファイル追加 |
| `cmd` | `chezmoi diff` | 差分確認 |
| `cme` | `chezmoi edit` | ファイル編集 |
| `cmu` | `chezmoi update` | pull + apply |
| `cms` | `chezmoi status` | 状態確認 |
| `cmr` | `chezmoi re-add` | 全変更を一括反映 |
| `cmc` | `chezmoi-commit` | コミット関数 |

## 並行運用期間

chezmoi 導入前の環境では、従来通り rsync スクリプトを使用できます。

- rsync と chezmoi は同じファイルを管理
- どちらの方法でも同じ結果になる
- 各環境で chezmoi 準備が整ったら移行

## トラブルシューティング

### chezmoi init で差分が出る場合

```bash
# 差分を確認
chezmoi diff

# 現在の設定を優先する場合
chezmoi add ~/.zshrc  # 現在のファイルでソースを更新

# リポジトリを優先する場合
chezmoi apply --force  # リポジトリの内容で上書き
```

### 環境変数 $PC が設定されていない場合

`~/.zshrc` の冒頭で $PC を設定してください：

```bash
export PC="private"  # または "work", "mfs" など
```

### private_dotfiles のシンボリックリンクが作成されない

```bash
# 手動で run_once スクリプトを再実行
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

## 環境別チェックリスト

### Mac (PC=private)
- [ ] chezmoi インストール (`brew install chezmoi`)
- [ ] `chezmoi init --apply ~/repos/dotfiles`
- [ ] `source ~/.zshrc`
- [ ] `chezmoi data` で `isMac: true` 確認

### Mac (PC=work)
- [ ] chezmoi インストール (`brew install chezmoi`)
- [ ] `chezmoi init --apply ~/repos/dotfiles`
- [ ] `source ~/.zshrc`
- [ ] `chezmoi data` で `pc: "work"` 確認

### WSL (PC=wsl)
- [x] chezmoi インストール済み
- [x] chezmoi 初期化済み
- [x] 動作確認済み

### Linux (PC=linux)
- [ ] chezmoi インストール (`nix-env -iA nixpkgs.chezmoi`)
- [ ] `chezmoi init --apply ~/repos/dotfiles`
- [ ] `source ~/.zshrc`
- [ ] `chezmoi data` で `isLinux: true` 確認
