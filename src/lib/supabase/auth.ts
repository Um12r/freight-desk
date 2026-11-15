import "server-only";
import { cache } from "react";
import { redirect } from "next/navigation";
import { createClient } from "./server";

export type CurrentUser = {
  id: string;
  email: string | null;
};

// Returns the signed-in user, or null. Verifies the JWT on the server
// (getClaims), so it can't be faked by editing the cookie. cache() dedupes
// the check within one request.
//
// Reads cookies, so with Cache Components any component that calls this must
// render inside a <Suspense> boundary.
export const getCurrentUser = cache(async (): Promise<CurrentUser | null> => {
  const supabase = await createClient();
  const { data, error } = await supabase.auth.getClaims();
  const claims = data?.claims;
  if (error || !claims?.sub) return null;
  return {
    id: claims.sub,
    email: typeof claims.email === "string" ? claims.email : null,
  };
});

// Use in every page, layout and server action that needs a signed-in user.
export async function requireUser(): Promise<CurrentUser> {
  const user = await getCurrentUser();
  if (!user) redirect("/login");
  return user;
}
