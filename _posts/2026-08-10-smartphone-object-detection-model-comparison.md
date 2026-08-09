---
layout: post
title: "スマートフォン向け物体検出モデルをPCで比較し、実機検証候補を決めた"
thumbnail: /assets/images/posts/smartphone-object-detection-model-comparison/thumbnail.svg
date: 2026-08-10 00:00:00 +0900
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

スマートフォンのカメラで人や車を見つける機能を作るため、3つのAIモデルをPC上で比べました。この記事では、実験の進め方と結果を、表とグラフを中心に説明します。

## この記事を読む前の用語

最初に、本文とグラフへ登場する言葉を短くまとめます。用語名から、もう少し詳しい技術メモも読めます。

| 用語 | この記事での意味 |
| --- | --- |
| [物体検出](/terms/object-detection/) | 画像の中から「人」「車」などを見つけ、種類と場所を示す処理 |
| [bbox（バウンディングボックス）](/terms/bounding-box/) | 見つけた物体の場所を囲む四角い枠 |
| [ONNX](/terms/onnx/) | AIモデルを別の環境へ受け渡すための共通ファイル形式 |
| [ONNX Runtime（ORT）](/terms/onnx-runtime/) | ONNX形式のモデルをPCやスマートフォンで動かすソフトウェア |
| [COCO](/terms/coco-dataset/) | 人や車の位置を正解データとして持つ、評価用にも使われる画像集 |
| [IoU](/terms/intersection-over-union/) | 予測した枠と正解の枠がどれくらい重なるかを0〜1で表す値 |
| [AP 50-95](/terms/average-precision/) | 見逃しと誤検出のバランスをまとめた品質指標。大きいほど良い |

このほか、`p50`は測定値を小さい順に並べた中央、`p95`は95%の測定値が収まる境界を表します。

## 今回やったこと

目標は、スマートフォンで人と車を検出するモデルをいきなり決めることではありません。まずPC上で候補を絞り、Android実機で試す1つを決めることです。

| 項目 | 今回の条件 |
| --- | --- |
| 比較候補 | YOLO26n、D-FINE-N、PicoDet-S |
| 検出するもの | 人（person）、車（car） |
| モデルへの入力 | 320×320ピクセル相当 |
| 品質評価 | COCO val2017の全5,000画像 |
| 速度測定 | Windows PCのCPU |
| Android実機 | まだ未検証 |

比較は次の順番で進めました。

1. 候補をONNX形式へ変換する
2. 変換前と変換後で検出結果が変わらないか確認する
3. 5,000画像で、人と車を見つける品質を比べる
4. PC上の処理時間を比べる
5. POCO X8 Proへ渡す候補を決める

### 3候補の扱い

| 候補 | 今回どこまで調べたか |
| --- | --- |
| YOLO26n | PC上で変換後の一致、品質、速度を評価 |
| D-FINE-N | ONNX checker、ORT実行、変換後の一致、品質、速度を評価 |
| PicoDet-S | checkpoint固有の利用条件を一次情報で確認できず、実行前に除外 |

PicoDet-SはsourceがApache-2.0である一方、今回使うcheckpointの条件を確認できませんでした。利用できないと断定したのではなく、不明な状態では進めない判断です。

## ONNXへ変換しても結果は変わらないか

モデルをONNXへ変換できても、検出する位置や確からしさが変わってしまえば、元と同じモデルとして扱えません。そこで、同じ100画像を変換前の公式環境とORTへ入力し、検出枠を1件ずつ比べました。この確認をframework/ORT parityと呼びます。

![YOLO26nとD-FINE-Nについて、変換前のframeworkとONNX Runtimeの全検出が一致したことを示す集計図](/assets/images/posts/smartphone-object-detection-model-comparison/framework-ort-parity.png)

この図で見る箇所は、青とオレンジの棒がどちらも100%になっている点です。

| 候補 | 一致した検出 | 片方だけに出た検出 | 結果 |
| --- | ---: | ---: | --- |
| YOLO26n | 185 / 185 | 0 | 合格 |
| D-FINE-N | 277 / 277 | 0 | 合格 |

D-FINE-NはONNX checkerによる構造確認と、ORTでの実行にも合格しました。どちらの候補も、ONNX変換によって検出結果が崩れていないことを確認できました。

ただし、ここで確認したのは「変換前と変換後が同じか」です。両方が同じ物体を見逃しても一致にはなるため、parity合格と検出品質の高さは別の話です。

## COCO全5,000画像で品質を比べる

次に、COCO val2017の全5,000画像を使い、人と車の検出品質を測りました。AP 50-95は大きいほど、見逃しと誤検出のバランスが良いことを表します。

![COCO val2017全5,000画像におけるYOLO26nとD-FINE-NのpersonとcarのAP 50-95を比較した棒グラフ](/assets/images/posts/smartphone-object-detection-model-comparison/quality-coco-ap50-95.png)

このグラフでは、棒が長いほど品質が高いと読みます。人と車のどちらでも、YOLO26nの棒が長くなりました。

| 評価項目 | YOLO26n | D-FINE-N | 良い方向 |
| --- | ---: | ---: | --- |
| person AP 50-95 | 約0.401 | 約0.104 | 大きい |
| car AP 50-95 | 約0.222 | 約0.057 | 大きい |
| 5,000画像のruntime failure | 0件 | 0件 | 少ない |

今回の品質条件は、各クラスでYOLO26nとの差を0.02以内にすることです。D-FINE-Nとの差はpersonが約0.298、carが約0.165だったため、この条件には届きませんでした。

