import { redirect } from "next/navigation";

// src/proxy.ts normally redirects / before this renders (to /dashboard or
// /login). This is the fallback; (app)/layout.tsx then checks the session.
export default function Home() {
  redirect("/dashboard");
}
