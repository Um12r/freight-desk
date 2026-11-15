// Public Supabase settings. Safe to use in the browser: both values are
// meant to be public, and Row Level Security protects the data.
// Next.js only inlines NEXT_PUBLIC_* vars when they are read with a static
// property name, so each var is read explicitly rather than via process.env[name].

export function getSupabaseUrl(): string {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  if (!url) throw new Error("Missing env var NEXT_PUBLIC_SUPABASE_URL");
  return url;
}

export function getSupabaseAnonKey(): string {
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!key) throw new Error("Missing env var NEXT_PUBLIC_SUPABASE_ANON_KEY");
  return key;
}
