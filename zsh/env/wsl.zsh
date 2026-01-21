# WSL environment specific settings

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

# Python/Pip エイリアス (linuxbrew版)
alias python3='/home/linuxbrew/.linuxbrew/bin/python3.12'
alias pip3='/home/linuxbrew/.linuxbrew/bin/pip3.12'

# Deno環境設定
export DENO_INSTALL="/home/linuxbrew/.linuxbrew"
export PATH="$DENO_INSTALL/bin:$PATH:/home/takets/.local/bin"

# Denops テスト設定
export DENOPS_TEST_DENOPS_PATH=/home/takets/.config/nvim/plugged/denops.vim
export DENOPS_TEST_NVIM=/usr/local/bin/nvim
export DENOPS_TEST_VIM=/usr/local/bin/vim

# mise (runtime version manager)
eval "$(mise activate zsh)"
