## Repository overview (quick, actionable)

This repository is a monorepo-style full-stack game project (Nexium RPG) with a Node/Express backend, a Vite React frontend (client/), and a Discord bot (server/discord-bot). The server is written in TypeScript and uses Drizzle ORM for Postgres schema. The project uses pnpm as the package manager.

High-level components
- Root: orchestration scripts and top-level `package.json` that runs both client and server builds.
- client/: Vite + React frontend. Key files: `client/src/main.tsx`, `client/src/App.tsx`, `client/package.json`.
- server/: Express server + API + Discord bot. Key files: `server/index.ts`, `server/routes.ts`, `server/vite.ts`, `server/discord-bot/*` and `server/package.json`.
- shared/: `shared/schema.ts` contains the Drizzle ORM schema and zod helpers used by server storage.

Why these choices matter for agents
- The server bundles with esbuild (see root and `server/package.json`). When editing server code you often need to run `pnpm -w -s run build` to create `dist/` before `start`.
- Vite is used to build the client and to serve in dev: `pnpm -w -s run dev` (root `dev` script runs server with tsx while client development typically uses `client` dev script).
- Discord bot lives inside `server/discord-bot` and is started conditionally from `server/index.ts` (only if `DISCORD_BOT_TOKEN` is present and not the placeholder). Changing bot commands requires re-registering commands: `pnpm -w -s run register-commands`.

Key workflows and commands (concrete)
- Start development server (combined server + vite dev):
  - Root dev script: `pnpm -w -s run dev` (runs `tsx server/index.ts` with NODE_ENV=development)
  - Frontend dev: `pnpm --filter client dev` (open `client/` and `pnpm dev`) — prefer using the root terminal that runs the server, and a separate terminal for the client watch if desired.
- Build for production:
  - Full build: `pnpm -w -s run build` (runs `vite build` and esbuild server/index.ts)
  - Server-only: `pnpm --filter server build` or `cd server && pnpm build`
  - Client-only: `pnpm --filter client build` or `cd client && pnpm build`
- Start production server (after build): `pnpm -w -s run start` or `pnpm --filter server start` (server `start` expects `dist/index.js`).
- Register Discord slash commands: `pnpm -w -s run register-commands` (calls `server/discord-bot/register-commands.ts`).
- Database migrations (Drizzle): `pnpm -w -s run db:migrate` / `pnpm -w -s run db:generate`.

Environment and runtime notes (must-check)
- Root `package.json` assumes `pnpm` and Node. Key env vars used by the server/bot:
  - `PORT` (defaults to 5000)
  - `NODE_ENV` (development | production)
  - `DISCORD_BOT_TOKEN`, `DISCORD_CLIENT_ID`, `DISCORD_CLIENT_SECRET`
  - `REDIS_URL` (production redis)
  - `SESSION_SECRET`
  - Database connection variables expected by Drizzle/pg (inspect `.env` in project root if present)
- Many files include placeholder values: e.g. `DISCORD_BOT_TOKEN` default `'your_bot_token'`. Tests or CI must set real secrets or mock them.

Project-specific patterns and conventions
- Single-entry server: `server/index.ts` boots the Express app, registers routes via `registerRoutes(app)` (in `server/routes.ts`), sets up WebSockets (`/ws`), and conditionally mounts Vite in dev via `server/vite.ts`.
- Storage abstraction: `server/storage.ts` (and imports from `shared/schema.ts`) centralizes DB operations. Use `storage` methods when writing features or tests instead of raw knex/ORM calls.
- Discord command handlers: `server/discord-bot/commands/*.ts` export `{ data, execute }`. `data` is a builder for slash commands and `execute(interaction, storage)` contains business logic. Registering is done in `register-commands.ts` and the bot action wiring is in `server/discord-bot/index.ts`.
- Schema-first DB: `shared/schema.ts` uses Drizzle ORM and exports Zod schemas for validation (e.g., `insertUserSchema`). Use those types and schemas for consistent shape validation.
- Logging: `server/index.ts` wraps requests to log API calls for `/api/*` routes (truncates long JSON). Keep that pattern when adding other instrumentations.

Integration points and cross-component communication
- HTTP API: REST endpoints are under `/api/*` inside `server/routes.ts` (auth, users, market, battles, explorations, stats). Frontend calls these endpoints.
- WebSockets: `server/routes.ts` creates a WebSocket server at path `/ws` — used for real-time updates (market/battles subscriptions).
- Discord: Bot posts/receives both via Discord APIs and via internal storage (shared DB). When updating game logic, ensure Discord commands call same `storage` helpers as the web app for consistent state.
- Sessions & auth: Uses `passport-discord` and express-session. In production sessions use Redis via `connect-redis`; in development a memory store is used.

What an AI agent should check before making changes
- Are there environment variables required? If editing bot code, confirm `DISCORD_BOT_TOKEN` and `DISCORD_CLIENT_ID` are not placeholders.
- If changing DB schema (`shared/schema.ts`), ensure dripline updates (Drizzle migrations) are created: `pnpm -w -s run db:generate` and `pnpm -w -s run db:migrate`.
- If adding an API route, add it in `server/routes.ts` and ensure it uses `storage` helpers where possible, and add appropriate tests or manual curl checks.
- For frontend changes, prefer using existing UI components under `client/src/components/*`. Follow the style of theme-provider and Radix components already in use.
- **Always push changes to GitHub**: After making any code changes, commit and push them to the repository to ensure version control and backup.

- Quick examples to copy-paste
- Start dev server (recommended):

```powershell
pnpm -w -s run dev
```

- Register Discord commands (must set env vars first):

```powershell
# On Windows PowerShell (v5.1) avoid POSIX inline env + && chaining. Example that works in PowerShell:
$env:DISCORD_BOT_TOKEN = 'token'; $env:DISCORD_CLIENT_ID = 'clientid'; pnpm -w -s run register-commands
# Do NOT use: `DISCORD_BOT_TOKEN=token DISCORD_CLIENT_ID=clientid pnpm -w -s run register-commands` or chaining with `&&` in scripts when relying on PowerShell behavior.
pnpm -w -s run register-commands
```

- Build everything for production:

```powershell
pnpm -w -s run build
```

Files to look at for common tasks
- Boot & wiring: `server/index.ts`
- Routes & real-time: `server/routes.ts`
- DB schema & types: `shared/schema.ts`
- Discord bot wiring: `server/discord-bot/index.ts`
- Registering commands: `server/discord-bot/register-commands.ts`
- Frontend entry: `client/src/main.tsx`, `client/src/App.tsx`

Limitations of this guidance
- This file documents only discoverable patterns. Secrets, CI specifics, and local dev scripts (if any) that are not in the repo must be obtained from maintainers.

PowerShell caveats & options

- Windows PowerShell v5.1 (the default shell in this workspace) does not support POSIX-style inline environment variables (e.g. `FOO=bar cmd`) and `&&` chaining behaves differently than POSIX shells. Use PowerShell syntax to set env vars (`$env:FOO = 'bar';`) and chain commands with `;`.

- I can add either or both of the following helpers:
  - A VS Code Task (`.vscode/tasks.json`) that starts the combined dev flow (server + client) using PowerShell-friendly commands.
  - A persistent PowerShell script `scripts/rebuild-until-healthy.ps1` and a root npm script to invoke it. This script can implement the `Rebuild-UntilHealthy` loop described in `copilot-instructions.md` and be called from `package.json`.

If you'd like I can add the VS Code task and/or the `scripts/rebuild-until-healthy.ps1` now — tell me which one you prefer.
