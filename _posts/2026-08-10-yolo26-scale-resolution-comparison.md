---
layout: post
title: "YOLO26のモデル規模・入力解像度を比較"
thumbnail: /assets/images/posts/yolo26-scale-resolution-comparison/thumbnail.svg
date: 2026-08-10 05:30:00 +0900
author: Reo Komatsubara
tags: [AI, Android]
toc: true
qiita:
  publish: true
  tags:
    - Android
    - ONNX
    - YOLO
    - 物体検出
    - 機械学習
---

YOLO26n・s・mを320pxと640pxで組み合わせ、6条件の検出品質、PC処理時間、ONNXサイズ、実行時メモリを比較します。Android実機性能はまだ未検証です。

## 比較結果を先に

[前回の記事](/2026/08/10/smartphone-object-detection-model-comparison.html)では3候補を320pxで比べ、YOLO26nを基準にしました。今回はYOLO26系列に絞り、モデル規模と入力解像度を変えています。

- **最大品質:** m / 640
- **PCで最短の推論時間:** n / 320
- **品質と負荷の折衷点:** n / 640
- **Android実機:** まだ未検証

**次のFP32 / FP16 / INT8比較には、YOLO26n / 640pxを渡します。** これはAndroidへの最終採用ではありません。

## この記事を読む前の用語

前回記事で扱った言葉も含め、今回の表とグラフを読むために必要な意味だけをまとめます。

| 用語 | この記事での意味 |
| --- | --- |
| YOLO26n / s / m | 同じYOLO26系列のモデル規模違い。n、s、mの順に大きくなる |
| [入力解像度](/terms/input-resolution/) | モデルへ渡す画像の縦横サイズ。今回は320×320と640×640 |
| [AP 50-95](/terms/average-precision/) | 見逃しと誤検出のバランスをまとめた品質指標。大きいほど良い |
| [レイテンシ](/terms/latency/) | 1枚を処理するのにかかる時間。今回はPC上の推論区間を測定 |
| p50 / p95 | 測定値を小さい順に並べた中央と、95%の値が収まる境界 |
| [パレートフロンティア](/terms/pareto-frontier/) | 品質と速度のどちらを重視するかで評価が変わる候補の境界 |
| ONNXサイズ | PCや端末へ読み込むモデルファイルの保存容量 |
| [ワーキングセット](/terms/working-set/) | 実行中のプロセスが物理メモリ上で使っている領域 |
| [モデル量子化](/terms/model-quantization/) | FP32などの値をINT8のような小さな整数表現へ変え、小型化や高速化を検討する処理 |

## なぜ6条件を比較したか

### 比較する2つの軸

- **n / s / m:** モデルの規模
- **320 / 640:** 入力画像の一辺

モデルを大きくする影響と、入力を細かくする影響を分けるため、3×2の6条件にしました。

![YOLO26のn・s・mと320px・640pxを組み合わせ、モデル規模と入力解像度を別々に比較する6条件の構成図](/assets/images/posts/yolo26-scale-resolution-comparison/six-condition-design.svg)

*図1: 比較した6条件*

### 640pxで増えるもの

640×640は320×320より縦横が2倍で、**入力画素数は4倍**です。ただし、品質や処理時間まで単純に4倍になるわけではありません。

## 比較条件を公平にそろえる

### 固定した条件

比較条件は次のように固定しました。品質評価には前回と同じCOCO val2017全5,000画像を使い、人（person）と車（car）だけを集計しています。

| 項目 | 固定した条件 |
| --- | --- |
| 数値の表現 | FP32 |
| 入力 | static batch 1、320×320または640×640 |
| ONNX変換 | opset 20、end-to-end、NMSなし |
| PC | Windows 11 x64、AMD Ryzen 7 H 255 |
| 実行環境 | ONNX Runtime 1.28.0、CPUExecutionProvider |
| 品質 | COCO val2017全5,000画像、person / car |
| 変換前後の一致 | 固定100画像、warm-up 50回 |
| Detection Point | 固定seed 11の500画像 |
| 前処理 | 同じresize、色順、正規化、threshold、評価規則 |

`static batch 1`は一度に1枚を入力する設定です。`NMSなし`は、重なった候補を整理する処理を今回の推論経路に含めていないことを表します。

### ONNXへ変換しても一致するか

全6条件で次の確認に成功しました。

- ONNX export、ONNX checker、ORTの簡易実行
- 固定100画像のframework / ORT parity
- COCO全5,000画像の品質評価
- 5,000画像のruntime failureは**全条件0件**

parityで一致した検出数は、n / 320から順に185、295、251、340、289、370件で、片方だけに現れた検出は0件でした。ただし、**parity合格は変換前後の一致を示すだけで、検出品質の高さとは別**です。

## 6条件の結果

### 表の読み方

- **AP:** 大きいほど高品質
- **レイテンシ、ONNXサイズ、memory:** 小さいほど負荷が軽い方向

