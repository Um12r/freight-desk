import { createBrowserClient } from "@supabase/ssr";
import { getSupabasePublishableKey, getSupabaseUrl } from "./env";
import type { Database } from "./types";

// Browser client for Client Components. Uses the publishable key and the user's
// session cookie, so every query is subject to Row Level Security.
// Mutations still go through server actions (see CLAUDE.md); use this for
// reads, realtime and auth UI only.
export function createClient() {
  return createBrowserClient<Database>(getSupabaseUrl(), getSupabasePublishableKey());
}
