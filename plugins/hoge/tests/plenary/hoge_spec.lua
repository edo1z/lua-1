---@diagnostic disable-next-line: undefined-global
local vim = vim

local hoge = require('hoge')

describe('hoge plugin', function()
  -- 各テストの前に実行
  before_each(function()
    -- ウィンドウやバッファの状態をリセット
    vim.cmd('bufdo bwipeout!')
  end)

  describe('setup()', function()
    it('should create keymapping', function()
      hoge.setup()

      -- キーマッピングが設定されているか確認
      local keymaps = vim.api.nvim_get_keymap('n')
      local found = false

      for _, mapping in ipairs(keymaps) do
        if mapping.lhs == ' L' then  -- <leader>L
          found = true
          break
        end
      end

      assert.is_true(found, 'Keymap <leader>L not found')
    end)
  end)

  describe('open_hello_window()', function()
    it('should create a floating window', function()
      local initial_win_count = #vim.api.nvim_list_wins()

      hoge.open_hello_window()

      local after_win_count = #vim.api.nvim_list_wins()
      assert.equals(initial_win_count + 1, after_win_count)
    end)

    it('should create a buffer with correct content', function()
      hoge.open_hello_window()

      local wins = vim.api.nvim_list_wins()
      local win = wins[#wins]  -- 最後に作成されたウィンドウ
      local buf = vim.api.nvim_win_get_buf(win)
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      -- "Hello!!!"のアスキーアートが含まれているか確認
      local found_hello = false
      for _, line in ipairs(lines) do
        if line:match('_   _      _ _       _ _ _') then
          found_hello = true
          break
        end
      end

      assert.is_true(found_hello, 'Hello ASCII art not found in buffer')
    end)

    it('should close existing window when called twice', function()
      hoge.open_hello_window()
      local first_win_count = #vim.api.nvim_list_wins()

      hoge.open_hello_window()
      local second_win_count = #vim.api.nvim_list_wins()

      assert.equals(first_win_count, second_win_count)
    end)
  end)

  describe('close_window()', function()
    it('should close the window', function()
      hoge.open_hello_window()
      local with_window = #vim.api.nvim_list_wins()

      hoge.close_window()
      local after_close = #vim.api.nvim_list_wins()

      assert.equals(with_window - 1, after_close)
    end)

    it('should handle closing when no window exists', function()
      local initial_count = #vim.api.nvim_list_wins()

      -- エラーが発生しないことを確認
      assert.has_no.errors(function()
        hoge.close_window()
      end)

      assert.equals(initial_count, #vim.api.nvim_list_wins())
    end)
  end)

  describe('keymap integration', function()
    it('should close window with q key', function()
      local initial_win_count = #vim.api.nvim_list_wins()
      hoge.open_hello_window()

      -- 開いたウィンドウが存在することを確認
      assert.equals(initial_win_count + 1, #vim.api.nvim_list_wins())

      -- 現在のウィンドウでqキーを押す（より確実な方法）
      vim.cmd('normal q')

      -- ウィンドウが閉じられたか確認
      local wins = vim.api.nvim_list_wins()
      assert.equals(initial_win_count, #wins)  -- 元のウィンドウ数に戻る
    end)
  end)
end)
