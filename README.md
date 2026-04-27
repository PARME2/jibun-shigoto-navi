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
├── index.html          メインアプリ
├── images/             企業画像 60枚
├── archive/            別用途で作成した派生版を保管
├── db/                 Supabase スキーマ
│   ├── supabase_setup.sql
│   └── supabase_add_interest.sql
├── package.json
├── vercel.json
└── .gitignore
```

---

## デプロイ

GitHub `main` ブランチへの push で以下が自動反映される。

- **Vercel**: `https://jibun-shigoto-navi.vercel.app/`
- **GitHub Pages**: `https://parme2.github.io/jibun-shigoto-navi/`

純粋な静的サイト構成のためビルドステップは無い。`vercel.json` は `cleanUrls: true` のみ。

---

## Supabase スキーマ

`db/supabase_setup.sql` と `db/supabase_add_interest.sql` を順に Supabase SQL Editor で実行する。
テーブル: `users` / `answers` / `results` / `planned_visits` / `actual_visits`

### ⚠ セキュリティ上の既知課題

現状の RLS ポリシーはすべて `using (true)` で実質「全許可」状態。
anon key を持つ任意のクライアントから他ユーザーのデータが SELECT / UPDATE 可能。
匿名認証 (`auth.signInAnonymously`) 導入と RLS ポリシー書き直しが今後の課題。
