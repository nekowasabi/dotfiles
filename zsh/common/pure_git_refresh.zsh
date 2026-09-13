################################################################################
# Pure prompt: periodic git fetch so pull/push arrows update while idle.
# Pure only refreshes on precmd (new prompt). Sitting at a prompt never
# fetches, so arrows stay stale until Enter.
################################################################################

# Why: Instead of TMOUT/TRAPALRM (collides with auto-logout), adopted zsh/sched.
# Reason: sched fires while ZLE is waiting and does not set a session timeout.
# Why: Instead of patching zinit's copy of pure.zsh, call prompt_pure_async_refresh.
# Reason: zinit update overwrites the plugin tree.

zmodload zsh/sched
zmodload zsh/datetime

typeset -gi PURE_GIT_FETCH_INTERVAL=${PURE_GIT_FETCH_INTERVAL:-60}
typeset -gi prompt_pure_git_refresh_last_precmd=0

function prompt_pure_git_refresh_note_precmd() {
  prompt_pure_git_refresh_last_precmd=$EPOCHSECONDS
}

function prompt_pure_git_refresh_should_run() {
  (( $+functions[prompt_pure_async_refresh] )) || return 1
  (( PURE_GIT_FETCH_INTERVAL > 0 )) || return 1
  [[ -n $prompt_pure_vcs_info[top] ]] || return 1
  # Match Pure: never git fetch inside $HOME.
  [[ $prompt_pure_vcs_info[top] != $HOME ]] || return 1
  (( ${PURE_GIT_PULL:-1} )) || return 1
  # Skip if precmd already fetched within the interval (active typing).
  (( EPOCHSECONDS - prompt_pure_git_refresh_last_precmd >= PURE_GIT_FETCH_INTERVAL )) || return 1
  return 0
}

function prompt_pure_git_periodic() {
  # Re-arm first so an early return cannot kill the loop.
  sched +${PURE_GIT_FETCH_INTERVAL} prompt_pure_git_periodic

  # No ZLE: a command is running; Pure will fetch on the next precmd.
  zle || return
  prompt_pure_git_refresh_should_run || return
  prompt_pure_async_refresh
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd prompt_pure_git_refresh_note_precmd

if (( PURE_GIT_FETCH_INTERVAL > 0 )); then
  sched +${PURE_GIT_FETCH_INTERVAL} prompt_pure_git_periodic
fi
