---@diagnostic disable-next-line: undefined-global
local vim = vim

local M = {}

-- ウィンドウとバッファの状態
M.state = {
  main_win = nil,
  main_buf = nil,
  list_win = nil,
  list_buf = nil,
  detail_win = nil,
  detail_buf = nil,
  tab_win = nil,
  tab_buf = nil,
  help_win = nil,
  help_buf = nil,
}

-- メインウィンドウを作成
function M.create_main_window(config)
  -- 既存のウィンドウがあれば閉じる
  M.close()
  -- ウィンドウサイズを計算
  local width = math.floor(vim.o.columns * config.window.width)
  local height = math.floor(vim.o.lines * config.window.height)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  -- メインバッファを作成
  M.state.main_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(M.state.main_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(M.state.main_buf, 'bufhidden', 'wipe')
  -- メインウィンドウを作成
  M.state.main_win = vim.api.nvim_open_win(M.state.main_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'none',
  })
  return M.state.main_win, M.state.main_buf
end

-- レイアウトを作成
function M.create_layout(main_win)
  local win_config = vim.api.nvim_win_get_config(main_win)
  local width = win_config.width
  local height = win_config.height
  -- レイアウト計算
  local help_height = 2  -- 1行のテキスト + 1行の境界線
  local tab_height = 1
  local content_height = height - help_height - tab_height - 4 -- ボーダー分
  local list_width = math.floor(width * 0.35)
  local detail_width = width - list_width - 3 -- ボーダー分
  -- ヘルプウィンドウ
  M.state.help_buf = vim.api.nvim_create_buf(false, true)
  M.state.help_win = vim.api.nvim_open_win(M.state.help_buf, false, {
    relative = 'win',
    win = main_win,
    width = width,
    height = help_height,
    row = 1,
    col = 1,
    style = 'minimal',
    border = 'none',
  })
  -- タブバー
  M.state.tab_buf = vim.api.nvim_create_buf(false, true)
  M.state.tab_win = vim.api.nvim_open_win(M.state.tab_buf, false, {
    relative = 'win',
    win = main_win,
    width = width - 2,
    height = tab_height,
    row = help_height + 1,
    col = 1,
    style = 'minimal',
    border = 'none',
  })
  -- リストウィンドウ
  M.state.list_buf = vim.api.nvim_create_buf(false, true)
  M.state.list_win = vim.api.nvim_open_win(M.state.list_buf, false, {
    relative = 'win',
    win = main_win,
    width = list_width,
    height = content_height,
    row = help_height + tab_height + 3,
    col = 1,
    style = 'minimal',
    border = 'single',
  })
  -- 詳細ウィンドウ
  M.state.detail_buf = vim.api.nvim_create_buf(false, true)
  M.state.detail_win = vim.api.nvim_open_win(M.state.detail_buf, false, {
    relative = 'win',
    win = main_win,
    width = detail_width,
    height = content_height,
    row = help_height + tab_height + 3,
    col = list_width + 2,
    style = 'minimal',
    border = 'single',
  })
  -- 初期フォーカスをリストウィンドウに設定
  vim.api.nvim_set_current_win(M.state.list_win)
  return M.state
end

-- 全てのウィンドウを閉じる
function M.close()
  for _, win in pairs({M.state.help_win, M.state.tab_win, M.state.list_win, M.state.detail_win, M.state.main_win}) do
    if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
  -- 状態をリセット
  M.state = {
    main_win = nil,
    main_buf = nil,
    list_win = nil,
    list_buf = nil,
    detail_win = nil,
    detail_buf = nil,
    tab_win = nil,
    tab_buf = nil,
    help_win = nil,
    help_buf = nil,
  }
end

-- 現在の状態を取得
function M.get_state()
  return M.state
end

return M
