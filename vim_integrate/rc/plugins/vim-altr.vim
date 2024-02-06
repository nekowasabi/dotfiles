" if g:IsWsl()
"   " typescript
"   call altr#define(
"        \   '%.ts',
"        \   '%.html')
"   call altr#define(
"        \   'app.module.ts',
"        \   'app.routes.ts')
"   call altr#define(
"        \   'api.service.ts',
"        \   'api.service.real.ts')
" 
"   call altr#define(
"        \   'vimrc',
"        \   'gvimrc')
" 
"   " vimscript
"   call altr#define(
"        \   'autoload/%.vim',
"        \   'plugin/%.vim')
" 
" 
"   " vimscript
"   call altr#define(
"        \   'autoload/%.vim',
"        \   'plugin/%.vim')
" 
"   " php
"   call altr#define(
"        \   '/home/kf/app/php/%.inc',
"        \   '/home/kf/app/tests/phpunit/%Test.php')
" 
"   call altr#define(
"        \   '/home/kf/app/php/web/cmd/%.php',
"        \   '/home/kf/app/tests/phpunit/cmd/%Test.php')
" 
" 
"   call altr#define(
"        \   '/home/kf/app/php/class/table/%.php',
"        \   '/home/kf/app/tests/phpunit/table/%Test.php')
" 
" 
"   call altr#define(
"        \   '/home/kf/app/php/excel/%.inc',
"        \   '/home/kf/app/tests/phpunit/excel/%Test.php')
" 
"   call altr#define(
"        \   '/home/kf/app/web/js/annotation/photo/%.js',
"        \   '/home/kf/app/tests/js/%.test.js')
" 
"   call altr#define(
"        \   '/home/kf/app/php/web/cmd/%.php',
"        \   '/home/kf/app/tests/php/unit/php/web/cmd/%Test.php')
" endif

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
