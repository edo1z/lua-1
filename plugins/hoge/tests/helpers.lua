local M = {}

-- テスト用のバッファを作成
function M.create_test_buffer(content)
  local buf = vim.api.nvim_create_buf(false, true)
  if content then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  end
  return buf
end

-- 全てのウィンドウを閉じる
function M.cleanup_windows()
  local wins = vim.api.nvim_list_wins()
  for i = 2, #wins do
    pcall(vim.api.nvim_win_close, wins[i], true)
  end
end

-- キーマッピングが存在するか確認
function M.has_keymap(mode, lhs)
  local keymaps = vim.api.nvim_get_keymap(mode)
  for _, mapping in ipairs(keymaps) do
    if mapping.lhs == lhs then
      return true
    end
  end
  return false
end

return M