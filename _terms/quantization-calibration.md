---
title: "量子化キャリブレーション"
slug: "quantization-calibration"
sort_key: "りょうしかきゃりぶれーしょん"
summary: "代表データを使って量子化に必要な数値範囲と変換パラメータを決める工程"
category: "ai"
aliases: ["Quantization Calibration","Calibration","Calibration Data"]
updated: 2026-08-10
---

## 一言でいうと
代表データを使って、実数を小さな整数表現へ写すための範囲と変換パラメータを決める工程。

## より具体的には
static quantizationでは、学習済みモデルへ代表的な入力を流し、推論途中に現れる値の範囲を観測する。その範囲から、整数1段分の幅を表すscaleや、実数0に対応する整数を表すzero pointを決める。

これはモデルを学習し直す工程ではない。ただし、代表データが実際の入力とかけ離れていると量子化後の品質へ影響し得るため、データの選び方、件数、乱数seed、評価データとの分離を記録する必要がある。

## 関連記事での使用例

### [YOLO26n・sのFP32とstatic INT8を比較した](/2026/08/10/yolo26-fp32-static-int8-comparison.html)
COCO train2017からseed 17で固定した512画像をnとsで共通利用し、品質評価用のval2017全5,000画像とは分離している。

## 関連
- [モデル量子化](/terms/model-quantization/)
- [Static Quantization](/terms/static-quantization/)
- [COCOデータセット](/terms/coco-dataset/)
- [Average Precision（AP）](/terms/average-precision/)
