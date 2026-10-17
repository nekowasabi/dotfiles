# Directory bookmarks for zsh.
# Source from .zshrc: source /path/to/bookmark.zsh
# Storage is one absolute path per line in ~/.zsh_bookmarks,
# or in the file named by ZSH_BOOKMARKS_FILE.

if [[ -z ${ZSH_VERSION:-} ]]; then
  echo "bookmark.zsh: source this file from zsh" >&2
  return 1 2>/dev/null || exit 1
fi

typeset -g _zb_restore_aliases=0
if [[ -o aliases ]]; then
  _zb_restore_aliases=1
  unsetopt aliases
fi

if (( ${+aliases[b]} )); then
  unalias b
fi
if (( ${+aliases[bm]} )); then
  unalias bm
fi
if (( ${+aliases[bd]} )); then
  unalias bd
fi

_zb_bookmark_file() {
  emulate -L zsh
  if [[ -n ${ZSH_BOOKMARKS_FILE:-} ]]; then
    print -r -- "$ZSH_BOOKMARKS_FILE"
    return 0
  fi
  if [[ -z ${HOME:-} ]]; then
    print -u2 -- "bookmark: HOME is not set and ZSH_BOOKMARKS_FILE is empty"
    return 1
  fi
  print -r -- "${HOME}/.zsh_bookmarks"
}

_zb_ensure_file() {
  emulate -L zsh
  local file dir
  file="$(_zb_bookmark_file)" || return 1
  dir="${file:h}"
  if [[ ! -d $dir ]]; then
    command mkdir -p -- "$dir" || {
      print -u2 -- "bookmark: cannot create directory: ${dir}"
      return 1
    }
  fi
  if [[ ! -e $file ]]; then
    : > "$file" || {
      print -u2 -- "bookmark: cannot create file: ${file}"
      return 1
    }
  elif [[ ! -f $file ]]; then
    print -u2 -- "bookmark: not a regular file: ${file}"
    return 1
  fi
  return 0
}

_zb_marks_text() {
  emulate -L zsh
  local file line
  local -a lines
  file="$(_zb_bookmark_file)" || return 1
  [[ -f $file ]] || return 0
  lines=("${(f)"$(<"$file")"}") || {
    print -u2 -- "bookmark: cannot read: ${file}"
    return 1
  }
  for line in "${lines[@]}"; do
    [[ -n $line ]] && print -r -- "$line"
  done
  return 0
}

