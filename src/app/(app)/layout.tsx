import { Suspense } from "react";
import { Loader2 } from "lucide-react";
import { requireUser } from "@/lib/supabase/auth";

// Every page in (app) requires a signed-in user. src/proxy.ts redirects
// early, but this server-side check is the one that counts: nothing under
// this layout renders until the session has been verified.
export default function AppLayout({ children }: LayoutProps<"/">) {
  return (
    <Suspense fallback={<LoadingScreen />}>
      <RequireUser>{children}</RequireUser>
    </Suspense>
  );
}

async function RequireUser({ children }: { children: React.ReactNode }) {
  await requireUser();
  return children;
}

function LoadingScreen() {
  return (
    <div className="flex flex-1 items-center justify-center text-muted-foreground">
      <Loader2 className="size-5 animate-spin" aria-label="Loading" />
    </div>
  );
}
