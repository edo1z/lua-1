---@diagnostic disable-next-line: undefined-global
local vim = vim

local hoge = require('hoge')

describe('hoge plugin', function()
  -- 各テストの前に実行
  before_each(function()
    -- ウィンドウやバッファの状態をリセット
    vim.cmd('bufdo bwipeout!')
    -- 状態をリセット
    local data = require('hoge.data')
    data.state = { active_tab = 1, selected_index = 1 }
  end)

  after_each(function()
    -- ウィンドウを閉じる
    require('hoge.ui.window').close()
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

  describe('UI components', function()
    it('should create main window with multiple panes', function()
      local initial_win_count = #vim.api.nvim_list_wins()
      hoge.open()

      -- 5つのウィンドウが作成される（main, help, tab, list, detail）
      local after_win_count = #vim.api.nvim_list_wins()
      assert.equals(initial_win_count + 5, after_win_count)
    end)

    it('should have correct initial state', function()
      hoge.open()
      local window = require('hoge.ui.window')
      local state = window.get_state()

      assert.is_not_nil(state.main_win)
      assert.is_not_nil(state.help_win)
      assert.is_not_nil(state.tab_win)
      assert.is_not_nil(state.list_win)
      assert.is_not_nil(state.detail_win)
    end)

    it('should display tabs correctly', function()
      hoge.open()
      local window = require('hoge.ui.window')
      local state = window.get_state()

      local lines = vim.api.nvim_buf_get_lines(state.tab_buf, 0, -1, false)
      assert.equals(1, #lines)
      assert.is_true(lines[1]:match("Languages") ~= nil)
      assert.is_true(lines[1]:match("Frameworks") ~= nil)
    end)

    it('should display list items', function()
      hoge.open()
      local window = require('hoge.ui.window')
      local state = window.get_state()

      local lines = vim.api.nvim_buf_get_lines(state.list_buf, 0, -1, false)
      assert.is_true(#lines > 0)
      assert.is_true(lines[1]:match("▸ Lua") ~= nil) -- 最初のアイテムが選択されている
    end)
  end)

  describe('navigation', function()
    it('should move selection down with j', function()
      hoge.open()
      local data = require('hoge.data')
      local window = require('hoge.ui.window')
      local state = window.get_state()

      -- リストウィンドウにフォーカス
      vim.api.nvim_set_current_win(state.list_win)

      -- j キーで下に移動
      data.move_down()
      hoge.refresh()

      assert.equals(2, data.state.selected_index)
    end)

    it('should switch tabs', function()
      hoge.open()
      local data = require('hoge.data')

      -- Tab キーで次のタブに移動
      data.next_tab()
      assert.equals(2, data.state.active_tab)

      -- Shift-Tab で前のタブに戻る
      data.prev_tab()
      assert.equals(1, data.state.active_tab)
    end)
  end)

  describe('close functionality', function()
    it('should close all windows', function()
      local initial_win_count = #vim.api.nvim_list_wins()
      hoge.open()

      local window = require('hoge.ui.window')
      window.close()

      assert.equals(initial_win_count, #vim.api.nvim_list_wins())
    end)
  end)
end)