APは元の0〜1の値を100倍し、points表示にしています。

| 条件 | person AP | car AP | ORT推論 p50 / p95 (ms) | ONNX (MiB) | peak working set (MiB) |
| --- | ---: | ---: | ---: | ---: | ---: |
| n / 320 | 40.14 | 22.17 | 5.72 / 5.90 | 9.4 | 310.8 |
| **n / 640** | **52.86** | **37.22** | **18.03 / 18.80** | **9.5** | **374.5** |
| s / 320 | 49.33 | 31.93 | 14.05 / 14.39 | 36.4 | 355.5 |
| s / 640 | 60.98 | 46.63 | 50.58 / 52.74 | 36.5 | 478.5 |
| m / 320 | 54.69 | 38.23 | 37.94 / 39.78 | 78.0 | 435.3 |
| m / 640 | 64.52 | 51.99 | 150.74 / 153.77 | 78.2 | 666.0 |

### 指標ごとに最良条件は違う

**最大品質はm / 640、最短レイテンシはn / 320**です。一つの列だけでは候補を決められないため、品質とPC速度を同時に見ます。

## 品質と速度のパレート図

### グラフの読み方

- **左へ行く:** PC上の推論時間が短い
- **上へ行く:** personとcarの平均APが高い
- **左上:** 高品質・短時間の方向

横軸は、大きな時間差を読みやすくする対数目盛です。

![YOLO26 n・s・mの320pxと640pxについて、person・car平均APとPC ORT推論p50の関係を示した散布図](/assets/images/posts/yolo26-scale-resolution-comparison/quality-latency-pareto.png)

*図2: 左上ほど高品質・短時間。星印はn / 640*

### 分かったこと

**6条件すべてがパレートフロンティアに残りました。** 品質と速度の両方で明確に負ける候補はなく、用途に合う曲がり角を選ぶ結果です。

なお、この横軸はWindows PCのCPUで測ったONNX Runtimeの推論区間です。Androidのカメラアプリで同じ時間やfpsが出ることを示す図ではありません。

## 小さい物体で解像度が効いた

### グラフの読み方

COCOが定めるsmall、medium、large別のAPです。**棒が高いほど高品質**で、青がsmall、橙がmedium、緑がlargeです。

![YOLO26の6条件について、personとcarのAPをCOCOのsmall・medium・large別に比較した棒グラフ](/assets/images/posts/yolo26-scale-resolution-comparison/quality-by-object-scale.png)

*図3: COCOの物体面積別AP*

### n / 320からn / 640への変化

small APは次のように改善しました。

| Class | n / 320 | n / 640 | 増加 |
| --- | ---: | ---: | ---: |
| person small AP | 11.66 | 28.13 | +16.47 points |
| car small AP | 7.90 | 22.89 | +14.99 points |

large APの増加はpersonが+3.15 points、carが+4.19 pointsでした。今回の評価では、**大きく写った対象よりsmall区分で改善が大きい**結果です。

### smallは「遠距離」の意味ではない

COCOの区分はannotation上の物体面積です。実距離や遮蔽率ではないため、遠くの人や車を検出できるかは実際のカメラ映像で確認します。

## Detection Pointの変化

### bbox下端中央を見る理由

このプロジェクトでは、検出した枠の下端中央を、将来カメラから地面方向へ線を伸ばす処理の入口にする予定です。そこで固定500画像を使い、予測bboxとCOCOの正解bboxのbottom-centerがどれくらいずれたかも比較しました。

### 結果

| Class | n / 320 p95 d2 | n / 640 p95 d2 | 良い方向 |
| --- | ---: | ---: | --- |
| person | 0.0443 | 0.0340 | 小さい |
| car | 0.0271 | 0.0182 | 小さい |

`d2`は画像の幅と高さで正規化した2次元のずれです。**n / 640ではperson、carともにp95が小さくなりました。**

### 検出例

次の画像では、青い枠が実測したpersonの検出結果、金色の点がbboxのbottom-centerです。何を検出し、どの点を代理評価へ使ったかを見るための例であり、この1枚だけでモデル全体の品質を判断するものではありません。

![YOLO26n 640pxが飲食店内の2人を検出し、bboxとbottom-centerを重ねた例](/assets/images/posts/yolo26-scale-resolution-comparison/detection-example-yolo26n-640-coco-000000345356.jpg)

*図4: n / 640のperson検出例*

