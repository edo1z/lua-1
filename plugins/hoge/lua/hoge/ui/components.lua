---@diagnostic disable-next-line: undefined-global
local vim = vim

local M = {}

-- ヘルプテキストを表示
function M.render_help(buf)
  local win = vim.fn.bufwinid(buf)  -- バッファが表示されているウィンドウIDを取得
  local width = vim.api.nvim_win_get_width(win)
  local lines = {
    " [?] Help | j/k:move | <CR>:select | <Tab>:next tab | sh/sl:focus | q:quit",
    string.rep("─", width),
  }
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  -- 横スクロールを有効にする
  vim.api.nvim_win_set_option(win, 'wrap', false)
  vim.api.nvim_win_set_option(win, 'sidescrolloff', 0)
end

-- タブバーを表示
function M.render_tabs(buf, tabs, active_index)
  local tab_texts = {}
  for i, tab in ipairs(tabs) do
    local prefix = i == active_index and "▸ " or "  "
    local text = prefix .. tab.name .. "  "
    table.insert(tab_texts, text)
  end
  local line = table.concat(tab_texts, "│")
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {line})
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  -- ハイライトを適用
  local col = 0
  for i, text in ipairs(tab_texts) do
    local hl_group = i == active_index and 'HogeTabActive' or 'HogeTabInactive'
    vim.api.nvim_buf_add_highlight(buf, -1, hl_group, 0, col, col + #text)
    col = col + #text + 1
  end
end

-- リストを表示
function M.render_list(buf, items, selected_index)
  local lines = {}
  for i, item in ipairs(items) do
    local prefix = i == selected_index and "▸ " or "  "
    table.insert(lines, prefix .. item.title)
  end
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  -- 選択行をハイライト
  if selected_index > 0 and selected_index <= #items then
    vim.api.nvim_buf_add_highlight(buf, -1, 'HogeListSelected', selected_index - 1, 0, -1)
  end
end

-- 詳細を表示
function M.render_detail(buf, item)
  if not item then
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {" No item selected"})
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    return
  end
  local lines = {
    " ╔══════════════════════════════════════╗",
    " ║ " .. item.title .. string.rep(" ", 36 - #item.title) .. " ║",
    " ╚══════════════════════════════════════╝",
    "",
    " Description:",
    " ────────────",
  }
  -- 説明文を折り返して追加
  for line in item.description:gmatch("[^\n]+") do
    table.insert(lines, "  " .. line)
  end
  -- メタデータを追加
  table.insert(lines, "")
  table.insert(lines, " Metadata:")
  table.insert(lines, " ─────────")
  for key, value in pairs(item.metadata or {}) do
    table.insert(lines, string.format("  %s: %s", key, value))
  end
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
end

-- ヘルプウィンドウを表示
function M.show_help_window()
  local help_buf = vim.api.nvim_create_buf(false, true)
  
  local help_lines = {
    "╭────────────────── Hoge Help ──────────────────╮",
    "│                                               │",
    "│  Navigation:                                  │",
    "│    j/k         Move up/down in list           │",
    "│    <CR>        Select item                    │",
    "│    <Tab>       Next tab                       │",
    "│    <S-Tab>     Previous tab                   │",
    "│                                               │",
    "│  Window Focus:                                │",
    "│    <C-h> / sh  Focus list window              │",
    "│    <C-l> / sl  Focus detail window            │",
    "│                                               │",
    "│  Other:                                       │",
    "│    ?           Show/hide this help            │",
    "│    q           Quit                           │",
    "│                                               │",
    "│  Press ? or q to close this help              │",
    "╰───────────────────────────────────────────────╯",
  }
  
  vim.api.nvim_buf_set_lines(help_buf, 0, -1, false, help_lines)
  vim.api.nvim_buf_set_option(help_buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(help_buf, 'buftype', 'nofile')
  
  -- ウィンドウサイズと位置を計算
  local width = 50
  local height = #help_lines
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  local help_win = vim.api.nvim_open_win(help_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'none',
  })
  
  -- ヘルプウィンドウ内でのキーマップ
  local close_help = function()
    vim.api.nvim_win_close(help_win, true)
  end
  
  vim.api.nvim_buf_set_keymap(help_buf, 'n', '?', '', {
    noremap = true,
    silent = true,
    callback = close_help,
  })
  
  vim.api.nvim_buf_set_keymap(help_buf, 'n', 'q', '', {
    noremap = true,
    silent = true,
    callback = close_help,
  })
  
  -- 他のキーでも閉じる
  vim.api.nvim_buf_set_keymap(help_buf, 'n', '<Esc>', '', {
    noremap = true,
    silent = true,
    callback = close_help,
  })
  
  return help_win, help_buf
end

return M
