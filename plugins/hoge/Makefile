.PHONY: test test-docker deps

# ローカルでテスト実行（plenary.nvimが必要）
test:
	nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/plenary/"

# デバッグ用（UIありでテスト実行）
test-debug:
	nvim -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/plenary/"

# デモモード（実際の動作を視覚的に確認）
demo:
	nvim -u tests/minimal_init.lua -S demo.vim

# Luaベースのデモ
demo-lua:
	nvim -u tests/minimal_init.lua -c "luafile demo.lua"

# テスト結果をファイルに出力
test-output:
	nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/plenary/" -c "w test-results.txt" -c "qa!"

# Dockerを使ったテスト
test-docker:
	docker-compose run --rm nvim-0.10 sh -c "cd /root/.local/share/nvim/site/pack/test/start/hoge && make test"

# 依存関係のインストール（プロジェクトローカル）
deps:
	@mkdir -p .deps
	@if [ ! -d ".deps/plenary.nvim" ]; then \
		git clone --depth 1 https://github.com/nvim-lua/plenary.nvim .deps/plenary.nvim; \
	fi

# グローバルにインストール（元の方法）
deps-global:
	git clone --depth 1 https://github.com/nvim-lua/plenary.nvim ~/.local/share/nvim/site/pack/test/start/plenary.nvim || true

# CI用のテスト
test-ci:
	nvim --version
	nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/plenary/ {minimal_init = 'tests/minimal_init.lua', sequential = true}" -c "qa!"
