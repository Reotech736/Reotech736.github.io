# Repository Guidelines

## プロジェクト構成
このリポジトリは Jekyll ベースの技術ブログです。
- `_posts/`: 記事本文（`YYYY-MM-DD-title.md` 形式）
- `_study_logs/`: `knowledge-vault-work/03_study_logs` から生成される学習記録
- `_terms/`: `knowledge-vault-work/01_terms` から生成される技術メモ
- `_layouts/`, `_includes/`: レイアウトと共通部品
- `assets/css/`, `assets/images/`: スタイルと画像（サムネイル含む）
- `_data/`: タグやプロジェクト定義（`tags.yml`, `projects.yml`）
- `tags/`: タグ別ページ（例: `tags/docker.html`）
- `scripts/`: 補助スクリプト（contributions SVG 生成、knowledge-vault 取り込みなど）

生成物は `_site/` に出力され、Git 管理対象外です。

## ビルド・開発コマンド
リポジトリルートで実行してください。
- `bundle install`: Ruby/Jekyll 依存をインストール
- `bundle exec jekyll serve --host 0.0.0.0 --drafts`: ローカル起動（WSL 想定、今後の標準）
- `JEKYLL_ENV=production bundle exec jekyll build`: 本番相当ビルド確認
- `node scripts/generate-contributions-svg.mjs`: `assets/images/contributions.svg` を再生成（`GITHUB_TOKEN` 必須）
- `ruby scripts/import-study-logs.rb`: `knowledge-vault-work/03_study_logs` から学習記録を取り込む
- `ruby scripts/import-terms.rb`: `knowledge-vault-work/01_terms` から技術メモを取り込む

## リポジトリSkill
- 記事の専門用語を技術メモへ追加・更新し、記事内リンクまで整備する場合は `$add-blog-terms` を使用してください。
- 記事のSVGサムネイルを新規作成・修正する場合は `$create-blog-thumbnail` を使用してください。
- Skillの詳細手順をAGENTS.mdへ重複記載せず、ここには全作業で守る規約だけを残してください。

## コーディング規約・命名
- 記事は Markdown + Front Matter を使用し、`layout`, `title`, `date`, `tags` を明示します。
- `knowledge-vault-work` 由来の生成ファイル（`_study_logs/`, `_terms/`）は手編集前提にしません。必要な変更は原則 source 側ノートか import script で行います。
- 技術メモの一般説明は特定記事に依存させず、記事固有の内容は `関連記事での使用例` 配下へ記事タイトルとリンクを付けて記述します。
- 記事から技術メモへのリンクは、各用語の最初の意味のある出現を基本とします。見出し、Mermaid、コードブロック、画像の代替テキストには用語リンクを付けません。
- ブログ本文の通常段落では文末に `。` を付けます。タイトル、見出し、箇条書きの短い項目、画像キャプション、コード例ラベルは句点なしでも構いません。
- ブログ本文は 1 文ごとに明示改行せず、2〜3 文程度の意味のまとまりを 1 段落にします。話題が変わる場合は空行で段落を分けます。
- 同一段落内で軽く区切りたい場合だけ、Markdown のハード改行（行末スペース 2 つ）を使用します。記事本文では表示調整目的の単独 `<br>` 行を使わないでください。
- YAML/HTML は既存に合わせて 2 スペースインデントを維持します。
- 新規タグ追加時は次を必須とします。  
  1. `_data/tags.yml` に `name` と `slug` を追加  
  2. `tags/<slug>.html` を作成
- サムネイルは `assets/images/posts/<slug>/thumbnail.svg` に配置します。
- サムネイルはサイト全体のトーンに合わせ、寒色系グラデーションで作成します。画像サイズは `1200x630`（OGP比率）を基本とし、記事ごとに主題が分かるアイコンを 1 つ入れてください。
- サムネイルのタイトルはSVGのFront Matterに`thumbnail_title_lines`を定義し、`_includes/thumbnail-title-lines.svg`で描画します。タイトル文字を固定の`<text>`として重複実装しないでください。
- グラデーション配色は既存投稿との統一感を優先し、次の順でローテーションします。  
  1. `#024450 → #7eb3bf`  
  2. `#087b8a → #036982`  
  3. `#036982 → #024450`  
  4. `#3ba3c5 → #087b8a`  
  5. `#7eb3bf → #3ba3c5`

## テスト方針
専用のユニットテスト基盤はありません。以下を最低限実施してください。
- PR 前に `JEKYLL_ENV=production bundle exec jekyll build` を実行
- `bundle exec jekyll serve --host 0.0.0.0 --drafts` で表示確認
- import script を変更した場合は、対応する `ruby scripts/import-*.rb` を実行して生成結果も確認
- 技術メモを追加・更新した場合は `ruby scripts/import-terms.rb` を実行し、正本と `_terms/` の生成結果を確認
- 変更対象のページ（`/`, `/blog/`, `/study-logs/`, `/terms/`, `/tags/<slug>/`）でリンク・画像パス・コードブロックを確認

## コミット・PR ガイド
- コミットは Conventional Commits を使用（例: `feat: ...`, `fix: ...`, `docs: ...`, `chore: ...`）。
- `type` は小文字、件名は簡潔な命令形で記述します。
- ブランチ名は `feature/`, `fix/`, `docs/` を推奨します。
- PR には次を含めてください。  
  1. 目的と変更範囲  
  2. 変更ファイル/ディレクトリ  
  3. 実行した確認コマンド  
  4. 見た目変更がある場合はスクリーンショット

## セキュリティと設定
- `.env` やトークン等の秘密情報はコミットしないでください。
- contributions 更新時の `GITHUB_TOKEN` はランタイム秘密情報として扱ってください。
