---
layout: post
title: "YOLO26n・sのFP32とstatic INT8を比較した"
excerpt: "YOLO26n・sの640pxモデルをFP32とstatic INT8で比較し、容量、品質、PC推論時間、実行時memoryの変化を検証しました。"
thumbnail: /assets/images/posts/yolo26-fp32-static-int8-comparison/thumbnail.svg
date: 2026-08-10 23:30:00 +0900
author: Reo Komatsubara
tags: [AI, Android]
toc: true
qiita:
  publish: true
  tags:
    - Android
    - ONNX
    - YOLO
    - 量子化
    - 機械学習
---

## 前回からの続きと今回の結論

[前回の記事](/2026/08/10/yolo26-scale-resolution-comparison.html)では、YOLO26n・s・mを320pxと640pxで組み合わせた6条件をFP32で比較し、量子化比較へ渡す候補として **YOLO26n（640px）とYOLO26s（640px）** を残しました。

今回の結論は次のとおりです。

- **容量:** INT8化でnは約68.9%、sは約73.1%小さくなった
- **品質:** nとsのどちらも、同じモデルのFP32からclass別AP低下2.0 points以内というgateに不合格
- **PC速度:** このORT CPU条件では、nとsのどちらもINT8がFP32より一貫して遅かった
- **Androidへ渡す条件:** **YOLO26n（640px・FP32）**
- **Android実機:** まだ未測定

これは「INT8は常に遅い」「AndroidでもINT8が遅い」という結論ではありません。確認できた範囲は、今回のYOLO26 QDQ graph、ONNX Runtime 1.28.0、AMD Ryzen 7 H 255、CPUExecutionProviderという組み合わせです。

## この記事を読む前の用語

表と図を読むために必要な意味だけを先にまとめます。calibrationやQDQは、登場する節でも言い換えます。

| 用語 | この記事での意味 |
| --- | --- |
| FP32 | 数値を32 bit浮動小数点で扱う基準モデル |
| INT8 | 数値を8 bit整数へ近似し、容量や計算量の削減を狙う表現 |
| [量子化](/terms/model-quantization/) | FP32の値を限られた整数範囲へ写す変換 |
| [static quantization](/terms/static-quantization/) | 事前に代表画像を流し、推論途中の値の範囲を固定する方式 |
| [calibration](/terms/quantization-calibration/) | 代表画像からscaleとzero pointを決める工程。学習ではない |
| scale / zero point | 整数1段分の幅と、実数0に対応する基準点 |
| [QDQ](/terms/qdq/) | QuantizeLinear / DequantizeLinearをONNX graphへ挿入する表現 |
| [AP 50-95](/terms/average-precision/) | 見逃しと誤検出を複数のIoU条件でまとめた品質指標。高いほど良い |
| [quantization drift](/terms/quantization-drift/) | FP32からINT8へ変えたことで生じる[bbox](/terms/bounding-box/)、confidence、検出件数などの差 |
| p50 / p95 | 測定値の中央値と、95%の値が収まる境界 |
| model size | 保存したONNXファイルの容量 |
| [working set](/terms/working-set/) | 実行processが物理メモリ上で使用する領域 |

## なぜFP32とINT8を比較したか

INT8化には、モデルの小型化や処理時間の短縮が期待できます。ただし品質が変わる可能性もあるため、**容量、品質、PC推論時間、実行時memoryを別々に測定**しました。

## FP16を今回の検証候補から外した理由

前回予告したFP16は、標準のORT CPU Execution Providerでは実行できません。DirectMLへ変えるとbackend差も混ざるため、今回の検証候補から外しました。

![同じONNX Runtime CPU backendで比較できるFP32とINT8を残し、FP16を今回の検証候補として棄却した判断図](/assets/images/posts/yolo26-fp32-static-int8-comparison/fp16-comparison-scope.svg)

*図1: FP16を比較対象から外した理由*

## static quantizationとcalibration

static quantizationでは、推論前に代表画像を流し、activationと呼ばれる途中の値の範囲を測ります。実数とINT8の整数`q`は、概念的に`scale × (q - zero point)`で対応付けます。

今回は[COCO](/terms/coco-dataset/) train2017からseed 17で固定した512画像を、nとsで共通のcalibration用画像にしました。評価結果を見て画像や方式を選び直していません。

![COCO train2017の512画像でscaleとzero pointを決め、別のCOCO val2017全5000画像でFP32とINT8の品質を評価する流れ](/assets/images/posts/yolo26-fp32-static-int8-comparison/static-quantization-flow.svg)

*図2: calibrationと品質評価を別データで実施*

品質評価用のval2017をcalibrationにも使うと、評価対象の情報が変換条件へ漏れます。そのため、**train2017で量子化条件を固定し、val2017全5,000画像で品質を測定**しました。

## 公平に固定した比較条件

比較したのは2モデル×2表現の4条件です。FP32 / INT8以外の入力、評価画像、runtime、前後処理をそろえています。

