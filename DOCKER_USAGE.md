# Neovimプラグイン開発環境

Docker Composeを使用してNeovimの複数バージョンでプラグインをテストできる環境です。

## セットアップ

1. Dockerイメージをビルド:
```bash
docker-compose build
```

## 使い方

### Neovim 0.10でテスト
```bash
docker-compose run --rm nvim-0.10
```

### Neovim 0.11（Nightly）でテスト
```bash
docker-compose run --rm nvim-0.11
```

### Neovim安定版でテスト
```bash
docker-compose run --rm nvim-stable
```

## プラグインのテスト

1. コンテナ内でNeovimが起動します
2. プラグインは自動的に読み込まれます（`plugins/`ディレクトリがマウントされています）
3. `<Space>L`（スペース + L）でHelloウィンドウを表示
4. `q`でウィンドウを閉じる
5. `<Space>q`でNeovimを終了

## ディレクトリ構造

```
.
├── docker-compose.yml      # Docker Compose設定
├── Dockerfile.nvim         # Neovim用Dockerイメージ
├── plugins/               # プラグインディレクトリ（自動的にロードされる）
│   └── hoge/
│       └── init.lua
└── test-config/           # テスト用のNeovim設定
    └── init.lua
```

## 開発フロー

1. `plugins/hoge/init.lua`を編集
2. Dockerコンテナでテスト
3. 異なるバージョンで動作確認

## ヒント

- コンテナ内で`:checkhealth`を実行して環境を確認できます
- `:lua print(vim.version())`でNeovimのバージョンを確認できます
- `<Space>r`で現在のLuaファイルをリロードできます