################################################################################
# Pure prompt: PR number badge (right of the git branch segment)
# Shows the GitHub PR number associated with the current branch via `gh`.
# Blank when no PR exists for the branch.
################################################################################

# Why: `gh pr view` hits the GitHub API (hundreds of ms). Running it
# synchronously in precmd would stall every prompt render, so it runs on a
# dedicated zsh-async worker (separate from pure's own "prompt_pure" worker)
# and results are cached per repo+branch with a TTL.
#
# Why: Instead of overriding prompt_pure_preprompt_render (which reconstructs
# PROMPT every precmd, causing "literal ${prompt_newline} becomes actual newline"
# and subsequent extraction failures), we inject PR badge into pure's PROMPT
# template via psvar[24] at source time. This way: (1) PROMPT is built only once,
# (2) we update psvar[24] on async fetch → pure's renderer reads it each precmd,
# (3) no string-based extraction needed, structure-safe. Survives pure version
# upgrades as long as the marker line exists.

typeset -gA prompt_pure_pr_cache          # "repo_top:branch" -> "number:timestamp"
typeset -g PURE_PR_TTL=${PURE_PR_TTL:-300}
typeset -g prompt_pure_pr_inflight_key=

function prompt_pure_pr_async_init() {
  (( ${prompt_pure_pr_async_inited:-0} )) && return
  async_start_worker prompt_pure_pr -n
  async_register_callback prompt_pure_pr prompt_pure_pr_async_callback
  typeset -g prompt_pure_pr_async_inited=1
}

function prompt_pure_pr_fetch() {
  local branch=$1
  (( ${+commands[gh]} )) || return
  gh pr view "$branch" --json number -q .number 2>/dev/null
}

function prompt_pure_pr_async_callback() {
  local job=$1 code=$2 output=$3
  [[ $job == prompt_pure_pr_fetch ]] || return

  prompt_pure_pr_cache[$prompt_pure_pr_inflight_key]="${output}:${EPOCHSECONDS}"
  psvar[24]=$output
  prompt_pure_pr_inflight_key=

  prompt_pure_reset_prompt 2>/dev/null
}

function prompt_pure_pr_maybe_fetch() {
  local branch=$prompt_pure_vcs_info[branch]
  if [[ -z $branch ]]; then
    psvar[24]=
    return
  fi

  local key="${prompt_pure_vcs_info[top]}:${branch}"
  local cached=${prompt_pure_pr_cache[$key]}
  local cached_number=${cached%%:*}
  local cached_ts=${cached##*:}

  if [[ -n $cached ]] && (( EPOCHSECONDS - ${cached_ts:-0} < PURE_PR_TTL )); then
    psvar[24]=$cached_number
    return
  fi

  [[ $prompt_pure_pr_inflight_key == $key ]] && return
  prompt_pure_pr_inflight_key=$key

  prompt_pure_pr_async_init
  async_job prompt_pure_pr prompt_pure_pr_fetch "$branch"
}

# Inject PR badge segment into PROMPT template (once at source time).
# This marker is copied verbatim from pure.zsh line 1177 (the git branch segment).
function prompt_pure_pr_badge_inject() {
  local marker='%(14V. %F{${prompt_pure_git_branch_color}}%14v%(15V.%F{$prompt_pure_colors[git:dirty]}%15v.)%f.)'
  # Badge segment: display PR number in the same color as the branch.
  local badge='%(24V.%F{${prompt_pure_git_branch_color}}#%24v%f.)'

  # If marker is found in PROMPT, inject badge right after it.
  if [[ $PROMPT == *"$marker"* ]]; then
    PROMPT=${PROMPT/$marker/$marker$badge}
  fi
}

prompt_pure_pr_badge_inject

# Register pr_maybe_fetch as a precmd hook so it runs every time before the
# prompt is displayed (when vcs_info has fresh branch info).
precmd_functions+=(prompt_pure_pr_maybe_fetch)
