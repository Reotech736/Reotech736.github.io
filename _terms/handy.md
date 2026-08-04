---
title: "Handy"
slug: "handy"
sort_key: "handy"
summary: "端末内の音声認識結果をフォーカス中の入力欄へ貼り付けるオープンソースの音声入力アプリ"
category: "ai"
aliases: ["Handy Speech-to-Text"]
updated: 2026-08-04
---

## 一言でいうと
端末内で音声を文字へ変換し、フォーカス中の入力欄へ貼り付けるオープンソースの音声入力アプリ。

## より具体的には
グローバルショートカットから録音を開始し、音声区間の検出と[自動音声認識（ASR）](/terms/automatic-speech-recognition/)を実行して、結果をブラウザー、エディター、チャットなどの入力欄へ貼り付ける。対応モデルを端末上で実行できるため、通常の文字起こしをローカルで完結できる。

後処理プロバイダーを設定すると、文字起こし結果を外部の文章処理へ渡してから貼り付ける構成も作れる。録音や文字起こしの保存、後処理先の通信範囲は、利用する設定とプロバイダーに応じて確認する必要がある。

## 関連記事での使用例

### [HandyとローカルLLMで音声入力環境を構築しようとした話](/2026/08/04/handy-local-llm-voice-input.html)
この記事では、Handyへ[OpenAI互換API](/terms/openai-compatible-api/)による文章整形を追加して実測した。整形の待ち時間と品質が日常利用の基準を満たさなかったため、Handyの文字起こしを直接使う経路を既定にした。

## 関連
- [自動音声認識（ASR）](/terms/automatic-speech-recognition/)
- [ローカルLLM](/terms/local-llm/)
- [OpenAI互換API](/terms/openai-compatible-api/)
