if g:IsMacNeovimInMfs()
	" PHP
  " test - controller
	call altr#define(
				\   '/Users/ttakeda/works/invase-backend/laravel/tests/Feature/%Test.php',
				\   '/Users/ttakeda/works/invase-backend/laravel/app/Http/Controllers/%.php')
  " test - components
	call altr#define(
				\   '/Users/ttakeda/works/invase-backend/laravel/tests/Unit/Components/%Test.php',
				\   '/Users/ttakeda/works/invase-backend/laravel/app/Packages/Components/Calculator/PricingSimulator/%.php')
else
endif

" M3 Macbook
if g:IsMacNeovimInWezterm() && g:IsMacNeovimInMfs() == v:false
	call altr#define(
				\   '/Users/takets/repos/7clock/establish.md',
				\   '/Users/takets/repos/7clock/new_memo.md')
endif

nmap <silent> <Leader>j <Plug>(altr-forward)
" nmap <silent> <Leader>J <Plug>(altr-back)
