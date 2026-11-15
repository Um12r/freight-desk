-- Freight Desk: dummy development data. Everything here is fictional.
--
-- Safe to re-run: it first deletes only the rows it owns (fixed UUIDs
-- starting 5eed0000-...), then inserts them again. Dates are relative to
-- current_date, so re-running also refreshes them to look current.
-- Leaves ms_connection alone and only updates the existing settings row.
--
-- Run against the linked remote project:
--   npx supabase db query --remote -f supabase/seed.sql
--
-- ID scheme: 5eed0000-0000-4000-8000-000000000NNN
--   1NN agents, 2NN clients, 3NN suppliers, 4NN inquiries,
--   5NN inquiry_rates, 6NN shipments. Events use generated ids and are
--   removed with their shipment (on delete cascade).

begin;

-- ---------------------------------------------------------------------------
-- Clean out previous seed rows. Children first; cascades remove
-- shipment_events, documents, suggested_updates and inquiry_rates.
-- ---------------------------------------------------------------------------

delete from public.shipments where id::text like '5eed0000-%';
-- Break the inquiries <-> inquiry_rates cycle before deleting.
update public.inquiries set selected_rate_id = null where id::text like '5eed0000-%';
delete from public.inquiries where id::text like '5eed0000-%';
delete from public.agents    where id::text like '5eed0000-%';
delete from public.clients   where id::text like '5eed0000-%';
delete from public.suppliers where id::text like '5eed0000-%';

-- ---------------------------------------------------------------------------
-- Agents
-- ---------------------------------------------------------------------------

insert into public.agents (id, company, contact_name, email, cc_emails, ports, email_rules, wechat, notes, is_internal) values
  ('5eed0000-0000-4000-8000-000000000101', 'Sunrise Logistics', 'Lily Chen',
   'lily.chen@sunrise-logistics.example', array['ops@sunrise-logistics.example'],
   array['Shanghai', 'Ningbo'],
   'Always cc ops@. Booking no. in the subject once known. Replies slow down around Chinese public holidays.',
   'lilychen_sunrise', 'Good on Ningbo rates. Usually first to reply.', false),

  ('5eed0000-0000-4000-8000-000000000102', 'Eastport Freight', 'Kevin Wang',
   'kevin.wang@eastport-freight.example', array['docs@eastport-freight.example'],
   array['Ningbo', 'Qingdao'],
   'Kevin handles rates and bookings; docs@ handles HBL/MBL. Approve drafts as a reply in the same thread.',
   'kevin_eastport', null, false),

  ('5eed0000-0000-4000-8000-000000000103', 'Harbor Link', 'Grace Liu',
   'grace.liu@harborlink.example', array['booking@harborlink.example', 'cs@harborlink.example'],
   array['Qingdao', 'Shanghai'],
   'One email per shipment, never combined updates. Rate validity usually runs to month end.',
   'graceliu_hl', 'Strong on Qingdao ceramics shipments.', false),

  ('5eed0000-0000-4000-8000-000000000104', 'Pacific Bridge', 'Jason Zhou',
   'jason.zhou@pacificbridge.example', array['pricing@pacificbridge.example'],
   array['Qingdao', 'Shanghai'],
   'Rates exclude locals unless stated. Always ask for free days explicitly.',
   'jasonzhou_pb', null, false),

  ('5eed0000-0000-4000-8000-000000000105', 'Operations department', 'Operations team',
   'operations@yourcompany.example', array[]::text[], array[]::text[],
   'Internal. Forward pre-alerts and release documents here with the shipment ref in the subject.',
   null, 'Our own operations department in Karachi.', true);

-- ---------------------------------------------------------------------------
-- Clients
-- ---------------------------------------------------------------------------

insert into public.clients (id, name, contact_name, whatsapp, email, notes) values
  ('5eed0000-0000-4000-8000-000000000201', 'Al-Noor Textiles', 'Imran Qureshi',
   '+92 300 5550101', 'imran@alnoor-textiles.example', 'Regular Ningbo shipments, fabric rolls.'),
  ('5eed0000-0000-4000-8000-000000000202', 'Indus Home Appliances', 'Saad Malik',
   '+92 321 5550102', 'saad.malik@indus-appliances.example', 'Price sensitive; compare at least 3 rates.'),
  ('5eed0000-0000-4000-8000-000000000203', 'Mehran Auto Parts', 'Bilal Siddiqui',
   '+92 333 5550103', 'bilal@mehran-autoparts.example', null),
  ('5eed0000-0000-4000-8000-000000000204', 'Ravi Ceramics', 'Ayesha Khan',
   '+92 345 5550104', 'ayesha.khan@ravi-ceramics.example', 'Heavy cargo; check weight limits on 20GP.'),
  ('5eed0000-0000-4000-8000-000000000205', 'Clifton Kitchenware', 'Hamza Sheikh',
   '+92 302 5550105', 'hamza@clifton-kitchenware.example', 'Prefers WhatsApp voice notes; confirm everything in text.');

