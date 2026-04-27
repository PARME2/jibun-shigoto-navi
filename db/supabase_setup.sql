-- ===== ジブン×シゴト ナビ 本番スキーマ =====
-- 前提:
--   1. Authentication > Providers > Anonymous Sign-Ins を有効化しておくこと
--   2. クライアントは sb.auth.signInAnonymously() でセッション取得後にDB操作を行う
--   3. users.id は auth.users.id（= auth.uid()）と一致させて RLS で参照する

-- ===== テーブル =====

create table if not exists users (
  id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz default now(),
  completed boolean default false,
  current_question int default 0,
  school text                            -- 学校コード（生値で保存。タイポも残す）
);

create table if not exists answers (
  id bigint generated always as identity primary key,
  user_id uuid not null references users(id) on delete cascade,
  question_num int not null,
  choice_index int,
  choice_short text,
  tags text[],
  axis text,
  branch text,
  subtype text,
  role text,
  created_at timestamptz default now(),
  unique(user_id, question_num)
);

create table if not exists results (
  id bigint generated always as identity primary key,
  user_id uuid not null references users(id) on delete cascade unique,
  top_branches text[] not null,
  subtype_text text,
  branch_counts jsonb,
  created_at timestamptz default now()
);

create table if not exists planned_visits (
  id bigint generated always as identity primary key,
  user_id uuid not null references users(id) on delete cascade,
  company_id int not null,
  created_at timestamptz default now(),
  unique(user_id, company_id)
);

-- ===== Row Level Security =====
-- 自分のレコードのみ select / insert / update / delete 可

alter table users           enable row level security;
alter table answers         enable row level security;
alter table results         enable row level security;
alter table planned_visits  enable row level security;

create policy "users_own"
  on users
  using       (auth.uid() = id)
  with check  (auth.uid() = id);

create policy "answers_own"
  on answers
  using       (auth.uid() = user_id)
  with check  (auth.uid() = user_id);

create policy "results_own"
  on results
  using       (auth.uid() = user_id)
  with check  (auth.uid() = user_id);

create policy "planned_own"
  on planned_visits
  using       (auth.uid() = user_id)
  with check  (auth.uid() = user_id);

-- ===== インデックス =====

create index if not exists idx_answers_user    on answers(user_id);
create index if not exists idx_results_user    on results(user_id);
create index if not exists idx_planned_user    on planned_visits(user_id);
create index if not exists idx_planned_company on planned_visits(company_id);
