"use client";

import { useFormStatus } from "react-dom";
import { Loader2, LogOut } from "lucide-react";
import { Button } from "@/components/ui/button";
import { signOut } from "@/lib/supabase/auth-actions";

export function SignOutButton() {
  return (
    <form action={signOut}>
      <SubmitButton />
    </form>
  );
}

function SubmitButton() {
  const { pending } = useFormStatus();
  return (
    <Button type="submit" variant="outline" disabled={pending}>
      {pending ? (
        <Loader2 className="animate-spin" aria-hidden />
      ) : (
        <LogOut aria-hidden />
      )}
      Sign out
    </Button>
  );
}
