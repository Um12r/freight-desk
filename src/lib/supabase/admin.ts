// Build fails if this file is ever imported into a Client Component.
import "server-only";
import { createClient } from "@supabase/supabase-js";
import { getSupabaseUrl } from "./env";
import type { Database } from "./types";

// Service-role client. BYPASSES Row Level Security.
// Use only in trusted server code that has no user session (cron jobs,
// Graph webhooks, background matching), and check permissions yourself.
// For anything done on behalf of a signed-in user, use ./server instead.
export function createAdminClient() {
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!serviceRoleKey) {
    throw new Error("Missing env var SUPABASE_SERVICE_ROLE_KEY");
  }

  return createClient<Database>(getSupabaseUrl(), serviceRoleKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
      detectSessionInUrl: false,
    },
  });
}
