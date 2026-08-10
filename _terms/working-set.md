---
title: "ワーキングセット"
slug: "working-set"
sort_key: "わーきんくせっと"
summary: "実行中のプロセスが物理メモリ上で使用している領域"
category: "ai"
aliases: ["Working Set","Peak Working Set"]
updated: 2026-08-10
---

## 一言でいうと
実行中のプロセスが、その時点で物理メモリ上に保持している領域。

## より具体的には
モデルファイルの保存容量とは別に、推論中はモデルの読み込み、入力、途中の計算結果、実行環境などのためにメモリを使う。ワーキングセットはその実行時メモリを見る指標の一つで、最大値はpeak working setと呼ばれる。

値はOS、実行環境、測定開始点、同じプロセスに含まれる処理によって変わる。モデルファイルが小さくても実行時メモリが同じ割合で小さいとは限らないため、測定条件と一緒に比較する。

## 関連記事での使用例

### [YOLO26のモデル規模・入力解像度による性能差を比較](/2026/08/10/yolo26-scale-resolution-comparison.html)
各条件を新しいプロセスで起動し、モデル読み込み前から推論までを5ミリ秒間隔で測って最大ワーキングセットを比較した。

## 関連
- [ONNX Runtime](/terms/onnx-runtime/)
- [入力解像度](/terms/input-resolution/)
- [モデル量子化](/terms/model-quantization/)
