" プラグインのデモスクリプト
" 実行: nvim -u tests/minimal_init.lua -S demo.vim

" 画面をクリアして準備
redraw
echo "=== Neovim Plugin Demo ==="
echo "Starting demo in 2 seconds..."
redraw

" 2秒待つ（ミリ秒単位）
exe "sleep 2"

" プラグインをセットアップ
lua require('hoge').setup()

" デモ開始
redraw
echo "Opening Hello window..."
redraw

" ウィンドウを開く
lua require('hoge').open_hello_window()

" 画面を更新
redraw!

" 3秒待つ
echo "Window is now open. Waiting 3 seconds..."
exe "sleep 3"

" ウィンドウを閉じる
redraw
echo "Closing window..."
lua require('hoge').close_window()
redraw!

echo "Demo completed! Press any key to exit."
call getchar()
qa!