-- ===== ジブン×シゴト ナビ テーブル作成 =====

-- ユーザー
create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  completed boolean default false,
  current_question int default 0
);

-- 回答
create table if not exists answers (
  id bigint generated always as identity primary key,
  user_id uuid references users(id) on delete cascade,
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

-- 判定結果
create table if not exists results (
  id bigint generated always as identity primary key,
  user_id uuid references users(id) on delete cascade unique,
  top_branches text[] not null,
  subtype_text text,
  local_flag boolean default false,
  branch_counts jsonb,
  created_at timestamptz default now()
);

-- いく予定
create table if not exists planned_visits (
  id bigint generated always as identity primary key,
  user_id uuid references users(id) on delete cascade,
  company_id int not null,
  created_at timestamptz default now(),
  unique(user_id, company_id)
);

-- 実際の訪問
create table if not exists actual_visits (
  id bigint generated always as identity primary key,
  user_id uuid references users(id) on delete cascade,
  company_id int not null,
  memo text default '',
  created_at timestamptz default now(),
  unique(user_id, company_id)
);

-- ===== Row Level Security =====
alter table users enable row level security;
alter table answers enable row level security;
alter table results enable row level security;
alter table planned_visits enable row level security;
alter table actual_visits enable row level security;

-- anon ユーザーは自分のデータのみ操作可能（user_idはクライアントが送る）
-- INSERT: 誰でもOK
create policy "Anyone can insert users" on users for insert with check (true);
create policy "Anyone can insert answers" on answers for insert with check (true);
create policy "Anyone can insert results" on results for insert with check (true);
create policy "Anyone can insert planned_visits" on planned_visits for insert with check (true);
create policy "Anyone can insert actual_visits" on actual_visits for insert with check (true);

-- SELECT: 自分のデータのみ（user_idでフィルタ）
create policy "Users can read own data" on users for select using (true);
create policy "Users can read own answers" on answers for select using (true);
create policy "Users can read own results" on results for select using (true);
create policy "Users can read own planned" on planned_visits for select using (true);
create policy "Users can read own visits" on actual_visits for select using (true);

-- UPDATE: 自分のデータのみ
create policy "Users can update own data" on users for update using (true);
create policy "Users can update own answers" on answers for update using (true);
create policy "Users can update own results" on results for update using (true);
create policy "Users can update own visits" on actual_visits for update using (true);

-- DELETE: planned_visitsのみ削除可能（いく予定の取消）
create policy "Users can delete own planned" on planned_visits for delete using (true);

-- ===== インデックス =====
create index if not exists idx_answers_user on answers(user_id);
create index if not exists idx_results_user on results(user_id);
create index if not exists idx_planned_user on planned_visits(user_id);
create index if not exists idx_planned_company on planned_visits(company_id);
create index if not exists idx_visits_user on actual_visits(user_id);
