---@diagnostic disable-next-line: undefined-global
local vim = vim

local M = {}

-- キーマッピングを設定
function M.setup(state, config, callbacks)
  local keymaps = config.keymaps
  -- 各バッファにキーマッピングを設定
  local buffers = {
    state.main_buf,
    state.list_buf,
    state.detail_buf,
    state.tab_buf,
    state.help_buf,
  }
  for _, buf in ipairs(buffers) do
    if buf and vim.api.nvim_buf_is_valid(buf) then
      -- 共通のキーマッピング
      vim.api.nvim_buf_set_keymap(buf, 'n', keymaps.close, '', {
        noremap = true,
        silent = true,
        callback = callbacks.close,
      })
          vim.api.nvim_buf_set_keymap(buf, 'n', keymaps.next_tab, '', {
        noremap = true,
        silent = true,
        callback = callbacks.next_tab,
      })
          vim.api.nvim_buf_set_keymap(buf, 'n', keymaps.prev_tab, '', {
        noremap = true,
        silent = true,
        callback = callbacks.prev_tab,
      })
      vim.api.nvim_buf_set_keymap(buf, 'n', keymaps.show_help, '', {
        noremap = true,
        silent = true,
        callback = callbacks.show_help,
      })
    end
  end
  -- リストウィンドウ専用のキーマッピング
  if state.list_buf and vim.api.nvim_buf_is_valid(state.list_buf) then
    vim.api.nvim_buf_set_keymap(state.list_buf, 'n', keymaps.move_up, '', {
      noremap = true,
      silent = true,
      callback = callbacks.move_up,
    })
      vim.api.nvim_buf_set_keymap(state.list_buf, 'n', keymaps.move_down, '', {
      noremap = true,
      silent = true,
      callback = callbacks.move_down,
    })
      vim.api.nvim_buf_set_keymap(state.list_buf, 'n', keymaps.select, '', {
      noremap = true,
      silent = true,
      callback = callbacks.select_item,
    })
      vim.api.nvim_buf_set_keymap(state.list_buf, 'n', keymaps.focus_detail, '', {
      noremap = true,
      silent = true,
      callback = function()
        vim.api.nvim_set_current_win(state.detail_win)
      end,
    })
      -- sh/slでの移動も追加
      vim.api.nvim_buf_set_keymap(state.list_buf, 'n', 'sl', '', {
      noremap = true,
      silent = true,
      callback = function()
        vim.api.nvim_set_current_win(state.detail_win)
      end,
    })
  end
  -- 詳細ウィンドウ専用のキーマッピング
  if state.detail_buf and vim.api.nvim_buf_is_valid(state.detail_buf) then
    vim.api.nvim_buf_set_keymap(state.detail_buf, 'n', keymaps.focus_list, '', {
      noremap = true,
      silent = true,
      callback = function()
        vim.api.nvim_set_current_win(state.list_win)
      end,
    })
    -- sh/slでの移動も追加
    vim.api.nvim_buf_set_keymap(state.detail_buf, 'n', 'sh', '', {
      noremap = true,
      silent = true,
      callback = function()
        vim.api.nvim_set_current_win(state.list_win)
      end,
    })
  end
  -- カーソル移動の制限
  for _, buf in ipairs({state.tab_buf, state.help_buf}) do
    if buf and vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_set_option(buf, 'modifiable', false)
      vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    end
  end
end

return M