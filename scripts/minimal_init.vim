set rtp+=.
set rtp+=../plenary.nvim/

lua << EOF
local cwd = vim.fn.getcwd()
package.path = table.concat({
  package.path,
  cwd .. '/env/share/lua/5.1/?.lua',
  cwd .. '/env/share/lua/5.1/?/init.lua'
}, ';')
EOF

runtime! plugin/plenary.vim