_zb_write_marks() {
  emulate -L zsh
  local file dir tmp
  file="$(_zb_bookmark_file)" || return 1
  dir="${file:h}"
  if [[ ! -d $dir ]]; then
    command mkdir -p -- "$dir" || {
      print -u2 -- "bookmark: cannot create directory: ${dir}"
      return 1
    }
  fi
  tmp="$(command mktemp "${dir}/.zsh_bookmarks.XXXXXX")" || {
    print -u2 -- "bookmark: cannot create a temporary file in: ${dir}"
    return 1
  }
  if (( $# > 0 )); then
    builtin printf '%s\n' "$@" > "$tmp" || {
      command rm -f -- "$tmp"
      print -u2 -- "bookmark: cannot write a temporary file: ${tmp}"
      return 1
    }
  else
    : > "$tmp" || {
      command rm -f -- "$tmp"
      print -u2 -- "bookmark: cannot write a temporary file: ${tmp}"
      return 1
    }
  fi
  command mv -- "$tmp" "$file" || {
    command rm -f -- "$tmp"
    print -u2 -- "bookmark: cannot replace bookmark file: ${file}"
    return 1
  }
  return 0
}

_zb_filter() {
  emulate -L zsh
  local keyword="$1"
  local mark
  shift
  for mark in "$@"; do
    if [[ $mark == *"$keyword"* ]]; then
      print -r -- "$mark"
    fi
  done
  return 0
}

_zb_fzf_path() {
  emulate -L zsh
  local dir candidate
  local -a dirs
  dirs=("${(s.:.)PATH}")
  for dir in "${dirs[@]}"; do
    [[ -n $dir ]] || dir="."
    candidate="${dir}/fzf"
    if [[ -x $candidate && ! -d $candidate ]]; then
      print -r -- "$candidate"
      return 0
    fi
  done
  return 1
}

_zb_pick_with_fzf() {
  emulate -L zsh
  setopt pipefail
  local cmdname="$1"
  local query="$2"
  local fzf_bin result rc
  local -a fzf_args
  shift 2
  fzf_bin="$(_zb_fzf_path)" || {
    print -u2 -- "${cmdname}: fzf was not found in PATH"
    return 1
  }
  fzf_args=()
  if [[ -n $query ]]; then
    fzf_args=(--query "$query")
  fi
  if (( $# == 0 )); then
    result="$("$fzf_bin" "${fzf_args[@]}" </dev/null)"
  else
    result="$(builtin printf '%s\n' "$@" | "$fzf_bin" "${fzf_args[@]}")"
  fi
  rc=$?
  if (( rc != 0 )); then
    return $rc
  fi
  if [[ -z $result ]]; then
    print -u2 -- "${cmdname}: empty selection from fzf"
    return 1
  fi
  print -r -- "$result"
}

# Print the bookmark chosen by the b/bd rules.
# $1 is the command name used in error text. $2 is the keyword, or empty.
_zb_resolve() {
  emulate -L zsh
  local cmdname="$1"
  local keyword="$2"
  local text
  local -a marks matches
  _zb_ensure_file || return 1
  text="$(_zb_marks_text)" || return 1
  if [[ -n $text ]]; then
    marks=("${(f)text}")
  fi
  if [[ -z $keyword ]]; then
    _zb_pick_with_fzf "$cmdname" "" "${marks[@]}"
    return $?
  fi
  if (( ${#marks} > 0 )); then
    text="$(_zb_filter "$keyword" "${marks[@]}")" || return 1
    if [[ -n $text ]]; then
      matches=("${(f)text}")
    fi
  fi
  if (( ${#matches} == 0 )); then
    print -u2 -- "${cmdname}: no bookmark matches: ${keyword}"
    return 1
  fi
  if (( ${#matches} == 1 )); then
    print -r -- "${matches[1]}"
    return 0
  fi
  _zb_pick_with_fzf "$cmdname" "$keyword" "${matches[@]}"
  return $?
}

b() {
  local target rc
  # Selection runs in a subshell so its option changes stay there.
  # cd runs here, so the caller's cd options and cd function still apply.
  if target="$(
    emulate -L zsh
    _zb_resolve b "$*"
  )"; then
    if [[ -z $target ]]; then
      print -u2 -- "b: empty bookmark selection"
      return 1
    fi
    # Hand-edited lines may start with ~; quoted cd does not expand it.
    if [[ $target == '~' || $target == '~/'* ]]; then
      target="${HOME}${target#\~}"
    fi
    cd -- "$target" || return $?
  else
    rc=$?
    return $rc
  fi
}

bm() {
  emulate -L zsh
  local text line
  local -a marks
  _zb_ensure_file || return 1
  text="$(_zb_marks_text)" || return 1
  if [[ -n $text ]]; then
    marks=("${(f)text}")
  fi
  for line in "${marks[@]}"; do
    if [[ $line == "$PWD" ]]; then
      print -r -- "bm: already bookmarked: ${PWD}"
      return 0
    fi
  done
  marks+=("$PWD")
  _zb_write_marks "${marks[@]}"
}

bd() {
  emulate -L zsh
  local keyword="$*"
  local target rc text line
  local found=0
  local -a marks kept
  if target="$(_zb_resolve bd "$keyword")"; then
    if [[ -z $target ]]; then
      print -u2 -- "bd: empty bookmark selection"
      return 1
    fi
  else
    rc=$?
    return $rc
  fi
  text="$(_zb_marks_text)" || return 1
  if [[ -n $text ]]; then
    marks=("${(f)text}")
  fi
  for line in "${marks[@]}"; do
    if [[ $line == "$target" ]]; then
      found=1
    else
      kept+=("$line")
    fi
  done
  if (( ! found )); then
    print -u2 -- "bd: selected bookmark is not stored: ${target}"
    return 1
  fi
  _zb_write_marks "${kept[@]}"
}

_zb_complete() {
  local file line needle
  local -a lines candidates matches
  if [[ -n ${ZSH_BOOKMARKS_FILE:-} ]]; then
    file="$ZSH_BOOKMARKS_FILE"
  elif [[ -n ${HOME:-} ]]; then
    file="${HOME}/.zsh_bookmarks"
  else
    return 0
  fi
  [[ -f $file ]] || return 0
  lines=("${(f)"$(<"$file")"}") 2>/dev/null || return 0
  for line in "${lines[@]}"; do
    [[ -n $line ]] && candidates+=("$line")
  done
  (( ${#candidates} )) || return 0
  # PREFIX/SUFFIX keep backslash quoting (j\ a). Quoted words are already
  # bare (j a). Unquote before the literal substring test.
  local pre="${PREFIX-}" suf="${SUFFIX-}"
  needle="${(Q)pre}${(Q)suf}"
  if [[ -z $needle ]]; then
    compadd -- "${candidates[@]}"
    return
  fi
  for line in "${candidates[@]}"; do
    [[ $line == *"$needle"* ]] && matches+=("$line")
  done
  (( ${#matches} )) || return 0
  # -U keeps matches that are not prefixes of the typed word.
  # The matcher lets that word sit in the middle of the path, so zsh
  # replaces it with the path and quotes characters such as spaces.
  compadd -U -M 'l:|=* r:|=*' -- "${matches[@]}"
}

_b() {
  _zb_complete
}

_bd() {
  _zb_complete
}

_zb_register_comps() {
  emulate -L zsh
  (( ${+functions[compdef]} )) || return 0
  compdef _b b || return 1
  compdef _bd bd || return 1
  local fn
  local -a kept
  for fn in "${precmd_functions[@]}"; do
    [[ $fn == _zb_register_comps ]] && continue
    kept+=("$fn")
  done
  precmd_functions=("${kept[@]}")
  return 0
}

if (( _zb_restore_aliases )); then
  setopt aliases
fi
unset _zb_restore_aliases

if (( ${+functions[compdef]} )); then
  _zb_register_comps
else
  typeset -ga precmd_functions
  if (( ${precmd_functions[(I)_zb_register_comps]} == 0 )); then
    precmd_functions+=(_zb_register_comps)
  fi
fi
