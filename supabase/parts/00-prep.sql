insert into public.accounts (slug, name, full_name, relationship, sector, is_public, cadence, next_report)
values ('nsc','Norfolk Southern','Norfolk Southern Corporation (NYSE: NSC)','prospect','Rail',true,'quarterly-earnings','2026-10-22')
on conflict (slug) do nothing;

update public.accounts
set full_name='FedEx Freight Holding Company, Inc. (NYSE: FDXF)', is_public=true,
    cadence='transition-period', next_report='2027-02-15'
where slug='fedex-frt';

update public.accounts set next_report='2026-11-18' where slug='expd';

update public.baselines set active=false;

select
  (select count(*) from public.accounts) as accounts,
  (select count(*) from public.baselines where active) as active_baselines,
  (select count(*) from public.baselines where active and verdict='PURSUE') as pursue,
  (select count(*) from public.baselines where active and verdict='QUALIFY') as qualify,
  (select count(*) from public.baselines where active and verdict='WATCH') as watch;
