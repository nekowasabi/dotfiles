# ============================================================================
# migemo-completion: ローマ字入力から日本語ファイル名を補完する ZLE ウィジェット
# https://github.com/takets/zsh-migemo-completion
#
# Tab (^i) は zeno-completion が握ったまま。zeno が候補を出せなかったときだけ
# ZENO_COMPLETION_FALLBACK 経由でこのウィジェットが呼ばれ、migemo でも候補が
# 無ければ標準の expand-or-complete へ落ちる三段構え。
#
# Why: ^i を直接奪う案ではなく ZENO_COMPLETION_FALLBACK を上書きする案を採った。
# 理由は zeno のスニペット展開・独自補完を維持したまま追加でき、zeno 側の
# 汎用フォールバック機構（zle "$ZENO_COMPLETION_FALLBACK"）にそのまま乗るため。
# なお本ファイルは zeno.zsh より後に読まれる functions.zsh から source する
# 必要がある（zeno.zsh が同変数を expand-or-complete で初期化しているため）。
# ============================================================================

# バイナリ解決: リポジトリ直下のビルド成果物 → PATH 上の migemo-complete
: ${MIGEMO_COMPLETE_BIN:=$HOME/repos/zsh-migemo-completion/migemo-complete}
if [[ ! -x $MIGEMO_COMPLETE_BIN ]]; then
  MIGEMO_COMPLETE_BIN=$(command -v migemo-complete 2>/dev/null)
fi

# バイナリが無い環境では何もしない（ウィジェット未定義のまま静かに抜ける）
if [[ -n $MIGEMO_COMPLETE_BIN && -x $MIGEMO_COMPLETE_BIN ]]; then

  function migemo-complete-widget() {
    local out ret
    # Why: stderr を一時ファイルへ分離する案ではなく 2>&1 で混ぜる案を採った。
    # CLI 契約上 exit 2（内部エラー）のときは stdout が空と保証されているため、
    # Tab 一打ごとの mktemp を避けられる。
    out=$("$MIGEMO_COMPLETE_BIN" \
      --pwd "$PWD" \
      --lbuffer "$LBUFFER" \
      --rbuffer "$RBUFFER" 2>&1)
    ret=$?

    # 内部エラー: メッセージを出しつつ標準補完へ。
    # Why: ここで return せず必ずフォールバックする。migemo 側の不具合で
    # Tab 補完そのものが死ぬのを避けるため。
    if (( ret == 2 )); then
      [[ -n $out ]] && zle -M "$out"
      zle expand-or-complete
      return 0
    fi

    # 候補ゼロ: 標準補完へ委譲
    if (( ret != 0 )); then
      zle expand-or-complete
      return 0
    fi

    # 1 行目: front / 2 行目: 共通接頭辞 / 3 行目以降: 候補
    # Why: ${(@f)} で分割する。共通接頭辞が空のとき 2 行目が空行になるが、
    # (@) を付けないと空フィールドが捨てられて行番号がずれる。
    local -a lines
    lines=("${(@f)out}")
    local front="${lines[1]}"
    local prefix="${lines[2]}"
    local -a cands
    cands=("${lines[@]:2}")

    (( ${#cands} == 0 )) && { zle expand-or-complete; return 0 }

    # 候補 1 件: そのまま確定
    if (( ${#cands} == 1 )); then
      LBUFFER="${front}${cands[1]}"
      return 0
    fi

    # 候補複数: 共通接頭辞まで詰めてから一覧を提示
    # Why: 無条件に front+prefix を代入せず「伸びるときだけ」に限定する。
    # ローマ字と漢字が同時にヒットすると共通接頭辞が空になり、無条件代入では
    # ユーザが打った文字列を消してしまうため。
    if (( ${#front} + ${#prefix} > ${#LBUFFER} )); then
      LBUFFER="${front}${prefix}"
    fi

    # Why: migemo-complete --list-width で整形させる案ではなく print -c を採った。
    # 一覧のためだけに再実行すると migemo 辞書のロードがもう一度走るため。
    zle -M "$(print -c -- "${cands[@]}")"
    return 0
  }
  zle -N migemo-complete-widget

  # zeno.zsh の既定値 (expand-or-complete) を上書きする
  export ZENO_COMPLETION_FALLBACK=migemo-complete-widget
fi
