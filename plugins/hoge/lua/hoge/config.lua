---@diagnostic disable-next-line: undefined-global
local vim = vim

local M = {}

-- デフォルト設定
M.defaults = {
  -- ウィンドウサイズ
  window = {
    width = 0.9,  -- 画面の90%
    height = 0.9, -- 画面の90%
  },
  -- キーマッピング
  keymaps = {
    close = 'q',
    next_tab = '<Tab>',
    prev_tab = '<S-Tab>',
    select = '<CR>',
    move_up = 'k',
    move_down = 'j',
    focus_list = '<C-h>',
    focus_detail = '<C-l>',
  },
  -- カラー設定
  highlights = {
    TabActive = { fg = '#ffffff', bg = '#1e88e5', bold = true },
    TabInactive = { fg = '#888888', bg = '#333333' },
    ListSelected = { bg = '#3e3e3e' },
    Border = { fg = '#666666' },
  }
}

-- 現在の設定
M.options = {}

-- セットアップ関数
function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.defaults, opts or {})
  -- ハイライトグループの設定
  for name, colors in pairs(M.options.highlights) do
    local cmd = 'highlight Hoge' .. name
    if colors.fg then cmd = cmd .. ' guifg=' .. colors.fg end
    if colors.bg then cmd = cmd .. ' guibg=' .. colors.bg end
    if colors.bold then cmd = cmd .. ' gui=bold' end
    vim.cmd(cmd)
  end
end

-- 設定を取得
function M.get()
  return M.options
end

return M