-- Luaベースのデモスクリプト
---@diagnostic disable-next-line: undefined-global
local vim = vim

-- プラグインをセットアップ
local hoge = require('hoge')
hoge.setup()

-- デモ関数
local function run_demo()
  vim.cmd('redraw')
  print("=== Neovim Plugin UI Demo ===")
  print("Opening advanced UI in 2 seconds...")

  vim.defer_fn(function()
    print("Opening UI now...")
    hoge.open()
    vim.cmd('redraw!')

    print("")
    print("=== Demo Guide ===")
    print("1. Navigation: Use j/k to move in the list")
    print("2. Tab switching: Press Tab to switch between Languages/Frameworks")
    print("3. Window focus: Use Ctrl-h/Ctrl-l to switch between list and detail")
    print("4. Selection: Press Enter to focus on detail view")
    print("5. Exit: Press q to close the UI")
    print("")

    -- デモンストレーション：自動でいくつかの操作を行う
    vim.defer_fn(function()
      print("Demo: Moving down in the list...")
      local data = require('hoge.data')
      data.move_down()
      hoge.refresh()

      vim.defer_fn(function()
        print("Demo: Switching to Frameworks tab...")
        data.next_tab()
        hoge.refresh()

        vim.defer_fn(function()
          print("Demo: Now try it yourself! Press q when done.")
        end, 2000)
      end, 2000)
    end, 3000)
  end, 2000)
end

-- デモを実行
run_demo()