処理失敗は両候補とも0件です。D-FINE-Nは途中で動かなくなったのではなく、最後まで動いたうえで品質条件に届かなかったと分かります。

## 検出枠の下端も比べる

今回は、検出した人の足元や、車が接している路面の方向を考える予定です。そのため、枠全体の重なりだけでなく、bbox下端中央のずれも比べました。

![固定500画像で測ったbbox下端中央のp95 d2を比較し、0.08の基準線を示した棒グラフ](/assets/images/posts/smartphone-object-detection-model-comparison/quality-detection-point-p95-d2.png)

このグラフは、棒が短いほど位置のずれが小さいと読みます。`d2`は画像サイズで調整した距離で、p95は大部分の検出が収まる誤差の境界です。

| 対象 | YOLO26n | D-FINE-N | 良い方向 |
| --- | ---: | ---: | --- |
| person p95 d2 | 約0.044 | 約0.075 | 小さい |
| car p95 d2 | 約0.027 | 約0.049 | 小さい |

D-FINE-Nは絶対条件の0.08以下には収まりました。ただし、YOLO26nからの悪化を0.02以内にする条件は、personが約0.031、carが約0.022となり、どちらも超えました。

なお、COCOのbbox下端は、実際の足先やタイヤ位置を記録したものではありません。ここでは2候補の位置ずれを同じ物差しで比べる代理値として使っています。

## PC上の処理時間を比べる

最後に、Windows PCのCPUで、モデルが検出結果を計算する推論部分の時間を測りました。グラフの棒は短いほど高速です。

![Windows PCのCPU上で測ったYOLO26nとD-FINE-NのframeworkおよびONNX Runtime推論時間のp50とp95を比較した棒グラフ](/assets/images/posts/smartphone-object-detection-model-comparison/latency-inference-p50-p95.png)

| ORT CPUの推論時間 | YOLO26n | D-FINE-N |
| --- | ---: | ---: |
| p50 | 約6.83ms | 約25.81ms |

YOLO26nの方が、PC上の推論時間は短い結果でした。ただし、この数値にはスマートフォンのカメラ入力、画面描画、発熱による速度低下などは含まれません。Androidでも約6.83msで動くという意味ではありません。

## 実験結果をまとめる

比較結果を候補ごとにまとめると、次のようになります。

| 候補 | 変換・実行 | 320pxの品質 | PC速度 | 次の工程 |
| --- | --- | --- | --- | --- |
| YOLO26n | parity 185 / 185 | 3候補中で最良 | 最速 | POCO X8 Proで検証 |
| D-FINE-N | checker、ORT、parity 277 / 277に合格 | 今回の条件に届かず | YOLO26nより遅い | 今回は渡さない |
| PicoDet-S | 実行前に除外 | 未測定 | 未測定 | 条件確認後に再検討可能 |

D-FINE-Nは「失敗して動かなかった」候補ではありません。Apache-2.0のsourceとcheckpointを確認でき、ONNX変換からORT実行まで通せたことで、互換性と品質を分けて判断できました。

## まだ分かっていないこと

Android実機ではまだ検証していません。次の工程では、PC結果とは別に以下を測ります。

| POCO X8 Proで確認すること | 確認する理由 |
| --- | --- |
| モデルを読み込んで推論できるか | PCとAndroidでは対応環境が異なるため |
| カメラを含む実効fps | 推論だけでなく撮影と描画にも時間がかかるため |
| 処理時間のp50 / p95 | 普段の速さと遅い場面の両方を見るため |
| 10分連続実行時の温度と速度 | 発熱で性能が下がる可能性があるため |
| メモリ使用量 | アプリとして安定して動かせるかを見るため |

次はPOCO X8 Proだけで完結するlocal-only検証へ進みます。モデルやAPKは第三者へ配布せず、Android上で動くことと、配布できることは分けて扱います。

## 参考資料

- [Ultralytics License](https://www.ultralytics.com/license)
- [Ultralytics AGPL-3.0 Open Source License Terms](https://www.ultralytics.com/legal/agpl-3-0-software-license)
- [D-FINE source LICENSE](https://github.com/Peterande/D-FINE/blob/7fe2f8889f0b7b817f20c315b40fc15a4fb64ae6/LICENSE)
- [D-FINE checkpoint配布repositoryのLICENSE](https://github.com/Peterande/storage/blob/39a3115d4b1183b9035e333e57655f018272ebbe/LICENSE)
- [PicoDet Model Zoo](https://github.com/PaddlePaddle/PaddleDetection/blob/b25522a0f4bde8c80603f3ba5e3472059972e3b5/configs/picodet/README_en.md)
- [COCO Dataset](https://cocodataset.org/)
- [ONNX Runtime Mobile](https://onnxruntime.ai/docs/tutorials/mobile/)

## まとめ

PC上の比較では、YOLO26nが品質、推論速度、framework/ORT parityの総合で最も良い結果でした。そのため、**YOLO26nをPOCO X8 Proで試す第一候補**にします。

ただし、YOLO26nのsourceとcheckpoint licenseはAGPL-3.0です。高性能だから条件を無視したのではなく、現在の個人・非商用・private・第三者非配布の技術実験に限る候補としました。

当初のApache-2.0限定は、将来のAPK配布を想定した保守的な判断でした。利用範囲を明文化したためlocal-only実験の候補へ変更しましたが、次へ進む前には判断をやり直します。

- APKやモデルの配布、一般公開
- API・SaaSやrepositoryの公開
- 商用利用、組織・法人での利用

ここまでで決めたのは、Android実機へ渡す候補だけです。スマートフォンで実用的に動くかどうかは、次のPOCO X8 Pro実機検証で確認します。
