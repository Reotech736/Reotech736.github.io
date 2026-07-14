# サムネイルのスタイル基準

## 固定仕様

- サイズ: `1200x630`
- 保存先: `assets/images/posts/<slug>/thumbnail.svg`
- 背景: 寒色系の線形グラデーション
- 構図: 左側に文字、右側に主題アイコン
- フォント: `Noto Sans JP, 'Hiragino Kaku Gothic ProN', 'Meiryo', sans-serif`
- タイトル: 白、太字、通常50〜62px
- 補足: 白、26px前後、`opacity="0.9"`

## パレットローテーション

投稿順に次を循環させる。

1. `#024450 → #7eb3bf`
2. `#087b8a → #036982`
3. `#036982 → #024450`
4. `#3ba3c5 → #087b8a`
5. `#7eb3bf → #3ba3c5`

ファイル名の辞書順ではなく、記事の`date`で直近投稿を判断する。

## 基本骨格

```svg
---
thumbnail_title_lines:
  - text: "1行目"
    size: 58
  - text: "2行目"
    size: 54
thumbnail_title_start_y: 250
thumbnail_title_line_gap: 72
---
<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="630" viewBox="0 0 1200 630">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="#024450"/>
      <stop offset="100%" stop-color="#7eb3bf"/>
    </linearGradient>
  </defs>

  <rect width="1200" height="630" fill="url(#bg)"/>
  <circle cx="1045" cy="100" r="95" fill="#ffffff" fill-opacity="0.12"/>
  <circle cx="1040" cy="535" r="155" fill="#ffffff" fill-opacity="0.08"/>

  <!-- 上部ラベル -->
  {% include thumbnail-title-lines.svg lines=page.thumbnail_title_lines start_y=page.thumbnail_title_start_y line_gap=page.thumbnail_title_line_gap %}
  <!-- 補足 -->
  <!-- 右側アイコン -->
</svg>
```

## レイアウト判断

- 文字領域はおおむね`x=80〜720`、アイコン領域は`x=800〜1120`を使う。
- 上部ラベルは`x=80`、`y=90`付近、高さ40pxを基準にする。
- タイトル開始位置は`y=250`、行間は70〜76pxを基準にする。
- 補足は`y=430`付近に置き、一文ではなく短いキーワード列にする。
- 日本語の長い行はフォントを小さくするより、意味の切れ目で改行する。
- 1200px表示だけでなく、一覧の小さいカードでも主題が判別できる単純さを優先する。
