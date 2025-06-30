local M = {}

---@diagnostic disable-next-line: undefined-global
local vim = vim

-- ウィンドウとバッファのIDを保存
local win_id = nil
local buf_id = nil

-- ウィンドウを開く関数
function M.open_hello_window()
  -- 既存のウィンドウが開いていたら閉じる
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
  end

  -- 新しいバッファを作成
  buf_id = vim.api.nvim_create_buf(false, true)

  -- バッファの設定
  vim.api.nvim_buf_set_option(buf_id, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf_id, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf_id, 'swapfile', false)
  -- フローティングウィンドウのサイズを計算（全画面）
  local width = vim.o.columns
  local height = vim.o.lines

  -- ウィンドウの設定
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = 0,
    col = 0,
    style = 'minimal',
    border = 'none',
  }

  -- ウィンドウを作成
  win_id = vim.api.nvim_open_win(buf_id, true, opts)

  -- 大きな文字を表示（アスキーアート風）
  local lines = {
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '     _   _      _ _       _ _ _ ',
    '    | | | | ___| | | ___ | | | |',
    '    | |_| |/ _ \\ | |/ _ \\| | | |',
    '    |  _  |  __/ | | (_) |_|_|_|',
    '    |_| |_|\\___|_|_|\\___/(_|_|_)',
    '',
    '',
    '',
    '',
    '          Press q to close',
  }

  -- 中央揃えのためのパディングを計算
  local padding = math.floor((width - 32) / 2)
  for i, line in ipairs(lines) do
    if line ~= '' then
      lines[i] = string.rep(' ', padding) .. line
    end
  end

  -- バッファに内容を設定
  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)

  -- qキーでウィンドウを閉じる
  vim.api.nvim_buf_set_keymap(buf_id, 'n', 'q', '<cmd>lua require("hoge").close_window()<CR>', {
    noremap = true,
    silent = true,
  })
end

-- ウィンドウを閉じる関数
function M.close_window()
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
    win_id = nil
    buf_id = nil
  end
end

-- セットアップ関数
function M.setup()
  -- <leader>L でウィンドウを開く
  vim.api.nvim_set_keymap('n', '<leader>L', '<cmd>lua require("hoge").open_hello_window()<CR>', {
    noremap = true,
    silent = true,
    desc = 'Open Hello window',
  })
end

return M
