# コントリビューションガイド

## コミットメッセージ規約

このプロジェクトでは [Conventional Commits](https://www.conventionalcommits.org/) に従ったコミットメッセージを使用します。

### フォーマット

```
<type>: <subject>

<body>

<footer>
```

### Type一覧

- **feat**: 新機能の追加
- **fix**: バグ修正
- **docs**: ドキュメントのみの変更
- **style**: コードの動作に影響しない変更（空白、フォーマット、セミコロンの欠落など）
- **refactor**: バグ修正や機能追加を含まないコードの変更
- **perf**: パフォーマンスを向上させるコードの変更
- **test**: テストの追加や既存のテストの修正
- **chore**: ビルドプロセスやツール、ライブラリの変更

### コミット例

```bash
# 良い例
feat: ナビゲーションメニューにアニメーションを追加
fix: モバイル表示時のレイアウト崩れを修正
docs: セットアップ手順をREADMEに追記

# 悪い例
update files
fix bug
変更
```

### ルール

1. **type**は小文字の英語を使用
2. **subject**は日本語で簡潔に（50文字以内推奨）
3. 命令形で書く（「追加する」ではなく「追加」）
4. 末尾にピリオドをつけない
5. bodyやfooterは必要に応じて追加

### Git設定

コミットメッセージテンプレートを使用する場合：

```bash
git config commit.template .gitmessage
```
