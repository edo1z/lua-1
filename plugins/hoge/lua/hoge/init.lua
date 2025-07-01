---@diagnostic disable-next-line: undefined-global
local vim = vim

local M = {}

-- モジュールの遅延読み込み
local config = require('hoge.config')
local window = require('hoge.ui.window')
local components = require('hoge.ui.components')
local data = require('hoge.data')
local keymaps = require('hoge.keymaps')

-- UIを開く関数
function M.open()
  -- メインウィンドウを作成
  local main_win, _ = window.create_main_window(config.get())
  -- レイアウトを作成
  local state = window.create_layout(main_win)
  -- コンテンツを描画
  M.refresh()
  -- キーマッピングを設定
  local callbacks = {
    close = function() window.close() end,
    next_tab = function()
      data.next_tab()
      M.refresh()
    end,
    prev_tab = function()
      data.prev_tab()
      M.refresh()
    end,
    move_up = function()
      data.move_up()
      M.refresh()
    end,
    move_down = function()
      data.move_down()
      M.refresh()
    end,
    select_item = function()
      vim.api.nvim_set_current_win(state.detail_win)
    end,
    show_help = function()
      components.show_help_window()
    end,
  }
  keymaps.setup(state, config.get(), callbacks)
end

-- UIを更新
function M.refresh()
  local state = window.get_state()
  if not state.main_win or not vim.api.nvim_win_is_valid(state.main_win) then
    return
  end
  -- ヘルプを描画
  components.render_help(state.help_buf)
  -- タブバーを描画
  components.render_tabs(state.tab_buf, data.tabs, data.state.active_tab)
  -- リストを描画
  local active_tab = data.get_active_tab()
  if active_tab then
    components.render_list(state.list_buf, active_tab.items, data.state.selected_index)
  end
  -- 詳細を描画
  local selected_item = data.get_selected_item()
  components.render_detail(state.detail_buf, selected_item)
end


-- セットアップ関数
function M.setup(opts)
  -- 設定を初期化
  config.setup(opts)
  -- キーマッピングを設定
  vim.api.nvim_set_keymap('n', '<leader>L', '<cmd>lua require("hoge").open()<CR>', {
    noremap = true,
    silent = true,
    desc = 'Open Hoge UI',
  })
end

return M