| 項目 | 固定した条件 |
| --- | --- |
| モデル | YOLO26n（640px）、YOLO26s（640px） |
| precision | FP32、static INT8 |
| INT8方式 | ONNX Runtime QDQ、S8S8、MinMax、per-channel、reduce-rangeなし |
| 量子化対象 | Conv 102 + MatMul 4 |
| 入力 | static batch 1、640×640、end-to-end、NMSなし |
| runtime | Windows 11 x64、AMD Ryzen 7 H 255、ORT 1.28.0 CPUExecutionProvider |
| 品質 | COCO val2017全5,000画像、personとcar |
| calibration | COCO train2017からseed 17で固定した512画像 |
| [レイテンシ](/terms/latency/) | 固定100画像、confidence 0.4、warm-up 50 |
| Detection Point | bbox bottom-centerの正規化2D代理誤差 |

`static batch 1`は一度に1枚だけ入力する設定です。`NMSなし`は、重なった候補を整理する処理を今回のONNX推論経路へ含めていないことを表します。

## 品質・PC速度・容量の結果

### まず4条件を同じ表で見る

APは0〜1の値を100倍し、points表示に統一します。**APは高いほど良く、推論時間、ONNX容量、working setは低いほど負荷が軽い方向**です。

| 条件 | person AP | car AP | 初回ORT推論p50 | ONNX | peak working set |
| --- | ---: | ---: | ---: | ---: | ---: |
| **n・FP32** | **52.9** | **37.2** | **20.96 ms** | **9.48 MiB** | **374.3 MiB** |
| n・INT8 | 50.2 | 33.7 | 52.79 ms | 2.95 MiB | 386.4 MiB |
| s・FP32 | 61.0 | 46.6 | 54.88 ms | 36.52 MiB | 477.6 MiB |
| s・INT8 | 57.7 | 43.1 | 115.97 ms | 9.83 MiB | 486.6 MiB |

![YOLO26nとsのFP32・INT8について、平均AP、PC ORT推論p50、ONNX容量を比較した3パネル図](/assets/images/posts/yolo26-fp32-static-int8-comparison/fp32-int8-quality-speed-size.png)

*図3: 4条件の品質・PC速度・容量。×はquality gate不合格*

### 容量削減には成功した

- n：9.48 MiB → 2.95 MiB、**約68.9%削減**
- s：36.52 MiB → 9.83 MiB、**約73.1%削減**

一方、peak working setは減っていません。**保存容量と実行中memoryは別の指標**です。

### 品質gateには届かなかった

固定したgateは、**同じmodelのFP32からclass別AP低下2.0 points以内**です。

| INT8条件 | person AP低下 | car AP低下 | 固定gate |
| --- | ---: | ---: | --- |
| n・INT8 | -2.70 points | -3.47 points | 不合格 |
| s・INT8 | -3.25 points | -3.57 points | 不合格 |

Detection Point gateには合格し、runtime failureも0件でしたが、採用に必要なAP gateには届きませんでした。

## trade-off図はgateと一緒に読む

![YOLO26nとsをFP32からINT8へ変えたとき、ONNX容量は減る一方で品質が下がりPC推論時間が増えたことを示す散布図](/assets/images/posts/yolo26-fp32-static-int8-comparison/n-s-pareto.svg)

*図4: INT8化によるtrade-off*

[パレートフロンティア](/terms/pareto-frontier/)に残っても、最低品質を満たすとは限りません。quality gateを先に適用すると、Androidへ渡せるのはn・FP32だけでした。

## 小さくなっても速くならなかった構造

![FP32は384 node、INT8は1000 nodeで、QuantizeLinear 206、DequantizeLinear 410、量子化対象106、FP32のままのnode 278がある構成図](/assets/images/posts/yolo26-fp32-static-int8-comparison/graph-node-growth.svg)

*図5: QDQ追加後のgraph構成*

INT8 graphには、整数へ変換して戻すQDQ処理と、FP32のままのnodeが残ります。node別profileは未取得のため、**遅延原因の内訳までは断定できません**。

## quantization driftと無効bbox

### classが同じでも検出結果は同じとは限らない

confidence 0.4でFP32とINT8の検出を対応付けた結果は次のとおりです。

| 条件 | matched | FP32-only | INT8-only | class change |
| --- | ---: | ---: | ---: | ---: |
| n | 5,860 | 1,570 | 267 | 0 |
| s | 7,632 | 1,508 | 513 | 0 |

`class change 0`でも、confidence、bbox、検出の有無は変わり得ます。

### 推論成功と有効bboxも別

clip後に幅または高さが0以下となり、品質集計へ使えないbboxも増えました。

| モデル | FP32 | INT8 |
| --- | ---: | ---: |
| n | 1件 | 985件 |
| s | 2件 | 1,906件 |

これはruntime failureではなく、画像範囲へ収めた後に有効な四角形として扱えなかった検出です。

