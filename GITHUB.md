# Push KnucklsOS to GitHub (MrKnuckls)

Repo: https://github.com/MrKnuckls/knucklsos

## Option A — push from your own machine
1. Download `knucklsos-repo.tar.gz` (attached in chat) and extract:
   ```bash
   tar xzf knucklsos-repo.tar.gz
   cd knucklsos
   ```
2. On github.com → **New repository** → name `knucklsos` → no README/.gitignore → Create.
3. Push:
   ```bash
   git remote add origin https://github.com/MrKnuckls/knucklsos.git
   git branch -M main
   git push -u origin main
   ```

## Option B — let Dom (Hermes) push from the sandbox
Provide a GitHub Personal Access Token (fine-grained, `repo` scope) and run:
```bash
cd ~/knucklsos
git remote add origin https://github.com/MrKnuckls/knucklsos.git
git branch -M main
git push -u origin main   # uses the token you supply
```
