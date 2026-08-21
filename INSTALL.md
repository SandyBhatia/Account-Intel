# Install — build `brief-1.0`

This zip is the **complete project**, not a set of patches. Replace the whole
folder contents and you are done. No file-by-file copying.

---

## 1 · Replace the code

Unzip somewhere, then copy everything over your repo, overwriting. In
PowerShell — adjust the two paths on the first two lines if yours differ:

```powershell
$src = "$env:USERPROFILE\Downloads\account-intel-brief-1.0"   # where you unzipped
$dst = "C:\Sandy\Personal\Projects\Account-Intel"

if (-not (Test-Path "$src\lib\brief.ts")) { throw "Wrong source folder - lib\brief.ts not found in $src" }
if (-not (Test-Path "$dst\.git"))         { throw "Wrong destination - no .git in $dst" }

Copy-Item -Path "$src\*" -Destination $dst -Recurse -Force
cd $dst
git status
```

Both `throw` lines are guards: the first catches unzipping into a nested
folder, the second catches pointing at the wrong directory. If either fires,
nothing has been copied yet.

`node_modules`, `.next` and `.env.local` are **not** in this zip, so your local
environment and installed packages are untouched.

---

## 2 · Run the database migration

Supabase → SQL Editor → paste → Run:

```sql
alter table public.baselines add column if not exists brief jsonb;
alter table public.baselines add column if not exists card  jsonb;
```

Both are `if not exists`, so running twice is harmless. **Do this before the
import** — without these columns the import writes everything except the brief
and gives no error, which is exactly the failure we already hit once.

---

## 3 · Check locally before pushing

```powershell
npm install
npm run dev
```

Open `http://localhost:3000`. In the **top bar, right-hand side**, you should
see `brief-1.0`. That is the build stamp — if it is missing, the new code is
not running and nothing else in this list will work.

---

## 4 · Push

```powershell
git add -A
git commit -m "Account brief structure - build brief-1.0"
git push
```

Wait for Vercel to finish, then load the deployed site and confirm `brief-1.0`
appears in the top bar there too.

---

## 5 · Re-import CN

On the deployed site → **Import** → choose `data/baselines/03-cn.json` →
**New version** → Publish.

The earlier import went through the old API route, which did not know the
`brief` field existed and silently dropped it. This one carries it.

If the import is **rejected**, read the message — the validator now names the
exact rule that failed rather than failing quietly.

---

## 6 · Confirm it worked

Open `/account/cn`. You should see:

- Left column headed **"Signals & foresight · what moves our GTM"**
- A panel at the top headed **"The first ninety seconds"**
- Five signal cards, one marked *direct fit*, one *hypothesis only*, three
  *No Tria play — considered and rejected*
- Right column: financials → stakeholders → agenda → pressure → the play →
  discussion points → how we lose

The account header should **not** say *"legacy exhibit format"*. If it does,
the brief did not load — most likely step 2 was skipped.

---

## What changed in this build

- Two-column account page; brief replaces the old exhibit list
- Portfolio cards carry a standing insight plus the latest dated signal
- `lib/brief.ts` enforces the evidence rules at import: every signal needs a
  GTM impact, every signal declares whether a Tria play was earned, named
  people carry provenance, agenda items must be within four quarters
- CN corrected: fuel +C$246M / +59.6% (was +C$249M / 210bps, where the
  basis-point figure was derived rather than sourced)
- Build stamp in the top bar
