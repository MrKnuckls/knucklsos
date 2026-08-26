# Push KnucklsOS to GitHub (MrKnuckls)

Repo: https://github.com/MrKnuckls/knucklsos

## Get a Personal Access Token (PAT)
1. github.com → avatar (top-right) → **Settings**
2. Bottom of left sidebar → **Developer settings**
3. **Personal access tokens** → **Tokens (classic)**
4. **Generate new token (classic)** → name `knucklsos-push`, expiry 7 days
5. Tick scope **`repo`** (full control of private repos)
6. **Generate token** → copy the `ghp_...` value (shown once only)

## Option A — let Dom (Hermes) push from the sandbox
Paste the `ghp_...` token in chat. Dom runs:
```bash
cd ~/knucklsos
git remote add origin https://github.com/MrKnuckls/knucklsos.git
git branch -M main
git push -u origin main   # uses the token you supply
```
(Repo is already committed locally at ~/knucklsos.)

## Option B — push from your own machine
1. Download `knucklsos-repo.tar.gz` (attached in chat) and extract:
   ```bash
   tar xzf knucklsos-repo.tar.gz
   cd knucklsos
   ```
2. On github.com → **New repository** → name `knucklsos` → no README/.gitignore → Create.
3. Push (use the token as the password when Git prompts):
   ```bash
   git remote add origin https://github.com/MrKnuckls/knucklsos.git
   git branch -M main
   git push -u origin main
   # Username: MrKnuckls
   # Password: <the ghp_ token>
   ```
