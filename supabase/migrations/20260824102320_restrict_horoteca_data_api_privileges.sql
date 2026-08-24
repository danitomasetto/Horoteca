-- The Data API needs CRUD only. Schema/trigger/truncate privileges are denied.

revoke all privileges on
  public.watches,
  public.maintenance_logs,
  public.brands,
  public.watch_photos,
  public.watch_models,
  public.movement_calibers,
  public.acquisitions,
  public.acquisition_items,
  public.expenses,
  public.expense_allocations,
  public.watch_events,
  public.watch_sources,
  public.watch_photo_links
from anon, authenticated;

grant select, insert, update, delete on
  public.watches,
  public.maintenance_logs,
  public.brands,
  public.watch_photos,
  public.watch_models,
  public.movement_calibers,
  public.acquisitions,
  public.acquisition_items,
  public.expenses,
  public.expense_allocations,
  public.watch_events,
  public.watch_sources,
  public.watch_photo_links
to authenticated;

revoke all privileges on all sequences in schema public from anon;
grant usage, select on all sequences in schema public to authenticated;
