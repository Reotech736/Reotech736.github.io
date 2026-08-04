---
title: "OpenAI互換API"
slug: "openai-compatible-api"
sort_key: "openaiごかんえーぴーあい"
summary: "OpenAI APIの一部と同様のエンドポイントやデータ形式を使うAPI"
category: "ai"
aliases: ["OpenAI-compatible API"]
updated: 2026-08-04
---

## 一言でいうと
OpenAI APIの一部と同様のエンドポイントやデータ形式を使い、既存クライアントから接続しやすくしたAPI。

## より具体的には
Chat Completionsなどの要求・応答形式に合わせることで、クライアント側の接続先やモデル名を変更して、異なる推論サービスを利用できるようにする。ローカルLLMランタイムや独自の中継サービスが、この形式を採用することがある。

「互換」がAPI全体の完全な実装を意味するとは限らない。ストリーミング、画像、tool calling、structured outputなど、対応するエンドポイントやフィールドの範囲は実装ごとに確認する必要がある。

## 関連記事での使用例

### [HandyとローカルLLMで音声入力環境を構築しようとした話](/2026/08/04/handy-local-llm-voice-input.html)
この記事では、[Handy](/terms/handy/)の後処理先としてlocalhostで最小限のOpenAI互換APIを提供し、選択したプロファイルに従って[Ollama](/terms/ollama/)へ文章整形を依頼した。

## 関連
- [Handy](/terms/handy/)
- [Ollama](/terms/ollama/)
- [ローカルLLM](/terms/local-llm/)
