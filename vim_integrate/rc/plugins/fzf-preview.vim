let g:fzf_preview_use_dev_icons = 1
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --smart-case'
let g:fzf_preview_command = 'bat --color=always --style=grid {-1}'
let g:fzf_preview_lines_command = 'bat --color=always --plain --number'
let g:fzf_preview_filelist_command    = 'fd --type file --hidden --exclude .git --strip-cwd-prefix'
let g:fzf_preview_git_files_command   = 'git ls-files --exclude-standard | while read line; do if [[ ! -L $line ]] && [[ -f $line ]]; then echo $line; fi; done'

if g:IsMacNeovimInWork()
	" nnoremap <Space>pc  :<C-u>call FzFGrepForImakoko()<CR>
	" function FzFGrepForImakoko() abort
	" 	cd /Users/takets/words/prayground/
	" 	execute 'FzfPreviewProjectGrep imakoko'
	" endfunction
 " 
	" nnoremap <Space>pl  :<C-u>call FzFGrepForChangelog()<CR>
	" function FzFGrepForChangelog() abort
	" 	cd /Users/takets/Dropbox/files/changelog
	" 	let l:input = input("Project grep > ")
	" 	execute 'FzfPreviewProjectGrep '.l:input
	" endfunction
 " 
	" nnoremap <Space><Space>  :<C-u>call FromResources()<CR>
 "  function FromResources() abort
	" 	" cocの補完対象にしたくないバッファを削除
	" 	execute ":silent! bdelete! /Users/takets/Library/CloudStorage/Dropbox/files/changelog/tenTask.txt"
	" 	execute ":silent! bdelete! /Users/takets/Library/CloudStorage/Dropbox/files/changelog/changelogmemo"
 "    execute 'CocCommand fzf-preview.FromResources mru'
 "  endfunction

	" nnoremap <silent> <Leader>gf mD:<C-u>CocCommand fzf-preview.GitFiles<CR>
	" nnoremap <silent> <Leader>gs mD:<C-u>CocCommand fzf-preview.GitStatus<CR>
	" nnoremap <silent> <Leader>ga mD:<C-u>CocCommand fzf-preview.GitActions<CR>
	" nnoremap <silent> <Leader>gl mD:<C-u>CocCommand fzf-preview.GitLogs<CR>
	" nnoremap <silent> <Leader>gb mD:<C-u>CocCommand fzf-preview.GitBranches<CR>
	" nnoremap <silent> <Leader>C mD:<C-u>CocCommand fzf-preview.Changes<CR>
	" nnoremap <silent> <Leader>l mD:<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
	" nnoremap <silent> <Leader>L mD:<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
	" nnoremap <silent> <Leader>b mD:<C-u>CocCommand fzf-preview.Bookmarks<CR>
	" nnoremap <silent> <Space>Q   :<C-u>CocCommand fzf-preview.QuickFix<CR>
	" nnoremap <silent> <Space>*   :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
	" nnoremap <silent> <Space>/ :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
	" nnoremap <silent> <Space>h   :<C-u>CocCommand fzf-preview.CommandPalette<CR>
	" nnoremap <silent> <Space>y   :<C-u>CocCommand fzf-preview.Yankround<CR>
	" nnoremap <silent> <leader>cq     :<C-u>CocCommand fzf-preview.QuickFix<CR>

	" nnoremap <silent> <Space><Space>   :<C-u>FzfPreviewBuffers<CR>
	" nnoremap <silent> <Space>pk  :<C-u>FzfPreviewProjectGrep imakoko<CR>
	" nnoremap <silent> <Space>pa  :<C-u>FzfPreviewProjectGrep 
	" nnoremap <silent> <Space>pA  :<C-u>FzfPreviewProjectGrep --add-fzf-arg=--no-sort --add-fzf-arg=--query="'" 
endif