-- ---------------------------------------------------------------------------
-- Suppliers
-- ---------------------------------------------------------------------------

insert into public.suppliers (id, name, contact_name, email, wechat, city) values
  ('5eed0000-0000-4000-8000-000000000301', 'Ningbo Hengda Textile Co.', 'Zhang Wei',
   'zhangwei@hengda-textile.example', 'zhangwei_hengda', 'Ningbo'),
  ('5eed0000-0000-4000-8000-000000000302', 'Zhejiang Ruifeng Auto Parts', 'Li Na',
   'lina@ruifeng-autoparts.example', 'lina_ruifeng', 'Taizhou'),
  ('5eed0000-0000-4000-8000-000000000303', 'Zibo Huaxin Ceramics', 'Wang Fang',
   'wangfang@huaxin-ceramics.example', 'wangfang_huaxin', 'Zibo'),
  ('5eed0000-0000-4000-8000-000000000304', 'Yiwu Mingyang Kitchenware', 'Chen Jie',
   'chenjie@mingyang-kitchen.example', 'chenjie_my', 'Yiwu'),
  ('5eed0000-0000-4000-8000-000000000305', 'Ningbo Aoke Electric Appliance', 'Liu Yang',
   'liuyang@aoke-electric.example', 'liuyang_aoke', 'Ningbo');

-- ---------------------------------------------------------------------------
-- Inquiries
-- ---------------------------------------------------------------------------

insert into public.inquiries (id, ref, client_id, raw_message, pol, pod, container_type, container_qty, commodity, weight_kg, ready_date, incoterm, status, margin_usd, created_at) values
  -- new: just pasted in, no rates requested yet
  ('5eed0000-0000-4000-8000-000000000401', 'INQ-2611-021', '5eed0000-0000-4000-8000-000000000205',
   E'Salam bhai, need rate 1x40HC Ningbo to Karachi. Kitchenware, approx 9.8 ton. Goods ready in 2 weeks, FOB. Please share best rate with free days.',
   'Ningbo', 'Karachi', '40HC', 1, 'Kitchenware (stainless steel pots and pans)', 9800,
   current_date + 14, 'FOB', 'new', null, now() - interval '3 hours'),

  -- rates_requested: one agent replied, two pending
  ('5eed0000-0000-4000-8000-000000000402', 'INQ-2611-019', '5eed0000-0000-4000-8000-000000000204',
   E'AoA. 2x20GP Qingdao to Karachi, ceramic floor tiles, around 21 ton per container. Ready ~10 days. FOB Qingdao. Need rates by tomorrow if possible.',
   'Qingdao', 'Karachi', '20GP', 2, 'Ceramic floor tiles', 42000,
   current_date + 10, 'FOB', 'rates_requested', null, current_date - 2 + time '06:40'),

  -- quoted: rates in, quote sent to client with margin
  ('5eed0000-0000-4000-8000-000000000403', 'INQ-2611-016', '5eed0000-0000-4000-8000-000000000202',
   E'Need rate for 1x40HC Shanghai to Karachi. Home appliances (microwaves, kettles), 11.5 ton. Ready end of next week. FOB.',
   'Shanghai', 'Karachi', '40HC', 1, 'Home appliances (microwaves, electric kettles)', 11500,
   current_date + 8, 'FOB', 'quoted', 150, current_date - 4 + time '05:15');

