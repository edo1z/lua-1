-- テスト用の最小限のNeovim設定
vim.opt.rtp:append('.')

-- プロジェクトローカルの依存関係を優先的に読み込む
local deps_path = vim.fn.getcwd() .. '/.deps'
if vim.fn.isdirectory(deps_path) == 1 then
  vim.opt.rtp:prepend(deps_path .. '/plenary.nvim')
end

-- プラグインをロード
vim.cmd('runtime plugin/plenary.vim')
require('plenary.busted')