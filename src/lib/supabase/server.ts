import "server-only";
import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";
import { getSupabasePublishableKey, getSupabaseUrl } from "./env";
import type { Database } from "./types";

// Server client for Server Components, Server Actions and Route Handlers.
// Acts as the signed-in user (publishable key + session cookie), so RLS applies.
// Create a new one per request; never cache or share it.
//
// With Cache Components enabled, cookies() is request-time data: call this
// inside a <Suspense> boundary, or the route can't be prerendered.
export async function createClient() {
  const cookieStore = await cookies();

  return createServerClient<Database>(getSupabaseUrl(), getSupabasePublishableKey(), {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        try {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options),
          );
        } catch {
          // Server Components can't set cookies. That's fine: src/proxy.ts
          // refreshes the session and writes the cookies on every request.
          // In Server Actions and Route Handlers this succeeds.
        }
      },
    },
  });
}