## 「PCがたまたま忙しかっただけか」を確認

速度差が一時的なPC負荷ではないか確認するため、同じONNXと固定100画像を使い、4条件を各5回測り直しました。

![YOLO26nとsのFP32・INT8を5回ずつ測り、どちらもINT8の推論時間範囲がFP32と重ならなかった結果](/assets/images/posts/yolo26-fp32-static-int8-comparison/latency-repeat-ranges.svg)

*図6: 5回のPC推論時間*

全5回でINT8がFP32より遅く、測定範囲も重なりませんでした。瞬間的なCPU競合は完全には除外できませんが、**一時的なPC負荷だけでは説明しにくい結果**です。

## 同じ画像で検出例を見る

青がFP32、橙がINT8の検出結果です。

![海辺でヨットを準備する人々の同一画像に対し、YOLO26n FP32とINT8のperson検出を左右で比較した例](/assets/images/posts/yolo26-fp32-static-int8-comparison/detection-example-yolo26n-fp32-int8-coco-000000078565.jpg)

*図7: 同一画像での検出例。この1枚だけでは全体品質を判断しない*

<details>
<summary>画像の出典・加工内容</summary>
<p>Title: <code>Preparing the boats ready for sailing at Wynnum</code>、Photographer: George Jackman、Institution: John Oxley Library, State Library of Queensland、Collection: <code>7708 George Jackman Photograph Albums</code></p>
<p>Rights statement: <a href="http://flickr.com/commons/usage/">No known copyright restrictions</a>、Reference: <a href="https://commons.wikimedia.org/wiki/File:Preparing_the_boats_ready_for_sailing_at_Wynnum_(4603303064).jpg">Wikimedia Commons</a>、Modification: 同じ画像を左右へ複製し、実測bbox、class、score、title、attribution footerを追加</p>
</details>

## なぜINT8をAndroidへ渡さないのか

![nとsのINT8は容量削減に成功したが品質gateに不合格となり、POCO X8 ProへはYOLO26n（640px・FP32）を渡す判断図](/assets/images/posts/yolo26-fp32-static-int8-comparison/selection-result.svg)

*図8: Android実機へ渡す条件*

PC段階のquality gateを通過した<strong>YOLO26n（640px・FP32）</strong>だけを、POCO X8 Proへ渡します。

## Android実機で確認すること

今回の数値はWindows PCでの結果であり、Android性能ではありません。次はYOLO26n（640px・FP32）をPOCO X8 Proへ組み込み、local-onlyで確認します。

- CameraXと画面描画を含むfps
- p95レイテンシ
- アプリのmemory使用量
- 温度と10分間のthermal throttling
- runtime failure、graph partition、CPU fallback

Android側はCPU EPとXNNPACKを中心に確認します。**PCレイテンシからAndroidのfpsは換算しません。**

## まとめ

**今回の選定結果は、YOLO26n（640px・FP32）をAndroid実機へ渡すことです。**

- INT8化で容量は減ったが、品質gateには不合格
- このPC条件では、5回ともINT8の推論時間が長かった
- Android性能は未測定。次はPOCO X8 Proで確認

## 参考資料

- [前回記事：YOLO26のモデル規模・入力解像度による性能差を比較した](/2026/08/10/yolo26-scale-resolution-comparison.html)
- [ONNX Runtime：Quantize ONNX models](https://onnxruntime.ai/docs/performance/model-optimizations/quantization.html)
- [ONNX Runtime：Float16 and mixed precision models](https://onnxruntime.ai/docs/performance/model-optimizations/float16.html)
- [ONNX Runtime：DirectML Execution Provider](https://onnxruntime.ai/docs/execution-providers/DirectML-ExecutionProvider.html)
- [ONNX Runtime：NNAPI Execution Provider](https://onnxruntime.ai/docs/execution-providers/NNAPI-ExecutionProvider.html)
- [Android Developers：NNAPI Migration Guide](https://developer.android.com/ndk/guides/neuralnetworks/migration-guide)
- [Ultralytics YOLO26](https://docs.ultralytics.com/models/yolo26/)
- [COCO Dataset](https://cocodataset.org/)

## ライセンスと公開範囲の注記

これは技術上の記録であり、**法的助言ではありません**。

- Ultralytics packageとn・s checkpointのmetadataはAGPL-3.0。Enterprise licenseは未適用
- 現在は個人・非商用・private repository・第三者非配布のlocal-only技術実験に限定
- 公開するのは集計値と権利確認済み画像のみ。weights、ONNX、code、raw結果は非公開

この範囲だけで適法性を断定しません。[Ultralytics License](https://www.ultralytics.com/license)と[AGPL-3.0 Software License Terms](https://www.ultralytics.com/legal/agpl-3-0-software-license)を参照し、**Android統合、APK・model配布、一般公開、API・SaaS、repository公開、商用、組織・法人利用へ進む前に公式条件を再評価します。**