Photo: [Phu Son](https://www.flickr.com/photos/phuson/)、[Original](https://www.flickr.com/photos/phuson/195983274/)、License: [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/)。元画像を縮小し、実測bbox、label、confidence、bottom-center、説明footerを追加しています。

### この指標の限界

この値はCOCO bboxを使った正規化2D代理誤差です。金色の点が実際の足先、車輪、地面との接点の正解位置だという意味ではなく、カメラ角度や実距離の誤差も表していません。

## なぜm / 640ではなくn / 640なのか

n / 640は最速でも最高品質でもありません。近い候補との差を並べると、折衷点として選んだ理由が見えます。

![s・320、n・640、m・320の品質差とPC推論時間、ONNXサイズ、実行時メモリの増減を比較した図](/assets/images/posts/yolo26-scale-resolution-comparison/selection-knee.svg)

*図5: n / 640と近い2条件の差*

### s / 320と比べる

- person AP: **+3.53 points**
- car AP: **+5.28 points**
- PC推論p50: +3.98ms
- ONNX: **約26.9MiB小さい**

### m / 320と比べる

m / 320へ大きくすると、person APは+1.83 points、car APは+1.01 pointsです。一方で負荷は次のように増えます。

- PC推論p50: **+19.92ms**
- ONNX: **+68.6MiB**
- peak working set: **+60.8MiB**

### 判断

**今回はn / 640を品質と負荷の曲がり角として選びました。**

m / 640が不要という結論ではありません。品質を最優先できる環境なら候補になり得ます。今回の目的が、次の量子化比較とスマートフォン実験へ渡す現実的な基準を一つ決めることだったため、n / 640を選んでいます。

## PC測定からは分からないこと

### 今回測った範囲

今回の18.03msは、PCのCPUでONNXグラフを同期実行した区間です。スマートフォンアプリ全体の処理時間ではありません。

![PCで測定したONNX推論・COCO品質・モデルサイズ・実行時メモリと、Androidで未測定のカメラ入力・画面描画・発熱を分けた図](/assets/images/posts/yolo26-scale-resolution-comparison/pc-android-scope.svg)

*図6: PC測定とAndroid実機の範囲*

### Androidでまだ測っていない範囲

- CameraX、回転、resize、色変換
- bboxやラベルの画面描画、Androidのスケジューリング
- 発熱と10分間動かしたときの速度低下

**PCの18.03msをAndroidのfpsへ換算しません。** PCのpeak working setも、Androidアプリのメモリ使用量ではありません。

COCO val2017は候補間を同じ条件で比べるには役立ちますが、実際のスマートフォンカメラの距離、画角、手ぶれ、遮蔽、明るさをそのまま再現したものではありません。今回分かったのは、PC上の共通条件で次に比べる候補をn / 640へ絞れたところまでです。

## 次回はFP32 / FP16 / INT8を比べる

### 次に比較する3種類

**モデルと入力はYOLO26n / 640pxに固定**し、数値表現だけを変えます。

- **FP32:** 今回と同じ基準
- **FP16:** 精度を下げた浮動小数点
- **INT8:** 整数を使う量子化

### 確認する指標

- person / car APとDetection Point
- ONNXサイズ、レイテンシ、実行時メモリ
- FP16 / INT8で品質が大きく崩れないか

**品質やDetection Pointが大きく崩れた場合は、今回の選定へ戻ります。**

### その後はAndroid実機へ

POCO X8 Proで次を測ります。

- CameraXと画面描画を含めて約10fpsに届くか
- p95 latencyとmemory
- 温度と10分間のthermal throttling

## まとめ

**今回の結論は、YOLO26n / 640pxを次の比較基準にすることです。**

- 最大品質はm / 640、PCで最短の推論時間はn / 320
- 6条件すべてでONNX変換後の一致とCOCO全5,000画像の評価に成功
- n / 640はsmall APとDetection Pointがn / 320から改善
- m / 320へ大きくしたときの追加品質より、増える負荷が目立つ
- Androidでの最終採用はまだ未決定

次はFP32 / FP16 / INT8を比較し、その後にPOCO X8 Proで持続性能を測ります。

## 参考資料

- [前回記事：スマートフォン向け物体検出モデル3候補をPCで比較した](/2026/08/10/smartphone-object-detection-model-comparison.html)
- [Ultralytics YOLO26](https://docs.ultralytics.com/models/yolo26/)
- [Ultralytics License](https://www.ultralytics.com/license)
- [Ultralytics AGPL-3.0 Software License Terms](https://www.ultralytics.com/legal/agpl-3-0-software-license)
- [COCO Dataset](https://cocodataset.org/)
- [ONNX Runtime Mobile](https://onnxruntime.ai/docs/tutorials/mobile/)

## ライセンスに関する注記

これは技術上の記録であり、**法的助言ではありません**。

- 実験時のUltralytics packageとn / s / m checkpoint metadataはAGPL-3.0
- Enterprise licenseは今回の実験へ未適用
- 現在は個人・非商用・private・第三者非配布のlocal-only実験に限定
- ブログでは集計値と許諾確認済み画像だけを掲載し、weights、ONNX、code、raw結果、logは配布しない

この限定範囲だけで適法性を断定しません。**Android統合、配布、一般公開、API / SaaS、商用・法人利用へ進む前に、上記の公式条件を再確認します。**
