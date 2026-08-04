---
title: "Ollama"
slug: "ollama"
sort_key: "ollama"
summary: "ローカル環境でAIモデルを取得・実行し、推論APIとして利用できるランタイム"
category: "ai"
updated: 2026-08-04
---

## 一言でいうと
ローカル環境でAIモデルを取得・実行し、アプリから呼び出せる推論APIを提供するランタイム。

## より具体的には
対応するモデルの取得、保存、ロード、推論をまとめて扱い、HTTP APIやコマンドラインから利用できる。Ollama自体が一つのLLMなのではなく、用途に応じて選んだモデルを実行するためのソフトウェアである。

Windows、macOS、Linuxで利用でき、環境に応じてCPUやGPUによる推論を行う。利用可能なアクセラレーション、メモリ使用量、応答速度は、OS、ハードウェア、ドライバー、モデルによって異なる。

## 関連記事での使用例

### [HandyとローカルLLMで音声入力環境を構築しようとした話](/2026/08/04/handy-local-llm-voice-input.html)
この記事では、Windows上のOllamaでQwen3 8Bと14Bを比較し、Radeon 780Mの[Vulkan](/terms/vulkan/)経路で8Bモデルを文章整形に利用した。

## 関連
- [ローカルLLM](/terms/local-llm/)
- [Vulkan](/terms/vulkan/)
- [OpenAI互換API](/terms/openai-compatible-api/)
