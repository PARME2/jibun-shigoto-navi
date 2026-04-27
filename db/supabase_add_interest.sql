-- actual_visits テーブルに興味度カラムを追加
alter table actual_visits add column if not exists interest_level text;