if g:IsMacGvim()
	" nnoremap <Space>pa  :<C-u>call FzFGrepForProject()<CR>
	" function FzFGrepForProject() abort
	"   cd /home/takets/source/spider/SP2-php
	"   let l:input = input("Project grep > ")
	"   execute 'FzfPreviewProjectGrep '.l:input
	" endfunction

	nnoremap <Space>pc  :<C-u>call FzFGrepForImakoko()<CR>
	function FzFGrepForImakoko() abort
		cd /Users/takets/words/prayground/
		execute 'FzfPreviewProjectGrep imakoko'
	endfunction

	nnoremap <Space>pl  :<C-u>call FzFGrepForChangelog()<CR>
	function FzFGrepForChangelog() abort
		cd /Users/takets/Dropbox/files/changelog
		let l:input = input("Project grep > ")
		execute 'FzfPreviewProjectGrep '.l:input
	endfunction

	" nnoremap <Space><Space>  :<C-u>call FromResources()<CR>
 "  function FromResources() abort
	" 	" cocの補完対象にしたくないバッファを削除
	" 	execute ":silent! bdelete! /Users/takets/Library/CloudStorage/Dropbox/files/changelog/tenTask.txt"
	" 	execute ":silent! bdelete! /Users/takets/Library/CloudStorage/Dropbox/files/changelog/changelogmemo"
 "    execute 'CocCommand fzf-preview.FromResources mru'
 "  endfunction

	" nnoremap <silent> <Leader><Leader> mD:<C-u>CocCommand fzf-preview.FromResources mru<CR>
	nnoremap <silent> <Leader>gf mD:<C-u>CocCommand fzf-preview.GitFiles<CR>
	nnoremap <silent> <Leader>gs mD:<C-u>CocCommand fzf-preview.GitStatus<CR>
	nnoremap <silent> <Leader>ga mD:<C-u>CocCommand fzf-preview.GitActions<CR>
	nnoremap <silent> <Leader>gl mD:<C-u>CocCommand fzf-preview.GitLogs<CR>
	nnoremap <silent> <Leader>gb mD:<C-u>CocCommand fzf-preview.GitBranches<CR>
	nnoremap <silent> <Leader>C mD:<C-u>CocCommand fzf-preview.Changes<CR>
	nnoremap <silent> <Leader>l mD:<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
	nnoremap <silent> <Leader>L mD:<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
	nnoremap <silent> <Leader>b mD:<C-u>CocCommand fzf-preview.Bookmarks<CR>
	nnoremap <silent> <Space>Q   :<C-u>CocCommand fzf-preview.QuickFix<CR>
	nnoremap <silent> <Space>*   :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
	nnoremap <silent> <Space>/ :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
	nnoremap <silent> <Space>h   :<C-u>CocCommand fzf-preview.CommandPalette<CR>
	nnoremap <silent> <Space>y   :<C-u>CocCommand fzf-preview.Yankround<CR>
	nnoremap <silent> <leader>cq     :<C-u>CocCommand fzf-preview.QuickFix<CR>

	" nnoremap <silent> <Space><Space>   :<C-u>FzfPreviewBuffers<CR>
	" nnoremap <silent> <Space>pk  :<C-u>FzfPreviewProjectGrep imakoko<CR>
	" nnoremap <silent> <Space>pa  :<C-u>FzfPreviewProjectGrep 
	" nnoremap <silent> <Space>pA  :<C-u>FzfPreviewProjectGrep --add-fzf-arg=--no-sort --add-fzf-arg=--query="'" 
else
	" noremap <silent> <CR><CR> :<C-u>call FzfFromResourceBufferMru()<CR>
	" function FzfFromResourceBufferMru() abort
	" 	if fnamemodify(expand('%'), ':t') == "01_ver01.txt.shd"
	" 		exe 'VoomQuitAll'
	" 	endif
 " 
	" 	execute "FzfPreviewFromResources buffer mru"
	" endfunction
endif

if g:IsLinux()
	" nnoremap <Space>pa  :<C-u>call FzFGrepForProject()<CR>
	" function FzFGrepForProject() abort
	" 	cd /home/kf/app
	" 	let l:input = input("Project grep > ")
	" 	execute 'FzfPreviewProjectGrep '.l:input
	" endfunction
 " 
	" nnoremap <Space>pw :<C-u>call FzFGrepCwordForProject()<CR>
	" function FzFGrepCwordForProject() abort
	" 	cd /home/kf/app
	" 	let search_word = expand("<cword>")
	" 	execute 'FzfPreviewProjectGrep '.search_word
	" endfunction
 " 
	" nnoremap <silent> <Space><Space>   :<C-u>FzfPreviewBuffers<CR>
	" nnoremap <silent> <CR><CR> mD:<C-u>FzfPreviewFromResources mru buffer<CR>
	" nnoremap <silent> <Leader>gf mD:<C-u>FzfPreviewGitFiles<CR>
	" nnoremap <silent> <Leader>gs mD:<C-u>FzfPreviewGitStatus<CR>
	" nnoremap <silent> <Leader>ga mD:<C-u>FzfPreviewGitActions<CR>
	" nnoremap <silent> <Leader>gl mD:<C-u>FzfPreviewGitLogs<CR>
	" nnoremap <silent> <Leader>gb mD:<C-u>FzfPreviewGitBranches<CR>
	" nnoremap <silent> <Leader>C mD:<C-u>FzfPreviewChanges<CR>
	" nnoremap <silent> <Leader>l mD:<C-u>FzfPreviewLines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
	" nnoremap <silent> <Leader>L mD:<C-u>FzfPreviewLines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
	" nnoremap <silent> <Leader>b mD:<C-u>FzfPreviewBookmarks<CR>
	" nnoremap <silent> <Space>pk  :<C-u>FzfPreviewProjectGrep imakoko<CR>
	" nnoremap <silent> <Space>pa  :<C-u>FzfPreviewProjectGrep 
	" nnoremap <silent> <Space>pA  :<C-u>FzfPreviewProjectGrep --add-fzf-arg=--no-sort --add-fzf-arg=--query="'" 
	" nnoremap <silent> <Space>Q   :<C-u>FzfPreviewQuickFix<CR>
	" nnoremap <silent> <Space>*   :<C-u>FzfPreviewLines --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
	" nnoremap <silent> <Space>/ :<C-u>FzfPreviewLines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
	" nnoremap <silent> <Space>h   :<C-u>FzfPreviewCommandPalette<CR>
	" nnoremap <silent> <Space>y   :<C-u>FzfPreviewYankround<CR>
	" nnoremap <silent> <leader>cq     :<C-u>FzfPreviewQuickFix<CR>
endif

augroup fzf_preview
	autocmd!
	autocmd User fzf_preview#rpc#initialized call s:fzf_preview_settings() " fzf_preview#remote#initialized or fzf_preview#coc#initialized
augroup END

function! s:fzf_preview_settings() abort
	let g:fzf_preview_command = 'COLORTERM=truecolor ' . g:fzf_preview_command
	let g:fzf_preview_grep_preview_cmd = 'COLORTERM=truecolor ' . g:fzf_preview_grep_preview_cmd
endfunction
