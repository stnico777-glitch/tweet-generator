# Tweet Slide Generator

Free Instagram carousel slide tool with an email check-in gate (Supabase).

## Auth / redirect URLs

Magic-link login uses Supabase Auth. In the [Auth URL configuration](https://supabase.com/dashboard/project/lfagebbwqqititsoixyn/auth/url-configuration), set:

- **Site URL:** `https://tweet-generator-hazel.vercel.app`
- **Redirect URLs** (allow list):
  - `https://tweet-generator-hazel.vercel.app`
  - `https://tweet-generator-hazel.vercel.app/**`
  - `http://localhost:3000`
  - `http://localhost:5173`
  - `http://127.0.0.1:5500`

If the CLI cannot update Auth settings (`supabase config push` needs a linked project + access token), update these in the dashboard.

## Config

`config.js` exposes the public Supabase URL + anon key (`window.SUPABASE_URL`, `window.SUPABASE_ANON_KEY`). It is safe to commit; RLS protects the database.

Copy `.env.example` for local notes; the static app reads `config.js`.

Redirect URLs were applied via the Supabase Management API (`site_url` + `uri_allow_list`) on 2026-07-27.
