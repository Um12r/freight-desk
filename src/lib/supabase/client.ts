import { createBrowserClient } from "@supabase/ssr";
import { getSupabaseAnonKey, getSupabaseUrl } from "./env";

// Browser client for Client Components. Uses the anon key and the user's
// session cookie, so every query is subject to Row Level Security.
// Mutations still go through server actions (see CLAUDE.md); use this for
// reads, realtime and auth UI only.
export function createClient() {
  return createBrowserClient(getSupabaseUrl(), getSupabaseAnonKey());
}
