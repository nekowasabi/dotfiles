################################################################################
# Pure prompt: PR number badge (right of the git branch segment)
# Shows the GitHub PR number associated with the current branch via `gh`.
# Blank when no PR exists for the branch.
################################################################################

# Why: `gh pr view` hits the GitHub API (hundreds of ms). Running it
# synchronously in precmd would stall every prompt render, so it runs on a
# dedicated zsh-async worker (separate from pure's own "prompt_pure" worker)
# and results are cached per repo+branch with a TTL.

typeset -gA prompt_pure_pr_cache          # "repo_top:branch" -> "number:timestamp"
typeset -g PURE_PR_TTL=${PURE_PR_TTL:-300}
typeset -g prompt_pure_pr_number=
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
  prompt_pure_pr_number=$output
  prompt_pure_pr_inflight_key=

  prompt_pure_reset_prompt 2>/dev/null
}

# Called from the overridden prompt_pure_preprompt_render below, so it runs
# every time pure has fresh vcs_info (not just on precmd, when the branch may
# not be resolved yet).
function prompt_pure_pr_maybe_fetch() {
  local branch=$prompt_pure_vcs_info[branch]
  if [[ -z $branch ]]; then
    prompt_pure_pr_number=
    return
  fi

  local key="${prompt_pure_vcs_info[top]}:${branch}"
  local cached=${prompt_pure_pr_cache[$key]}
  local cached_number=${cached%%:*}
  local cached_ts=${cached##*:}

  if [[ -n $cached ]] && (( EPOCHSECONDS - ${cached_ts:-0} < PURE_PR_TTL )); then
    prompt_pure_pr_number=$cached_number
    return
  fi

  [[ $prompt_pure_pr_inflight_key == $key ]] && return
  prompt_pure_pr_inflight_key=$key

  prompt_pure_pr_async_init
  async_job prompt_pure_pr prompt_pure_pr_fetch "$branch"
}

# Pure offers no extension point for custom preprompt segments, so this
# overrides the renderer (copied from sindresorhus/pure) to inject the PR
# badge right after the branch/dirty segment. Pure's own pure.zsh is left
# untouched, so `zinit` updates to the plugin keep working; only this
# override needs to be re-synced if upstream changes prompt_pure_preprompt_render.
function prompt_pure_preprompt_render() {
	setopt localoptions noshwordsplit

	unset prompt_pure_async_render_requested

	local git_color=$prompt_pure_colors[git:branch]
	local git_dirty_color=$prompt_pure_colors[git:dirty]
	[[ -n ${prompt_pure_git_last_dirty_check_timestamp+x} ]] && git_color=$prompt_pure_colors[git:branch:cached]

	local -a preprompt_parts

	if ((${(M)#jobstates:#suspended:*} != 0)); then
		preprompt_parts+='%F{$prompt_pure_colors[suspended_jobs]}${PURE_SUSPENDED_JOBS_SYMBOL:-✦}'
	fi

	[[ -n $prompt_pure_state[username] ]] && preprompt_parts+=($prompt_pure_state[username])

	preprompt_parts+=('%F{${prompt_pure_colors[path]}}%~%f')

	typeset -gA prompt_pure_vcs_info
	if [[ -n $prompt_pure_vcs_info[branch] ]]; then
		preprompt_parts+=("%F{$git_color}"'${prompt_pure_vcs_info[branch]}'"%F{$git_dirty_color}"'${prompt_pure_git_dirty}%f')
		prompt_pure_pr_maybe_fetch
		[[ -n $prompt_pure_pr_number ]] && preprompt_parts+=("%F{$git_color}"'#${prompt_pure_pr_number}%f')
	fi
	if [[ -n $prompt_pure_vcs_info[action] ]]; then
		preprompt_parts+=("%F{$prompt_pure_colors[git:action]}"'$prompt_pure_vcs_info[action]%f')
	fi
	if [[ -n $prompt_pure_git_arrows ]]; then
		preprompt_parts+=('%F{$prompt_pure_colors[git:arrow]}${prompt_pure_git_arrows}%f')
	fi
	if [[ -n $prompt_pure_git_stash ]]; then
		preprompt_parts+=('%F{$prompt_pure_colors[git:stash]}${PURE_GIT_STASH_SYMBOL:-≡}%f')
	fi

	[[ -n $prompt_pure_cmd_exec_time ]] && preprompt_parts+=('%F{$prompt_pure_colors[execution_time]}${prompt_pure_cmd_exec_time}%f')

	local cleaned_ps1=$PROMPT
	local -H MATCH MBEGIN MEND
	if [[ $PROMPT = *$prompt_newline* ]]; then
		cleaned_ps1=${PROMPT##*${prompt_newline}}
	fi
	unset MATCH MBEGIN MEND

	local -ah ps1
	ps1=(
		${(j. .)preprompt_parts}
		$prompt_newline
		$cleaned_ps1
	)

	PROMPT="${(j..)ps1}"

	local expanded_prompt
	expanded_prompt="${(S%%)PROMPT}"

	if [[ $1 == precmd ]]; then
		print
	elif [[ $prompt_pure_last_prompt != $expanded_prompt ]]; then
		prompt_pure_reset_prompt
	fi

	typeset -g prompt_pure_last_prompt=$expanded_prompt
}
