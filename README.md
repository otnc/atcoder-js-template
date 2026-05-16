# AtCoder Node.js Helper

AtCoder の問題を JavaScript (Node.js) で解くためのヘルパーツールです。

## 環境 / 事前準備

- Windows / MacOS / Linux
  - Node.js v22.19.0 以上が利用可能な環境
- [AtCoder](https://atcoder.jp/) への登録をする。
- [nvm-sh/nvm](https://github.com/nvm-sh/nvm) もしくは [corebutler/nvm-windows](https://github.com/coreybutler/nvm-windows) をインストール後、どのバージョンでもいいので Node.js および npm を使用できるようにする。

## セットアップ

```bash
npm -g install pnpm@11 # pnpm がインストールされていない場合
pnpm nvm       # .nvmrc のバージョンに切り替え（未インストールなら自動インストール）
npm -g install pnpm@11 # 切り替え後に pnpm がインストールされていない場合
pnpm install
```

> Unix/macOS の場合は `bash scripts/nvm.sh` を使用してください。

## ディレクトリ構成

```
q/
  YYYYMMDD/           # コンテスト日付ごとのディレクトリ（JST）
    mock/             # モック入力・期待出力ファイル
      a/
        1.txt          # モック入力
        1._result.txt  # 期待出力
        2.txt
        2._result.txt
        ...
      b/
        1.txt
        ...
    a.js
    b.js
    ...
scripts/
  start.coffee         # ファイル生成スクリプト
  test.coffee          # 実行スクリプト
  mock.coffee          # モック入力保存
  mock-delete.coffee   # モック入力削除
  result.coffee        # 期待出力保存
  result-delete.coffee # 期待出力削除
  format.coffee        # Prettier フォーマット
  nvm.coffee           # Node バージョン切り替え（OS 判定ディスパッチャー）
  nvm.ps1              # Windows 用
  nvm.sh               # Unix/macOS 用
  nvm-restore.coffee   # バージョン復元（OS 判定ディスパッチャー）
  nvm-restore.ps1      # Windows 用
  nvm-restore.sh       # Unix/macOS 用
template.js            # 問題ファイルのテンプレート
.nvmrc                 # 使用する Node.js バージョン
```

## 使い方

### Node.js バージョンの切り替え

```bash
pnpm nvm          # 現在のバージョンを .nvm-prev に保存し、.nvmrc のバージョンへ切り替え
pnpm nvm:restore  # .nvm-prev のバージョンに戻す
```

### 問題ファイルを作成する

```bash
pnpm start <問題番号>
```

今日の日付（JST）のディレクトリ `q/YYYYMMDD/` に `<問題番号>.js` を `template.js` をもとに生成します。

```bash
pnpm start a
# => Created: D:\...\q\20260516\a.js
```

ファイルが既に存在する場合は上書きせずスキップします。

### 問題を実行する

```bash
pnpm test <問題番号> [日付]
```

指定した問題ファイルを実行します。日付を省略すると、今日（JST）のディレクトリを優先し、なければ最新のものを使用します。

モックファイルが存在する場合は stdin の代わりに番号順で自動実行します。対応する期待出力ファイル（`<番号>._result.txt`）が存在すれば、実行後に自動比較して結果を表示します。

```bash
pnpm test a
# Running: D:\...\q\20260516\a.js
# (Input: ^Z + Enter to execute)   ← モックなしの場合

# モックあり・期待出力なしの場合
# Running: D:\...\q\20260516\a.js
# Mocks: 2 file(s)
# --- Mock 1: ...\mock\a\1.txt ---
# 8
#
# --- Mock 2: ...\mock\a\2.txt ---
# 15

# モックあり・期待出力ありの場合
# --- Mock 1: ...\mock\a\1.txt ---
# 8
# Correct
#
# --- Mock 2: ...\mock\a\2.txt ---
# 9
# Incorrect
#   Expected: 15
#   Actual:   9
```

```bash
# パイプで入力する場合
echo "3 5" | pnpm test a

# 日付を指定する場合
pnpm test a 20260418
```

### モック入力の管理

```bash
pnpm mock <問題番号> <番号> [日付]        # stdin を保存（上書き可）
pnpm mock:delete <問題番号> <番号> [日付] # 削除
```

```bash
pnpm mock a 1        # 入力して ^Z + Enter で q/YYYYMMDD/mock/a/1.txt に保存
pnpm mock a 2        # 2つ目のモック
pnpm mock:delete a 1 # 削除
```

### 期待出力の管理

```bash
pnpm result <問題番号> <番号> [日付]        # stdin を保存（上書き可）
pnpm result:delete <問題番号> <番号> [日付] # 削除
```

期待出力を `q/YYYYMMDD/mock/<問題番号>/<番号>._result.txt` に保存します。
`pnpm test` 実行時に対応するモック番号の結果と自動比較されます。

```bash
pnpm result a 1        # 入力して ^Z + Enter で q/YYYYMMDD/mock/a/1._result.txt に保存
pnpm result:delete a 1 # 削除
```

### フォーマット

```bash
pnpm format <問題番号> [日付]  # 指定問題ファイルを Prettier でフォーマット
pnpm format                    # プロジェクト全体をフォーマット（prettier --write .）
```

## テンプレート

```js
const fs = require('fs')

function main(input) {
  const args = input.trim().split(/\s+/)
  // ---
}

const input = fs.readFileSync(0, 'utf-8', '/dev/stdin')
main(input)
```

