---
title: "ONNX Runtime"
slug: "onnx-runtime"
sort_key: "onnx-runtime"
summary: "ONNX形式のAIモデルをPCやスマートフォンで実行するランタイム"
category: "ai"
aliases: ["ORT"]
updated: 2026-08-10
---

## 一言でいうと
ONNX形式のAIモデルをPCやスマートフォンで実行するためのソフトウェア。

## より具体的には
[ONNX](/terms/onnx/)モデルを読み込み、入力データを渡して推論結果を受け取る機能を提供する。Windows、Linux、Androidなど複数の環境に対応している。

実際に使える演算や速さは、モデル、端末、OS、ONNX Runtimeのversion、利用するCPUやGPUの経路によって変わる。PCで動いたモデルがスマートフォンでも同じ速度で動くとは限らない。

## 関連記事での使用例

### [スマートフォン向け物体検出モデル3候補をPCで比較した](/2026/08/10/smartphone-object-detection-model-comparison.html)
ONNX RuntimeのPC向けCPU実行を使い、変換後のモデルが動くこと、変換前と結果が一致すること、推論時間を確認している。

## 関連
- [ONNX](/terms/onnx/)
- [物体検出](/terms/object-detection/)
