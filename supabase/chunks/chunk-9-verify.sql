select
  (select count(*) from public.accounts) as accounts,
  (select count(*) from public.baselines where active) as active_baselines,
  (select count(*) from public.baselines where active and verdict='PURSUE') as pursue,
  (select count(*) from public.baselines where active and verdict='QUALIFY') as qualify,
  (select count(*) from public.baselines where active and verdict='WATCH') as watch;
