-- Luaベースのデモスクリプト
---@diagnostic disable-next-line: undefined-global
local vim = vim

-- プラグインをセットアップ
local hoge = require('hoge')
hoge.setup()

-- デモ関数
local function run_demo()
  vim.cmd('redraw')
  print("=== Neovim Plugin Demo ===")
  print("Opening Hello window in 2 seconds...")
  vim.defer_fn(function()
    print("Opening window now...")
    hoge.open_hello_window()
    vim.cmd('redraw!')
      vim.defer_fn(function()
      print("Closing window in 3 seconds...")
          vim.defer_fn(function()
        hoge.close_window()
        vim.cmd('redraw!')
        print("Demo completed! Press <Space>q to exit.")
      end, 3000)
    end, 1000)
  end, 2000)
end

-- デモを実行
run_demo()