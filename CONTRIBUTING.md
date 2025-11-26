# コントリビューションガイド

## コミットメッセージ規約

このプロジェクトでは [Conventional Commits](https://www.conventionalcommits.org/) に従ったコミットメッセージを使用します

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

## ブランチ戦略

このプロジェクトでは **GitHub Flow** ベースのシンプルなブランチ戦略を採用します

### ブランチの種類

- **main**: 本番環境にデプロイされるブランチ（常に安定した状態を保つ）
- **feature/**: 新機能開発用ブランチ
- **fix/**: バグ修正用ブランチ
- **docs/**: ドキュメント更新用ブランチ

### 開発フロー

1. **ブランチを作成**
```bash
# 新機能の場合
git switch -c feature/add-new-article

# バグ修正の場合
git switch -c fix/broken-link

# ドキュメント更新の場合
git switch -c docs/update-readme
```

2. **変更をコミット**
```bash
git add .
git commit -m "feat: 新しい記事を追加"
```

3. **リモートにプッシュ**
```bash
git push origin feature/add-new-article
```

4. **プルリクエストを作成**
   - GitHub上でPRを作成
   - レビューを受ける（個人開発の場合は省略可）
   - 必要に応じて修正

5. **mainにマージ**
   - PRをマージ
   - ローカルブランチを削除

```bash
git checkout main
git pull origin main
git branch -d feature/add-new-article
```

### ブランチ命名規則

```
<type>/<short-description>

例:
- feature/blog-pagination
- fix/mobile-layout
- docs/contributing-guide
```

### ローカルでの確認

mainにマージする前に、必ずローカル環境で動作確認を行ってください：

```bash
bundle exec jekyll serve --livereload
```

### 緊急の修正（Hotfix）

本番環境で緊急の修正が必要な場合：

```bash
git switch -c fix/urgent-issue main
# 修正作業
git commit -m "fix: 緊急の問題を修正"
git push origin fix/urgent-issue
# PRを作成してすぐにマージ
```
