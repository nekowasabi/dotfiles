# WSL environment specific settings

# 復号キーの読み込み（dotenvx用）
[ -f "$HOME/.zshenv.local" ] && source "$HOME/.zshenv.local"

# dotenvx による機密情報の復号と読み込み
if command -v dotenvx &> /dev/null && [ -f "$HOME/.env.zsh" ]; then
  # シンボリックリンクを解決して実体パスを使用
  # --all を削除（.envファイルの変数のみを取得）
  local env_file="$(readlink -f "$HOME/.env.zsh" 2>/dev/null || echo "$HOME/.env.zsh")"
  eval "$(dotenvx get --format eval -f "$env_file" 2>/dev/null || true)"
fi

# SSH Agent設定
# SSH_AUTH_SOCKが設定されていない場合、エージェントを起動
if [ -z "$SSH_AUTH_SOCK" ]; then
	# 既存のagentソケットを探す
	export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"

	# agentが動いていなければ起動
	if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
		rm -f "$SSH_AUTH_SOCK"
		eval "$(ssh-agent -a $SSH_AUTH_SOCK -s)" > /dev/null
	fi
fi

# SSH鍵の自動登録（鍵が登録されていない場合のみ）
ssh-add -l &>/dev/null || ssh-add ~/.ssh/id_ed25519 2>/dev/null

# linuxbrewのパス設定
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# neovim エイリアス (linuxbrew版)
alias v='/home/linuxbrew/.linuxbrew/bin/nvim'


# Deno環境設定
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH:/home/takets/.local/bin"

# Denops テスト設定
export DENOPS_TEST_DENOPS_PATH=/home/takets/.config/nvim/plugged/denops.vim
export DENOPS_TEST_NVIM=/usr/local/bin/nvim
export DENOPS_TEST_VIM=/usr/local/bin/vim

# mise (runtime version manager)
eval "$(mise activate zsh)"
