" プラグインのデモスクリプト（Vimスクリプト版）
" 実行: nvim -u tests/minimal_init.lua -S demo.vim

" 画面をクリアして準備
redraw
echo "=== Neovim Plugin UI Demo (Vim Script) ==="
echo "Starting demo in 2 seconds..."
redraw

" 2秒待つ
exe "sleep 2"

" プラグインをセットアップ
lua require('hoge').setup()

" デモ開始
redraw
echo "Opening advanced UI..."
redraw

" UIを開く
lua require('hoge').open()

" 画面を更新
redraw!

" ガイドを表示
echo ""
echo "=== Interactive Demo ==="
echo "Try these commands:"
echo "  j/k     - Move up/down in the list"
echo "  Tab     - Switch between tabs"
echo "  Ctrl-l  - Focus detail pane"
echo "  Ctrl-h  - Focus list pane"
echo "  Enter   - Select item"
echo "  q       - Close UI"
echo ""
echo "The UI is now open. Explore the features!"
echo ""

" ユーザーの入力を待つ（UIが閉じられるまで）
" Vimスクリプトでは自動的な操作のデモは難しいので、
" ユーザーに手動で試してもらう
echo "When you're done exploring, the demo will end automatically."