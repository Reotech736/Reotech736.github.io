---
title: 実盤の囲碁を棋譜に残したい。「碁つづり」を作り始めました
tags:
  - Android
  - Kotlin
  - CameraX
  - 画像認識
  - Igo
private: false
updated_at: '2026-10-25T12:24:30+09:00'
id: 7a5004f177cb8d2b5961
organization_url_name: null
slide: false
ignorePublish: false
posting_campaign_uuid: null
agreed_posting_campaign_term: false
---

自宅の碁盤で打った対局を、スマホで撮って棋譜に残せないか。そんなことを考えて、Androidアプリ「碁つづり（Gotsuzuri）」を作り始めました。

目標は対局を撮影して[SGF](https://reotech736.com/terms/smart-game-format/)形式の棋譜を作ることです。今はまだ、撮った写真に碁盤の交点を重ね、石の配置を試しに判定するところまで。動画や棋譜の出力には、これから取り組みます。

## ここまでの試作

Kotlinと[Jetpack Compose](https://reotech736.com/terms/jetpack-compose/)で画面を作り、撮影には[CameraX](https://reotech736.com/terms/camerax/)を使っています。

![真上に近い位置から撮影した、検証中の碁盤](https://reotech736.com/assets/images/posts/gotsuzuri-static-board-recognition/board-top.jpg)

開発中に使った、真上に近い位置からの写真。

最初は写真の四隅を手動で指定することにしました。木枠の角ではなく、最外周の交点を4つ選ぶと、19×19の交点が画像に重なります。斜めに写った盤面にも合わせられ、実際の操作は体感で2分もかかりませんでした。

## 石認識の難しさ

![四隅の番号と、空・石候補・不明の試験判定を重ねた開発中の画面](https://reotech736.com/assets/images/posts/gotsuzuri-static-board-recognition/recognition-preview.png)

試験判定を重ねた開発中の画面。緑は空、黒白の丸は石候補、橙は不明です。正解を表示しているわけではありません。

### 影と反射

交点が合えば石も読めそうですが、そう簡単にはいきませんでした。影で盤面が暗くなり、照明を足すと今度は反射が増えます。低い位置から撮ると、奥の石も重なって見えます。

![低い角度から撮影した碁盤。奥側の石は縦に密集して見える](https://reotech736.com/assets/images/posts/gotsuzuri-static-board-recognition/board-low.jpg)

同じ配置を低い角度から撮影した写真。

### 石の高さと位置ずれ

石には厚みがあるので、斜めから見ると上面が交点からずれて見えます。盤面の交点を合わせる処理だけでは、このずれまでは直せません。

![カメラから見た石の上面と盤面の交点の違いを示す模式図](https://reotech736.com/assets/images/posts/gotsuzuri-static-board-recognition/stone-height.svg)

石の高さによるずれの模式図。実写のずれ量を測定した図ではありません。

![奥側の交点を拡大した写真。石と近接する4交点を黄色い輪で示している](https://reotech736.com/assets/images/posts/gotsuzuri-static-board-recognition/far-intersections.jpg)

黄色い輪の4交点は実際にはすべて空です。PCでの判定では、ここを黒2点・白2点と誤判定しました。輪は説明のために追加しています。

現在は色と明るさで石候補を探しています。まだAIモデルは使っていません。交点の周囲を探すようにしても、隣の石を拾っている疑いが残りました。

## 正解データでの比較

### GTの作成

画面を見て「だいたい合っていそう」と確認するだけでは、改善したのか分かりません。そこでPCにラベル作成画面を用意し、私が各交点を空・黒・白に分類しました。この正解データを[GT（Ground Truth）](https://reotech736.com/terms/ground-truth/)として、現在の判定結果と照合しました。

### 3枚の比較

同じ配置の写真3枚を比べた結果がこちらです。1枚につき361交点を数え、「不明」は判定を保留した点として分けています。

| 撮影位置 | 正しい判定 | 誤判定 | 不明 |
| --- | ---: | ---: | ---: |
| 上方 | 347 | 0 | 14 |
| 低い角度 | 335 | 4 | 22 |
| 高い位置 | 337 | 0 | 24 |

低い角度で間違えた4点は、高い位置の写真ではすべて不明でした。誤検出はなくなっても、空だと分かるところまでは進んでいません。不明には本物の石も含まれるため、全部を空として扱うこともできません。

これはPCでの比較で、Android上の結果と完全に一致するものではありません。3枚とも同じ配置で、影などの条件も違うので、まだ一般的な認識性能は判断できません。

## 盤面認識AIの学習に向けて

ここまで試してみて、盤面認識AIの学習に取り組んでみたくなりました。色や明るさで判定する今の処理と、石の見た目を学習したモデルで、どんな違いが出るのか比べてみたいです。

まずは問題が出た場所の石について、画像上で見える中心を少数記録する予定です。石の色を読み違えたのか、正しい色を読んでも隣の交点に割り当てたのかを切り分けます。そのうえで別の配置の正解データも用意し、小さなモデルをPCで学習・評価してみたいと考えています。

今はまだ、AIの学習を始める前の段階です。自宅で石を並べながら、認識を改善していく過程も記録していく予定です。

---

この記事は[Reo's Tech Blogの同名記事](https://reotech736.com/2026/10/25/gotsuzuri-static-board-recognition.html)にも掲載しています。

Reo's Tech Blogでは、個人開発や日々の技術的な取り組みを記録しています。興味がありましたら、[ほかの記事もご覧ください](https://reotech736.com/)。
