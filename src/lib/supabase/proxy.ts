import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";
import { getSupabaseAnonKey, getSupabaseUrl } from "./env";

// Refreshes the Supabase session on every request and writes the updated
// auth cookies to both the request (for Server Components rendering this
// request) and the response (for the browser).
export async function updateSession(request: NextRequest) {
  let response = NextResponse.next({ request });

  const supabase = createServerClient(getSupabaseUrl(), getSupabaseAnonKey(), {
    cookies: {
      getAll() {
        return request.cookies.getAll();
      },
      setAll(cookiesToSet, headers) {
        cookiesToSet.forEach(({ name, value }) =>
          request.cookies.set(name, value),
        );
        response = NextResponse.next({ request });
        cookiesToSet.forEach(({ name, value, options }) =>
          response.cookies.set(name, value, options),
        );
        // No-cache headers so a CDN never serves one user's session to another.
        Object.entries(headers).forEach(([key, value]) =>
          response.headers.set(key, value),
        );
      },
    },
  });

  // Don't put code between createServerClient and getClaims(): the refresh
  // must finish before the response is returned. getClaims() verifies the
  // JWT, unlike getSession(), which only reads the cookie.
  await supabase.auth.getClaims();

  // TODO (auth task): redirect to /login when there are no claims, once the
  // login page exists. For now this only keeps the session fresh.

  return response;
}
