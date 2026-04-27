# ジブン×シゴト ナビ

中津市 企業合同就職説明会向けの自己分析×企業ナビ Webアプリ。
7つの質問に答えると6タイプの強みが判定され、参加企業60社の中から相性の良いブースを推薦する。

公開URL: https://jibun-shigoto-navi.vercel.app/

---

## 学校別配布URL

学校コードを `?s=` パラメータで付与してアクセスする。回答データは Supabase の `users.school` カラムにそのまま保存される。

| 学校 | 配布URL |
|---|---|
| 東九州龍谷高等学校 | https://jibun-shigoto-navi.vercel.app/?s=hk-ryukoku |
| 大分県立宇佐産業科学高等学校 | https://jibun-shigoto-navi.vercel.app/?s=usa-sangyo |
| 大分県立中津南高等学校耶馬溪校 | https://jibun-shigoto-navi.vercel.app/?s=nakatsuminami-yabakei |
| 大分県立中津北高等学校 | https://jibun-shigoto-navi.vercel.app/?s=nakatsukita |
| 大分県立安心院高等学校 | https://jibun-shigoto-navi.vercel.app/?s=ajimu |
| 大分県立高田高等学校 | https://jibun-shigoto-navi.vercel.app/?s=takada |

学校コード→正式名のマッピングは `index.html` 内の `SCHOOL_MAP` で管理。
未知のコードや空の場合も生値のまま保存する（後から推測で振り分け可能にするため）。

---

## ディレクトリ構成

```
.
├── index.html          メインアプリ（プレースホルダー入り）
├── images/             企業画像 60枚
├── archive/            別用途で作成した派生版を保管
├── db/                 Supabase スキーマ
│   ├── supabase_setup.sql
│   └── supabase_add_interest.sql
├── build.sh            ビルドスクリプト（プレースホルダー置換）
├── vercel.json         Vercel 設定
├── .env.local.example  ローカル開発用テンプレート
└── .gitignore
```

---

## 環境変数

`index.html` 内の Supabase 接続情報はビルド時に環境変数から注入する。

| 変数名 | 用途 |
|---|---|
| `SUPABASE_URL` | Supabase プロジェクトURL |
| `SUPABASE_KEY` | Supabase anon key（クライアント公開キー） |

### Vercel での設定
Project Settings > Environment Variables で上記2つを Production / Preview / Development すべてに設定する。

### ローカルビルド
```bash
cp .env.local.example .env.local
# .env.local を編集して実値を入れる

set -a
source .env.local
set +a

bash build.sh
# dist/index.html にプレースホルダー置換済みのHTMLが出力される
```

---

## デプロイ

GitHub `main` ブランチへの push で Vercel が自動デプロイする。
ビルドコマンド `bash build.sh` がプレースホルダーを置換し、`dist/` 配下を公開する。

---

## Supabase スキーマ

`db/supabase_setup.sql` と `db/supabase_add_interest.sql` を順に Supabase SQL Editor で実行する。
テーブル: `users` / `answers` / `results` / `planned_visits`
