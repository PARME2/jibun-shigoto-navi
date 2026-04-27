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

## Supabase 構成

匿名認証 (`auth.signInAnonymously`) で取得した `auth.uid()` を `users.id` に紐付け、
RLS ポリシーで「自分のレコードのみ操作可」を強制している。anon key が公開されても
他ユーザーのデータは触れない。

### 新規プロジェクトのセットアップ手順

1. Supabase Dashboard で新プロジェクト作成（リージョンは Tokyo 推奨）
2. **Authentication > Providers > Anonymous Sign-Ins を有効化**（必須）
3. SQL Editor で `db/supabase_setup.sql` を実行
4. Settings > API から `Project URL` と `anon public key` を取得
5. `index.html` の `SUPABASE_URL` / `SUPABASE_KEY` を新値に置換 → push

### テーブル

`users` / `answers` / `results` / `planned_visits`

### dev / prod 分離

無料枠で2プロジェクトまで作成可。本番ドメインから参照するキーは prod プロジェクトのもの、
ローカル動作確認・スキーマ実験は dev プロジェクトで行う。
