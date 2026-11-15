import type { Metadata } from "next";
import { Suspense } from "react";
import { requireUser } from "@/lib/supabase/auth";
import { SignOutButton } from "@/components/sign-out-button";

export const metadata: Metadata = {
  title: "Dashboard",
};

// Placeholder until Phase 2 builds the real dashboard and sidebar.
export default function DashboardPage() {
  return (
    <main className="mx-auto flex w-full max-w-3xl flex-1 flex-col gap-6 px-4 py-10">
      <h1 className="text-2xl font-semibold text-navy">Dashboard</h1>
      <div className="flex items-center justify-between gap-4 rounded-[12px] border border-border bg-card p-6">
        <Suspense
          fallback={<p className="text-sm text-muted-foreground">Loading…</p>}
        >
          <SignedInAs />
        </Suspense>
        <SignOutButton />
      </div>
    </main>
  );
}

async function SignedInAs() {
  const user = await requireUser();
  return (
    <p className="text-sm">
      Signed in as <span className="font-medium">{user.email ?? user.id}</span>
    </p>
  );
}
