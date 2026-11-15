"use server";

import { redirect } from "next/navigation";
import { z } from "zod";
import { createClient } from "./server";

export type SignInState = {
  error: string | null;
  email: string;
};

const signInSchema = z.object({
  email: z.email("Enter a valid email address."),
  password: z.string().min(1, "Enter your password."),
});

export async function signIn(
  _prev: SignInState,
  formData: FormData,
): Promise<SignInState> {
  const email = String(formData.get("email") ?? "").trim();
  const parsed = signInSchema.safeParse({
    email,
    password: formData.get("password"),
  });
  if (!parsed.success) {
    return { error: parsed.error.issues[0].message, email };
  }

  const supabase = await createClient();
  const { error } = await supabase.auth.signInWithPassword(parsed.data);
  if (error) {
    const message =
      error.code === "invalid_credentials"
        ? "Wrong email or password."
        : error.code === "email_not_confirmed"
          ? "This email address hasn't been confirmed yet."
          : "Couldn't sign in. Please try again.";
    return { error: message, email };
  }

  // redirect() throws, so it stays outside any try/catch.
  redirect("/dashboard");
}

export async function signOut() {
  const supabase = await createClient();
  await supabase.auth.signOut();
  redirect("/login");
}
