# Freight Desk

## What this is
An internal web app for a freight forwarder based in Karachi. It runs two pipelines:
1. Inquiries: a client asks for a rate (on WhatsApp) -> we email several overseas agents (Shanghai, Ningbo, Qingdao...) -> agents email rates back -> we add a margin -> we send the client a quote on WhatsApp.
2. Shipments: once the client approves, the shipment moves through 12 stages from booking to document release. Almost every step is an email to the agent, triggered by an incoming email or a date.
The app writes every email as a draft. A human reviews, edits and sends it. Nothing is ever sent automatically.
Users: one person now, maybe 2-3 later. Single company, no multi-tenancy.

## Channels
- Agents, our operations department, some clients: Outlook, via Microsoft Graph (one mailbox).
- Clients: WhatsApp. No API in v1. Inquiries are pasted into the app; client messages are generated as text with a Copy button.
- WeChat: no integration. Users record WeChat/WhatsApp updates with a manual "log update" form.

## Stack
- Next.js (App Router) + TypeScript, Tailwind, shadcn/ui
- Supabase: Postgres, Auth (email login), Storage, pg_cron
- Vercel AI SDK with Google Gemini. Model name comes from env AI_MODEL. All AI calls go through src/lib/ai so the provider can be swapped.
- Microsoft Graph for Outlook mail and the Excel register on OneDrive
- zod for validating all inputs and all AI outputs

## Glossary
POL/POD = port of loading/discharge. SO or BC = shipping order / booking confirmation from the shipping line (contains booking no., vessel, ETD). HBL = house bill of lading (ours, shared with client). MBL = master bill of lading (agent <-> shipping line). Cargo fields on HBL and MBL must match; shipper/consignee legitimately differ. Stuffing = loading the container at the supplier. Pre-alerts = final documents after sailing. Telex release / surrender / SWB = how the MBL is released before arrival. Locals = local charges. Free days = free container days at destination.

## Reference numbers
Inquiry refs look like [INQ-YYMM-NNN] and shipment refs like [SHP-YYMM-NNN]. In v1 they come from the client's Excel register (see Phase 7). Every outgoing email subject starts with the ref in square brackets, e.g. "[SHP-2611-045] Booking SHA2611457 | Shanghai -> Karachi | 1x40HC".
Matching an incoming email to a record, in order: ref in subject -> booking no. -> container no. -> Outlook conversationId of a known thread.

## Shipment stages (in order)
1 approved - share agent details with client (WhatsApp text)
2 supplier_details - forward supplier details to agent
3 awaiting_booking - follow up if no SO after N days
4 booking_released - SO received; read ETD; ask agent to confirm loading plan with supplier
5 loading_plan - supplier confirms stuffing date; no follow-up until then
6 drafts_pre_stuffing - draft HBL/MBL received; send HBL to client; tell agent when approved
7 stuffing_day - on stuffing date ask agent if stuffed and to update drafts with container details
8 final_drafts - updated HBL/MBL received; compare them; client approves HBL; tell agent
9 awaiting_sailing - on ETD ask if vessel sailed and request pre-alerts
10 pre_alerts - pre-alerts received; forward to operations
11 awaiting_release - around ETA minus 12 days request MBL surrender/telex/SWB/courier details
12 closed - release doc received and forwarded to operations

## Rules
- Never send an email without an explicit user click on a draft. No auto-send, ever.
- AI never writes to shipments directly. It creates suggested_updates that the user approves.
- Validate every AI output with a zod schema. If validation fails, show the raw text and let the user fill the fields.
- Secrets are server-only. Never expose SUPABASE_SERVICE_ROLE_KEY, Graph tokens or AI keys to the browser. Encrypt stored refresh tokens with TOKEN_ENCRYPTION_KEY.
- Row Level Security on every table: authenticated users only.
- Store dates as date, timestamps as timestamptz (UTC). Display in Asia/Karachi.
- Mutations go through server actions or route handlers, never direct client writes with elevated keys.
- Development uses dummy data only.
- Don't add a new library without saying why.
- Before saying a task is done: npm run lint and npm run build must pass.

## Design
Match the screenshots in docs/screens/. Navy sidebar #14213D, accent blue #2450D6, page background #F4F3EF, white cards with 1px #E3E1DA borders and 12px radius. IBM Plex Sans for text, IBM Plex Mono for refs, numbers and money. Status colours: action = orange, waiting on agent = blue, waiting on client = purple, done = green.

## Layout
src/app/(app)/{dashboard,review,inquiries,shipments,agents,settings}
src/lib/{supabase,ai,graph,stages,matching}
supabase/migrations

@AGENTS.md
