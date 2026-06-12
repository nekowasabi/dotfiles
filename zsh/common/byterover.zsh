# ByteRover CLI (brv)
# Why: install.sh は ~/.zshrc に PATH 追記するが、nix(home-manager)管理のため
# 直接編集不可。dotfiles 側で同等の PATH 設定を行う。
# Why: $PC=wsl / private のみで有効化（work 環境では brv を使わないため）
case "$PC" in
  wsl|private)
    [[ -d "$HOME/.brv-cli/bin" ]] && export PATH="$HOME/.brv-cli/bin:$PATH"

    # Why: brv の LLM プロバイダは Ollama (127.0.0.1:11434) で、未起動だと
    # ECONNREFUSED で全リトライが失敗する。手動起動を忘れやすいため、
    # brv 実行前にヘルスチェックし未起動なら ollama serve を自動起動する。
    # Why: サブコマンド判別はしない — search 等 LLM 不要の操作でも起動するが、
    # 起動は冪等・軽量であり、判別ロジックの保守コストの方が高い。
    brv() {
      if command -v ollama >/dev/null 2>&1 \
        && ! curl -sf --max-time 1 http://127.0.0.1:11434/api/version >/dev/null 2>&1; then
        echo "[brv] Ollama が未起動のため自動起動します..." >&2
        nohup ollama serve >>"${XDG_CACHE_HOME:-$HOME/.cache}/ollama-serve.log" 2>&1 &!
        local _i
        for _i in {1..20}; do
          curl -sf --max-time 1 http://127.0.0.1:11434/api/version >/dev/null 2>&1 && break
          sleep 0.5
        done
      fi
      command brv "$@"
    }
    ;;
esac
