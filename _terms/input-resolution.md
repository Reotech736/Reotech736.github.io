---
title: "入力解像度"
slug: "input-resolution"
sort_key: "にゅうりょくかいぞうど"
summary: "AIモデルへ渡す画像の縦横サイズ"
category: "ai"
aliases: ["Input Resolution","Input Size"]
updated: 2026-08-10
---

## 一言でいうと
画像を扱うAIモデルへ渡す、画像の縦横サイズ。

## より具体的には
[物体検出](/terms/object-detection/)では、元画像をモデルが受け取れる幅と高さへ拡大・縮小してから推論する。たとえば320×320と640×640では、640側の入力画素数は320側の4倍になる。

入力解像度を大きくすると小さな対象の情報を残しやすい一方、計算量、メモリ使用量、処理時間が増える可能性がある。実際の影響はモデルと実行環境によって異なるため、同じ評価データと条件で測定する必要がある。

## 関連記事での使用例

### [スマートフォン向け物体検出モデルをPCで比較し、実機検証候補を決めた](/2026/08/10/smartphone-object-detection-model-comparison.html)
スマートフォン向けの軽い基準条件として320×320を採用し、今後は320と640の品質・処理時間を比較する。

## 関連
- [物体検出](/terms/object-detection/)
- [ONNX](/terms/onnx/)
- [Average Precision（AP）](/terms/average-precision/)