insert into public.inquiry_rates (id, inquiry_id, agent_id, status, requested_at, received_at, freight_usd, local_charges_usd, transit_days, free_days, valid_until, notes) values
  -- INQ-2611-019 (rates_requested)
  ('5eed0000-0000-4000-8000-000000000501', '5eed0000-0000-4000-8000-000000000402', '5eed0000-0000-4000-8000-000000000102',
   'received', current_date - 2 + time '07:05', current_date - 1 + time '03:30',
   1650, 240, 22, 14, current_date + 13, 'Per 20GP. Locals per container at origin. Max payload 26 t per box.'),
  ('5eed0000-0000-4000-8000-000000000502', '5eed0000-0000-4000-8000-000000000402', '5eed0000-0000-4000-8000-000000000103',
   'requested', current_date - 2 + time '07:05', null, null, null, null, null, null, null),
  ('5eed0000-0000-4000-8000-000000000503', '5eed0000-0000-4000-8000-000000000402', '5eed0000-0000-4000-8000-000000000104',
   'requested', current_date - 2 + time '07:05', null, null, null, null, null, null, null),

  -- INQ-2611-016 (quoted)
  ('5eed0000-0000-4000-8000-000000000504', '5eed0000-0000-4000-8000-000000000403', '5eed0000-0000-4000-8000-000000000101',
   'received', current_date - 4 + time '05:40', current_date - 3 + time '02:10',
   1185, 310, 20, 14, current_date + 11, 'Via direct service. Locals include THC, BL fee and seal.'),
  ('5eed0000-0000-4000-8000-000000000505', '5eed0000-0000-4000-8000-000000000403', '5eed0000-0000-4000-8000-000000000103',
   'received', current_date - 4 + time '05:40', current_date - 3 + time '06:55',
   1240, 285, 24, 10, current_date + 15, 'Transshipment via Colombo.'),
  ('5eed0000-0000-4000-8000-000000000506', '5eed0000-0000-4000-8000-000000000403', '5eed0000-0000-4000-8000-000000000104',
   'declined', current_date - 4 + time '05:40', current_date - 3 + time '04:20',
   null, null, null, null, null, 'No space on Shanghai-Karachi this month.');

update public.inquiries
  set selected_rate_id = '5eed0000-0000-4000-8000-000000000504'
  where id = '5eed0000-0000-4000-8000-000000000403';

-- ---------------------------------------------------------------------------
-- Shipments. Booking/vessel fields appear once the SO is in; container and
-- seal once stuffed. inquiry_id is left null (these predate the app).
-- ---------------------------------------------------------------------------

