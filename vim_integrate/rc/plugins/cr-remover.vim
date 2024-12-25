lua << EOF
require('cr-remover').setup{{
  exclude_patterns = { "%.git/" },
  -- auto_remove_on_save = true,
  auto_remove_on_paste = true,
  debug = false
}}
EOF
