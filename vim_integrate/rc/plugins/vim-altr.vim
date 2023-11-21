if g:IsWsl()
  " typescript
  call altr#define(
        \   '%.ts',
        \   '%.html')
  call altr#define(
        \   'app.module.ts',
        \   'app.routes.ts')
  call altr#define(
        \   'api.service.ts',
        \   'api.service.real.ts')

  call altr#define(
        \   'vimrc',
        \   'gvimrc')

  " vimscript
  call altr#define(
        \   'autoload/%.vim',
        \   'plugin/%.vim')


  " vimscript
  call altr#define(
        \   'autoload/%.vim',
        \   'plugin/%.vim')

  " php
  call altr#define(
        \   '/home/kf/app/php/%.inc',
        \   '/home/kf/app/tests/phpunit/%Test.php')

  call altr#define(
        \   '/home/kf/app/php/web/cmd/%.php',
        \   '/home/kf/app/tests/phpunit/cmd/%Test.php')


  call altr#define(
        \   '/home/kf/app/php/class/table/%.php',
        \   '/home/kf/app/tests/phpunit/table/%Test.php')


  call altr#define(
        \   '/home/kf/app/php/excel/%.inc',
        \   '/home/kf/app/tests/phpunit/excel/%Test.php')

  call altr#define(
        \   '/home/kf/app/web/js/annotation/photo/%.js',
        \   '/home/kf/app/tests/js/%.test.js')

  call altr#define(
        \   '/home/kf/app/php/web/cmd/%.php',
        \   '/home/kf/app/tests/php/unit/php/web/cmd/%Test.php')
endif

call altr#define(
      \   '/Users/takets/words/prayground/plot/prayground_plot_ver05.txt.shd',
      \   '/Users/takets/words/prayground/text/01_ver01.txt.shd')


nmap <silent> <Leader>j <Plug>(altr-forward)
nmap <silent> <Leader>J <Plug>(altr-back)
