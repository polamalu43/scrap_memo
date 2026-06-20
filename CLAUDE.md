■ アプリ名
● Scrap Memo

■ 環境
● Android

■ アプリ概要
● Slackの自分宛DMだけを切り出したような超軽量メモアプリ

    ● 思いついたことを即座に記録できることを最優先とする

    ● 入力時に構造化や分類を強制しない

    ● 後から検索やスレッドで思考を掘り返せるようにする

■ コンセプト

    ● アプリ起動から入力・保存までの摩擦を極限まで減らす

    ● 思いついた内容をそのまま即書き込める

    ● Slackの自分DMのような「思考の投げ捨て場」を作る

    ● 後から辿れることを前提に、整理は後回しにする

    ● 見返したいものだけをピン留めできる

■ やらないこと

    ● 会員登録

    ● メール認証

    ● SNSログイン

    ● AI要約

    ● 通知機能

    ● チャット機能

    ● リアルタイム同期

    ● クラウド同期

    ● フォルダ機能

    ● コレクション機能

    ● タグ機能

    ● 共有機能

    ● ユーザー管理

■ 主要機能

    ● メモ

        # 入力欄は常時表示する

        # アプリ起動直後から即入力可能にする

        # 最短操作で保存できるようにする（1アクション保存）

        # 保存されたメモは時系列タイムラインに追加される

    ● スレッド

        # 各メモに対して補足・思考の続きとして追加できる

        # SlackのスレッドUIを踏襲する

        # メモを起点に思考の流れを保持するための機能

    ● 検索

        # メモとスレッドを対象に全文検索を行う（LIKEベース）

        # 過去の思考を素早く再発見できるようにする

    ● ピン留め

        # 後で必ず見返したいメモを固定表示する

        # ホーム画面上部に表示する

■ 画面構成

    ● ホーム画面（メインタイムライン）

        # インライン検索バー（最上部常駐・リアルタイムフィルタ）

        # ピン留めメモ一覧（横スクロール表示）

        # 通常メモのタイムライン（新着順・下から上に積み上げ）

        # メモ入力欄（最下部固定・常時表示・起動時自動フォーカス）

    ● スレッド表示（右側サイドドロワー / 画面遷移なし）

        # メモ本文（親要素固定）

        # スレッド一覧（思考の連鎖）

        # スレッド投稿欄（シート最下部固定）

■ データベース設計（ローカルSQLite）

    ● memos

        # id INTEGER PRIMARY KEY AUTOINCREMENT

        # content TEXT NOT NULL

        # is_pinned INTEGER NOT NULL DEFAULT 0

        # created_at DATETIME NOT NULL

        # updated_at DATETIME NOT NULL

    ● additions

        # id INTEGER PRIMARY KEY AUTOINCREMENT

        # memo_id INTEGER NOT NULL

        # content TEXT NOT NULL

        # created_at DATETIME NOT NULL

        # updated_at DATETIME NOT NULL

■ インデックス設計

    ● memos

        # idx_memos_created_at (created_at DESC)

        # idx_memos_pinned_created_at (is_pinned, created_at DESC)

    ● additions

        # idx_additions_memo_id (memo_id)

        # idx_additions_memo_id_created_at (memo_id, created_at ASC)

■ 全文検索

    ● SQLite LIKE検索を使用する（FTS5は採用しない）

    ● メモ本文とスレッド本文を対象とする

■ 技術スタック

    ● Flutter

        # UIフレームワーク

    ● Riverpod

        # 状態管理

    ● Drift

        # SQLite ORM

    ● SQLite

        # ローカルデータストア（完全オフライン）

■ 開発ルール

    ● コード生成には build_runner を使用する: `flutter pub run build_runner build --delete-conflicting-outputs`

    ● パッケージ追加時は、互換性を保つため `flutter pub add` を使用する

■ アーキテクチャ

    ● UI（画面）
    　# 表示とユーザー操作のみを担当
    　# ロジックを持たない

    ● Provider（状態管理）
    　# 画面状態とアプリのユースケースを管理する
    　# ただしDBアクセスは直接行わずRepository経由にする
    　# ビジネスロジックはここに集約する
    　# 責務は機能単位で分割し、肥大化を防ぐ

    ● Repository（データ仲介層）
        # ProviderとDriftの間に立ち、データの取得・保存の窓口となるクラス
        # UIやProviderがDriftの生コードに依存するのを防ぐ
      　# ビジネスロジックは持たず、データ変換と取得のみに責務を限定する

    ● Drift（データ層）
    　# SQLite操作のみを担当する
    　# CRUD以外のロジックを持たない

    ● 責務分離を厳守し、UI・Provider・Repository・DBの境界を崩さない

■ MVP開発順序

    ● Phase1

        # Flutterプロジェクト作成

        # memosテーブル作成

        # メモ投稿機能

        # メモ一覧表示

    ● Phase2

        # 追記機能追加

        # 追記投稿・一覧表示

    ● Phase3

        # ピン留め機能実装

        # ホーム画面反映

    ● Phase4

        # LIKE検索導入

        # 検索画面実装

    ● Phase5

        # UI改善

        # 入力体験の最適化

■ 重要な設計方針

    ● 機能追加よりも入力体験（摩擦の少なさ）を最優先とする

    ● 入力時に分類・整理を強制しない

    ● 思考の流れはスレッドで保持する

    ● すべてのデータはローカル完結（オフライン前提）

    ● 同期・ユーザー管理は一切行わない

    ● Slackの自分DMのような「思考のログ体験」を目指す
