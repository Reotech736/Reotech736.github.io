---
title: "ローカルLLM"
slug: "local-llm"
sort_key: "ろーかるえるえるえむ"
summary: "クラウドAPIではなく手元の端末や管理下の環境で実行する大規模言語モデル"
category: "ai"
aliases: ["Local LLM"]
updated: 2026-08-04
---

## 一言でいうと
クラウドAPIではなく、手元の端末や管理下の環境で実行する大規模言語モデル。

## より具体的には
モデルの重みと推論ランタイムをローカル環境へ配置し、入力と生成処理をその環境内で完結させる。外部サービスへ入力を送らずに使える一方、モデルの保存領域、メモリ、計算性能、更新、アクセス制御を利用者側で管理する必要がある。

応答速度と品質は、モデルの規模や量子化、CPU・GPU、推論ランタイム、入力長などによって変わる。用途に対して十分な性能があるかは、実際の入力と処理経路で評価することが重要になる。

## 関連記事での使用例

### [HandyとローカルLLMで音声入力環境を構築しようとした話](/2026/08/04/handy-local-llm-voice-input.html)
この記事では、Windows上の[Ollama](/terms/ollama/)でQwen3 8Bを実行し、音声認識後の文章整形に利用した。構成は成立したが、固定評価の速度と品質を基に日常の既定経路への採用を保留した。

## 関連
- [Ollama](/terms/ollama/)
- [Vulkan](/terms/vulkan/)
- [OpenAI互換API](/terms/openai-compatible-api/)
- [自動音声認識（ASR）](/terms/automatic-speech-recognition/)
