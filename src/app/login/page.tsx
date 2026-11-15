import type { Metadata } from "next";
import { Suspense } from "react";
import { redirect } from "next/navigation";
import { Ship } from "lucide-react";
import { getCurrentUser } from "@/lib/supabase/auth";
import { LoginForm } from "./login-form";

export const metadata: Metadata = {
  title: "Sign in",
};

export default function LoginPage() {
  return (
    <main className="flex flex-1 items-center justify-center px-4 py-12">
      {/* Server-side check: signed-in users go to the dashboard. Reads
          cookies, so it sits in its own boundary and the card prerenders. */}
      <Suspense fallback={null}>
        <RedirectIfSignedIn />
      </Suspense>

      <div className="w-full max-w-sm rounded-[12px] border border-border bg-card p-8 shadow-sm">
        <div className="mb-8 flex flex-col items-center text-center">
          <div className="mb-4 flex size-11 items-center justify-center rounded-[10px] bg-navy text-white">
            <Ship className="size-5" aria-hidden />
          </div>
          <h1 className="text-xl font-semibold text-navy">Freight Desk</h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Sign in to continue
          </p>
        </div>
        <LoginForm />
      </div>
    </main>
  );
}

async function RedirectIfSignedIn() {
  const user = await getCurrentUser();
  if (user) redirect("/dashboard");
  return null;
}