insert into public.shipments (id, ref, client_id, agent_id, supplier_id, pol, pod, container_type, container_qty,
                              booking_no, shipping_line, vessel, voyage, container_no, seal_no,
                              stuffing_date, etd, eta, stage, release_type, created_at) values
  -- 1 approved: nothing booked yet
  ('5eed0000-0000-4000-8000-000000000601', 'SHP-2611-052', '5eed0000-0000-4000-8000-000000000203', '5eed0000-0000-4000-8000-000000000102', '5eed0000-0000-4000-8000-000000000302',
   'Ningbo', 'Karachi', '20GP', 1,
   null, null, null, null, null, null,
   null, null, null, 'approved', null, current_date - 2 + time '06:30'),

  -- 3 awaiting_booking: supplier details forwarded, no SO yet
  ('5eed0000-0000-4000-8000-000000000602', 'SHP-2611-049', '5eed0000-0000-4000-8000-000000000201', '5eed0000-0000-4000-8000-000000000101', '5eed0000-0000-4000-8000-000000000301',
   'Ningbo', 'Karachi', '40HC', 1,
   null, null, null, null, null, null,
   null, null, null, 'awaiting_booking', null, current_date - 7 + time '05:00'),

  -- 5 loading_plan: SO in, stuffing confirmed for later this week
  ('5eed0000-0000-4000-8000-000000000603', 'SHP-2611-051', '5eed0000-0000-4000-8000-000000000204', '5eed0000-0000-4000-8000-000000000103', '5eed0000-0000-4000-8000-000000000303',
   'Qingdao', 'Karachi', '20GP', 2,
   'QDA2611233', 'Orient Star Shipping', 'Orient Pearl', '118W', null, null,
   current_date + 4, current_date + 9, current_date + 31, 'loading_plan', null, current_date - 12 + time '07:10'),

  -- 6 drafts_pre_stuffing: STUFFING TODAY
  ('5eed0000-0000-4000-8000-000000000604', 'SHP-2611-047', '5eed0000-0000-4000-8000-000000000202', '5eed0000-0000-4000-8000-000000000101', '5eed0000-0000-4000-8000-000000000305',
   'Ningbo', 'Karachi', '40HC', 1,
   'NGB2611318', 'Blue Meridian Lines', 'Meridian Harmony', '027W', null, null,
   current_date, current_date + 6, current_date + 27, 'drafts_pre_stuffing', null, current_date - 15 + time '06:00'),

  -- 8 final_drafts: stuffed, container known, HBL/MBL mismatch flagged
  ('5eed0000-0000-4000-8000-000000000605', 'SHP-2610-038', '5eed0000-0000-4000-8000-000000000205', '5eed0000-0000-4000-8000-000000000102', '5eed0000-0000-4000-8000-000000000304',
   'Ningbo', 'Karachi', '40HC', 1,
   'NGB2610876', 'Sea Crest Container Line', 'Sea Crest Valor', '046W', 'SCLU4417290', 'SC2210457',
   current_date - 2, current_date + 3, current_date + 25, 'final_drafts', null, current_date - 20 + time '05:45'),

  -- 9 awaiting_sailing: ETD TODAY
  ('5eed0000-0000-4000-8000-000000000606', 'SHP-2611-045', '5eed0000-0000-4000-8000-000000000201', '5eed0000-0000-4000-8000-000000000101', '5eed0000-0000-4000-8000-000000000301',
   'Ningbo', 'Karachi', '40HC', 1,
   'NGB2610912', 'Orient Star Shipping', 'Orient Jade', '121W', 'OSSU7731046', 'OS884213',
   current_date - 5, current_date, current_date + 21, 'awaiting_sailing', null, current_date - 22 + time '06:20'),

  -- 10 pre_alerts: sailed, pre-alerts just received
  ('5eed0000-0000-4000-8000-000000000607', 'SHP-2610-033', '5eed0000-0000-4000-8000-000000000203', '5eed0000-0000-4000-8000-000000000102', '5eed0000-0000-4000-8000-000000000302',
   'Ningbo', 'Karachi', '20GP', 1,
   'NGB2610644', 'Blue Meridian Lines', 'Meridian Grace', '019W', 'BMLU2290518', 'BM5530912',
   current_date - 10, current_date - 6, current_date + 16, 'pre_alerts', null, current_date - 25 + time '07:30'),

  -- 11 awaiting_release: ETA IN 12 DAYS, release type not decided yet
  ('5eed0000-0000-4000-8000-000000000608', 'SHP-2610-031', '5eed0000-0000-4000-8000-000000000204', '5eed0000-0000-4000-8000-000000000103', '5eed0000-0000-4000-8000-000000000303',
   'Qingdao', 'Karachi', '20GP', 1,
   'QDA2610507', 'Sea Crest Container Line', 'Sea Crest Horizon', '038W', 'SCLU6604183', 'SC1198320',
   current_date - 17, current_date - 14, current_date + 12, 'awaiting_release', null, current_date - 35 + time '05:50');

-- ---------------------------------------------------------------------------
-- Shipment events. Past days use fixed UTC times (Karachi = UTC+5); events
-- "today" use now() minus an interval so they're never in the future.
-- ---------------------------------------------------------------------------

