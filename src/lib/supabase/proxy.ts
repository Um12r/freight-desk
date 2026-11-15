import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";
import { getSupabasePublishableKey, getSupabaseUrl } from "./env";
import type { Database } from "./types";

// Paths a signed-out user may open.
const PUBLIC_PATHS = ["/login"];
// Paths a signed-in user is sent away from.
const SIGNED_IN_REDIRECT_PATHS = ["/", "/login"];
const HOME_PATH = "/dashboard";
const LOGIN_PATH = "/login";

// Refreshes the Supabase session on every request and writes the updated
// auth cookies to both the request (for Server Components rendering this
// request) and the response (for the browser). Then redirects based on
// whether the user is signed in.
//
// This is an optimistic check only. The real check runs on the server in
// src/app/(app)/layout.tsx and in every server action (see ./auth.ts).
export async function updateSession(request: NextRequest) {
  let response = NextResponse.next({ request });
  let cacheHeaders: Record<string, string> = {};

  const supabase = createServerClient<Database>(
    getSupabaseUrl(),
    getSupabasePublishableKey(),
    {
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
          cacheHeaders = headers;
          Object.entries(headers).forEach(([key, value]) =>
            response.headers.set(key, value),
          );
        },
      },
    },
  );

  // Don't put code between createServerClient and getClaims(): the refresh
  // must finish before the response is returned. getClaims() verifies the
  // JWT, unlike getSession(), which only reads the cookie.
  const { data } = await supabase.auth.getClaims();
  const signedIn = Boolean(data?.claims?.sub);

  const { pathname } = request.nextUrl;

  if (!signedIn && !PUBLIC_PATHS.includes(pathname)) {
    return redirectTo(request, LOGIN_PATH, response, cacheHeaders);
  }
  if (signedIn && SIGNED_IN_REDIRECT_PATHS.includes(pathname)) {
    return redirectTo(request, HOME_PATH, response, cacheHeaders);
  }

  return response;
}

// A redirect is a new response, so carry over any auth cookies that
// getClaims() just refreshed. Otherwise the browser keeps the old tokens and
// the refresh is lost.
function redirectTo(
  request: NextRequest,
  pathname: string,
  from: NextResponse,
  cacheHeaders: Record<string, string>,
) {
  const url = request.nextUrl.clone();
  url.pathname = pathname;
  url.search = "";
  const redirect = NextResponse.redirect(url);
  from.cookies.getAll().forEach((cookie) => redirect.cookies.set(cookie));
  Object.entries(cacheHeaders).forEach(([key, value]) =>
    redirect.headers.set(key, value),
  );
  return redirect;
}
