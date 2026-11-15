-- Freight Desk: initial schema.
-- All timestamps are timestamptz (UTC); calendar dates are date.
-- Money columns are numeric(12,2) USD.

-- ---------------------------------------------------------------------------
-- Master data
-- ---------------------------------------------------------------------------

create table public.agents (
  id            uuid primary key default gen_random_uuid(),
  company       text not null,
  contact_name  text,
  email         text not null,
  cc_emails     text[] not null default '{}',
  ports         text[] not null default '{}',
  email_rules   text,
  wechat        text,
  notes         text,
  -- true for our own operations department
  is_internal   boolean not null default false,
  created_at    timestamptz not null default now()
);

create table public.clients (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  contact_name  text,
  whatsapp      text,
  email         text,
  notes         text,
  created_at    timestamptz not null default now()
);

create table public.suppliers (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  contact_name  text,
  email         text,
  wechat        text,
  city          text,
  created_at    timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Email (created early: inquiry_rates, shipment_events, documents and
-- suggested_updates reference it)
-- ---------------------------------------------------------------------------

create table public.email_messages (
  id                uuid primary key default gen_random_uuid(),
  graph_message_id  text not null unique,
  conversation_id   text,
  direction         text not null check (direction in ('in', 'out')),
  from_email        text,
  to_emails         text[] not null default '{}',
  cc_emails         text[] not null default '{}',
  subject           text,
  body_preview      text,
  body_html         text,
  received_at       timestamptz,
  has_attachments   boolean not null default false,
  -- Polymorphic link: no FK. Both set or both null.
  linked_type       text check (linked_type in ('inquiry', 'shipment')),
  linked_id         uuid,
  -- How the link was made (matching order in CLAUDE.md, plus manual).
  match_method      text check (match_method in ('ref', 'booking_no', 'container_no', 'conversation_id', 'manual')),
  created_at        timestamptz not null default now(),
  constraint email_messages_link_pair check ((linked_type is null) = (linked_id is null))
);

create index email_messages_conversation_id_idx on public.email_messages (conversation_id);
create index email_messages_linked_idx on public.email_messages (linked_type, linked_id);
create index email_messages_received_at_idx on public.email_messages (received_at desc);

-- ---------------------------------------------------------------------------
-- Inquiries
-- ---------------------------------------------------------------------------

create table public.inquiries (
  id                uuid primary key default gen_random_uuid(),
  ref               text not null unique,
  client_id         uuid not null references public.clients (id) on delete restrict,
  raw_message       text,
  pol               text,
  pod               text,
  container_type    text,
  container_qty     int check (container_qty > 0),
  commodity         text,
  weight_kg         numeric check (weight_kg >= 0),
  ready_date        date,
  incoterm          text,
  status            text not null default 'new'
                    check (status in ('new', 'rates_requested', 'quoted', 'approved', 'lost')),
  selected_rate_id  uuid,  -- FK added after inquiry_rates exists
  margin_usd        numeric(12,2),
  created_at        timestamptz not null default now()
);

create index inquiries_client_id_idx on public.inquiries (client_id);
create index inquiries_status_idx on public.inquiries (status);

create table public.inquiry_rates (
  id                 uuid primary key default gen_random_uuid(),
  inquiry_id         uuid not null references public.inquiries (id) on delete cascade,
  agent_id           uuid not null references public.agents (id) on delete restrict,
  status             text not null default 'requested'
                     check (status in ('requested', 'received', 'declined')),
  requested_at       timestamptz,
  received_at        timestamptz,
  freight_usd        numeric(12,2),
  local_charges_usd  numeric(12,2),
  transit_days       int check (transit_days >= 0),
  free_days          int check (free_days >= 0),
  valid_until        date,
  notes              text,
  source_email_id    uuid references public.email_messages (id) on delete set null,
  created_at         timestamptz not null default now(),
  -- One rate request per agent per inquiry.
  unique (inquiry_id, agent_id)
);

create index inquiry_rates_agent_id_idx on public.inquiry_rates (agent_id);

alter table public.inquiries
  add constraint inquiries_selected_rate_id_fkey
  foreign key (selected_rate_id) references public.inquiry_rates (id) on delete set null;

-- ---------------------------------------------------------------------------
-- Shipments
-- ---------------------------------------------------------------------------

create table public.shipments (
  id              uuid primary key default gen_random_uuid(),
  ref             text not null unique,
  inquiry_id      uuid references public.inquiries (id) on delete set null,
  client_id       uuid not null references public.clients (id) on delete restrict,
  agent_id        uuid references public.agents (id) on delete restrict,
  supplier_id     uuid references public.suppliers (id) on delete set null,
  pol             text,
  pod             text,
  container_type  text,
  container_qty   int check (container_qty > 0),
  booking_no      text,
  shipping_line   text,
  vessel          text,
  voyage          text,
  container_no    text,
  seal_no         text,
  stuffing_date   date,
  etd             date,
  eta             date,
  stage           text not null default 'approved' check (stage in (
                    'approved',
                    'supplier_details',
                    'awaiting_booking',
                    'booking_released',
                    'loading_plan',
                    'drafts_pre_stuffing',
                    'stuffing_day',
                    'final_drafts',
                    'awaiting_sailing',
                    'pre_alerts',
                    'awaiting_release',
                    'closed'
                  )),
  release_type    text check (release_type in ('telex', 'surrender', 'swb', 'courier')),
  closed_at       timestamptz,
  created_at      timestamptz not null default now()
);

create index shipments_booking_no_idx on public.shipments (booking_no);
create index shipments_container_no_idx on public.shipments (container_no);
create index shipments_stage_idx on public.shipments (stage);
create index shipments_inquiry_id_idx on public.shipments (inquiry_id);
create index shipments_client_id_idx on public.shipments (client_id);
create index shipments_agent_id_idx on public.shipments (agent_id);
create index shipments_supplier_id_idx on public.shipments (supplier_id);

create table public.shipment_events (
  id           uuid primary key default gen_random_uuid(),
  shipment_id  uuid not null references public.shipments (id) on delete cascade,
  occurred_at  timestamptz not null default now(),
  actor        text not null check (actor in ('system', 'user', 'agent', 'client', 'supplier')),
  channel      text not null check (channel in ('email', 'whatsapp', 'wechat', 'system')),
  title        text not null,
  detail       text,
  email_id     uuid references public.email_messages (id) on delete set null,
  created_at   timestamptz not null default now()
);

create index shipment_events_shipment_id_idx on public.shipment_events (shipment_id, occurred_at desc);

create table public.documents (
  id                   uuid primary key default gen_random_uuid(),
  shipment_id          uuid not null references public.shipments (id) on delete cascade,
  kind                 text not null check (kind in (
                         'so', 'hbl_draft', 'mbl_draft', 'hbl_final', 'mbl_final',
                         'pre_alert', 'release', 'other'
                       )),
  version              int not null default 1 check (version > 0),
  file_name            text not null,
  source               text not null check (source in ('outlook_attachment', 'upload')),
  graph_message_id     text,
  graph_attachment_id  text,
  storage_path         text,
  received_at          timestamptz,
  extracted            jsonb,
  created_at           timestamptz not null default now()
);

create index documents_shipment_id_idx on public.documents (shipment_id, kind);

create table public.suggested_updates (
  id           uuid primary key default gen_random_uuid(),
  shipment_id  uuid not null references public.shipments (id) on delete cascade,
  email_id     uuid references public.email_messages (id) on delete set null,
  field        text not null,
  old_value    text,
  new_value    text,
  status       text not null default 'pending' check (status in ('pending', 'accepted', 'rejected')),
  created_at   timestamptz not null default now()
);

create index suggested_updates_shipment_id_idx on public.suggested_updates (shipment_id, status);

-- ---------------------------------------------------------------------------
-- Drafts and templates
-- ---------------------------------------------------------------------------

create table public.drafts (
  id                         uuid primary key default gen_random_uuid(),
  -- Polymorphic link: no FK.
  linked_type                text not null check (linked_type in ('inquiry', 'shipment')),
  linked_id                  uuid not null,
  draft_type                 text not null,
  reason                     text,
  channel                    text not null check (channel in ('email', 'whatsapp')),
  to_emails                  text[] not null default '{}',
  cc_emails                  text[] not null default '{}',
  subject                    text,
  body                       text not null default '',
  status                     text not null default 'pending'
                             check (status in ('pending', 'sent', 'skipped', 'failed')),
  reply_to_graph_message_id  text,
  created_by                 text not null default 'system' check (created_by in ('system', 'user')),
  sent_at                    timestamptz,
  error                      text,
  created_at                 timestamptz not null default now()
);

create index drafts_status_idx on public.drafts (status);
create index drafts_linked_idx on public.drafts (linked_type, linked_id);

create table public.templates (
  id                uuid primary key default gen_random_uuid(),
  key               text not null unique,
  name              text not null,
  channel           text not null check (channel in ('email', 'whatsapp')),
  subject_template  text,
  body_template     text not null,
  notes             text,
  created_at        timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Single-row tables. `singleton` is always true and unique, so a second row
-- can't be inserted.
-- ---------------------------------------------------------------------------

create table public.settings (
  id                               uuid primary key default gen_random_uuid(),
  singleton                        boolean not null default true unique check (singleton),
  ops_email                        text,
  default_margin_usd               numeric(12,2),
  followup_after_days              int not null default 2 check (followup_after_days > 0),
  release_request_days_before_eta  int not null default 12 check (release_request_days_before_eta > 0),
  signature                        text,
  created_at                       timestamptz not null default now()
);

-- The app always updates this row; it never inserts one.
insert into public.settings default values;

create table public.ms_connection (
  id                       uuid primary key default gen_random_uuid(),
  singleton                boolean not null default true unique check (singleton),
  account_email            text not null,
  -- Encrypted with TOKEN_ENCRYPTION_KEY before it reaches the database.
  encrypted_refresh_token  text not null,
  token_expires_at         timestamptz,
  delta_link               text,
  created_at               timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Access: authenticated users get full access; anon gets nothing.
-- Grants are explicit so this doesn't depend on the project's auto-expose
-- setting. ms_connection is handled separately below.
-- ---------------------------------------------------------------------------

do $$
declare
  t text;
begin
  foreach t in array array[
    'agents', 'clients', 'suppliers', 'email_messages', 'inquiries',
    'inquiry_rates', 'shipments', 'shipment_events', 'documents',
    'suggested_updates', 'drafts', 'templates', 'settings'
  ]
  loop
    execute format('alter table public.%I enable row level security', t);
    execute format('revoke all on public.%I from anon', t);
    execute format('grant select, insert, update, delete on public.%I to authenticated, service_role', t);
    execute format(
      'create policy "authenticated full access" on public.%I
         for all to authenticated using (true) with check (true)',
      t
    );
  end loop;
end
$$;

-- ms_connection holds the (encrypted) Graph refresh token. Server only:
-- RLS on with no policies, and no grants to anon or authenticated, so only
-- the service role (secret key) can read or write it.
alter table public.ms_connection enable row level security;
revoke all on public.ms_connection from anon, authenticated;
grant select, insert, update, delete on public.ms_connection to service_role;