insert into public.shipment_events (shipment_id, occurred_at, actor, channel, title, detail) values
  -- SHP-2611-052 approved
  ('5eed0000-0000-4000-8000-000000000601', current_date - 2 + time '06:20', 'client', 'whatsapp', 'Client approved quote',
   'Bilal confirmed USD 1,050 all-in for 1x20GP Ningbo -> Karachi.'),
  ('5eed0000-0000-4000-8000-000000000601', current_date - 2 + time '06:30', 'system', 'system', 'Shipment created',
   'Created from approved quote. Agent: Eastport Freight.'),
  ('5eed0000-0000-4000-8000-000000000601', now() - interval '1 hour', 'system', 'system', 'Draft ready: agent details for client',
   'WhatsApp text with Eastport Freight contact details, ready to copy.'),

  -- SHP-2611-049 awaiting_booking
  ('5eed0000-0000-4000-8000-000000000602', current_date - 7 + time '04:50', 'client', 'whatsapp', 'Client approved quote',
   'Imran approved USD 1,320 for 1x40HC Ningbo -> Karachi.'),
  ('5eed0000-0000-4000-8000-000000000602', current_date - 7 + time '05:00', 'system', 'system', 'Shipment created', null),
  ('5eed0000-0000-4000-8000-000000000602', current_date - 7 + time '05:25', 'user', 'whatsapp', 'Shared agent details with client', null),
  ('5eed0000-0000-4000-8000-000000000602', current_date - 6 + time '08:10', 'client', 'whatsapp', 'Client sent supplier details',
   'Ningbo Hengda Textile Co., contact Zhang Wei.'),
  ('5eed0000-0000-4000-8000-000000000602', current_date - 6 + time '08:40', 'user', 'email', 'Forwarded supplier details to agent', null),
  ('5eed0000-0000-4000-8000-000000000602', current_date - 5 + time '02:15', 'agent', 'email', 'Agent acknowledged, booking requested with line', null),
  ('5eed0000-0000-4000-8000-000000000602', current_date - 3 + time '05:30', 'user', 'email', 'Followed up agent for SO', 'No SO after 2 days.'),
  ('5eed0000-0000-4000-8000-000000000602', current_date - 1 + time '03:05', 'agent', 'wechat', 'Agent: space tight, SO expected soon',
   'Lily says the line is overbooked this week; expects SO within 1-2 days.'),

  -- SHP-2611-051 loading_plan
  ('5eed0000-0000-4000-8000-000000000603', current_date - 12 + time '07:00', 'client', 'whatsapp', 'Client approved quote', null),
  ('5eed0000-0000-4000-8000-000000000603', current_date - 11 + time '05:20', 'user', 'whatsapp', 'Shared agent details with client', null),
  ('5eed0000-0000-4000-8000-000000000603', current_date - 10 + time '06:45', 'user', 'email', 'Forwarded supplier details to agent',
   'Zibo Huaxin Ceramics, contact Wang Fang.'),
  ('5eed0000-0000-4000-8000-000000000603', current_date - 6 + time '02:30', 'agent', 'email', 'SO received: QDA2611233',
   'Orient Pearl 118W, ETD ' || to_char(current_date + 9, 'DD Mon') || '.'),
  ('5eed0000-0000-4000-8000-000000000603', current_date - 6 + time '04:00', 'user', 'email', 'Asked agent to confirm loading plan with supplier', null),
  ('5eed0000-0000-4000-8000-000000000603', current_date - 2 + time '03:15', 'supplier', 'wechat', 'Supplier confirmed stuffing date',
   'Stuffing on ' || to_char(current_date + 4, 'DD Mon') || ', both containers.'),

  -- SHP-2611-047 drafts_pre_stuffing (stuffing today)
  ('5eed0000-0000-4000-8000-000000000604', current_date - 15 + time '05:50', 'client', 'whatsapp', 'Client approved quote', null),
  ('5eed0000-0000-4000-8000-000000000604', current_date - 15 + time '06:15', 'user', 'whatsapp', 'Shared agent details with client', null),
  ('5eed0000-0000-4000-8000-000000000604', current_date - 14 + time '07:30', 'user', 'email', 'Forwarded supplier details to agent', null),
  ('5eed0000-0000-4000-8000-000000000604', current_date - 9 + time '02:40', 'agent', 'email', 'SO received: NGB2611318',
   'Meridian Harmony 027W, ETD ' || to_char(current_date + 6, 'DD Mon') || '.'),
  ('5eed0000-0000-4000-8000-000000000604', current_date - 9 + time '04:10', 'user', 'email', 'Asked agent to confirm loading plan with supplier', null),
  ('5eed0000-0000-4000-8000-000000000604', current_date - 5 + time '03:00', 'supplier', 'wechat', 'Supplier confirmed stuffing date',
   'Stuffing on ' || to_char(current_date, 'DD Mon') || '.'),
  ('5eed0000-0000-4000-8000-000000000604', current_date - 1 + time '02:20', 'agent', 'email', 'Draft HBL and MBL received', null),
  ('5eed0000-0000-4000-8000-000000000604', now() - interval '3 hours', 'user', 'whatsapp', 'Sent draft HBL to client for approval', null),

  -- SHP-2610-038 final_drafts
  ('5eed0000-0000-4000-8000-000000000605', current_date - 20 + time '05:30', 'client', 'whatsapp', 'Client approved quote', null),
  ('5eed0000-0000-4000-8000-000000000605', current_date - 18 + time '02:50', 'agent', 'email', 'SO received: NGB2610876',
   'Sea Crest Valor 046W.'),
  ('5eed0000-0000-4000-8000-000000000605', current_date - 8 + time '03:10', 'agent', 'email', 'Draft HBL and MBL received', null),
  ('5eed0000-0000-4000-8000-000000000605', current_date - 6 + time '09:00', 'client', 'whatsapp', 'Client approved draft HBL', null),
  ('5eed0000-0000-4000-8000-000000000605', current_date - 2 + time '04:00', 'user', 'email', 'Asked agent if stuffed and to update drafts', null),
  ('5eed0000-0000-4000-8000-000000000605', current_date - 2 + time '10:20', 'agent', 'wechat', 'Container stuffed',
   'SCLU4417290, seal SC2210457.'),
  ('5eed0000-0000-4000-8000-000000000605', current_date - 1 + time '03:45', 'agent', 'email', 'Updated HBL and MBL received', null),
  ('5eed0000-0000-4000-8000-000000000605', now() - interval '5 hours', 'system', 'system', 'HBL/MBL mismatch flagged',
   'Gross weight differs: HBL 18,450 kg vs MBL 18,540 kg.'),

  -- SHP-2611-045 awaiting_sailing (ETD today)
  ('5eed0000-0000-4000-8000-000000000606', current_date - 22 + time '06:10', 'client', 'whatsapp', 'Client approved quote', null),
  ('5eed0000-0000-4000-8000-000000000606', current_date - 19 + time '02:35', 'agent', 'email', 'SO received: NGB2610912',
   'Orient Jade 121W, ETD ' || to_char(current_date, 'DD Mon') || '.'),
  ('5eed0000-0000-4000-8000-000000000606', current_date - 12 + time '03:20', 'agent', 'email', 'Draft HBL and MBL received', null),
  ('5eed0000-0000-4000-8000-000000000606', current_date - 5 + time '09:40', 'agent', 'wechat', 'Container stuffed',
   'OSSU7731046, seal OS884213.'),
  ('5eed0000-0000-4000-8000-000000000606', current_date - 4 + time '03:00', 'agent', 'email', 'Updated HBL and MBL received', null),
  ('5eed0000-0000-4000-8000-000000000606', current_date - 3 + time '07:15', 'client', 'whatsapp', 'Client approved final HBL', null),
  ('5eed0000-0000-4000-8000-000000000606', current_date - 3 + time '07:40', 'user', 'email', 'Told agent HBL approved', null),
  ('5eed0000-0000-4000-8000-000000000606', now() - interval '2 hours', 'system', 'system', 'ETD today: draft ready',
   'Ask agent whether the vessel sailed and request pre-alerts.'),

  -- SHP-2610-033 pre_alerts
  ('5eed0000-0000-4000-8000-000000000607', current_date - 25 + time '07:20', 'client', 'whatsapp', 'Client approved quote', null),
  ('5eed0000-0000-4000-8000-000000000607', current_date - 10 + time '08:30', 'agent', 'wechat', 'Container stuffed',
   'BMLU2290518, seal BM5530912.'),
  ('5eed0000-0000-4000-8000-000000000607', current_date - 6 + time '04:00', 'user', 'email', 'Asked agent if vessel sailed, requested pre-alerts', null),
  ('5eed0000-0000-4000-8000-000000000607', current_date - 5 + time '02:10', 'agent', 'email', 'Vessel sailed',
   'Meridian Grace 019W sailed ' || to_char(current_date - 6, 'DD Mon') || '.'),
  ('5eed0000-0000-4000-8000-000000000607', now() - interval '4 hours', 'agent', 'email', 'Pre-alerts received',
   'Final HBL, MBL copy, commercial invoice, packing list.'),

  -- SHP-2610-031 awaiting_release (ETA in 12 days)
  ('5eed0000-0000-4000-8000-000000000608', current_date - 35 + time '05:40', 'client', 'whatsapp', 'Client approved quote', null),
  ('5eed0000-0000-4000-8000-000000000608', current_date - 14 + time '03:30', 'agent', 'email', 'Vessel sailed',
   'Sea Crest Horizon 038W, ETA ' || to_char(current_date + 12, 'DD Mon') || '.'),
  ('5eed0000-0000-4000-8000-000000000608', current_date - 12 + time '02:45', 'agent', 'email', 'Pre-alerts received', null),
  ('5eed0000-0000-4000-8000-000000000608', current_date - 12 + time '05:10', 'user', 'email', 'Forwarded pre-alerts to operations', null),
  ('5eed0000-0000-4000-8000-000000000608', now() - interval '1 hour', 'system', 'system', 'Release due: draft ready',
   'ETA in 12 days. Ask agent for telex release, surrender, SWB or courier details.');

-- ---------------------------------------------------------------------------
-- Settings (row created by the migration)
-- ---------------------------------------------------------------------------

update public.settings
  set ops_email = 'operations@yourcompany.example',
      default_margin_usd = 150,
      signature = E'Best regards,\nOperations Desk\nYour Company Logistics, Karachi\n+92 21 5550100'
  where singleton;

commit;
