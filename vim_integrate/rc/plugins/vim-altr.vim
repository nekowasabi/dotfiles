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
endif

nmap <silent> <Leader>j <Plug>(altr-forward)
" nmap <silent> <Leader>J <Plug>(altr-back)
