CREATE TABLE "battles" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"attacker" uuid NOT NULL,
	"defender" uuid NOT NULL,
	"attacker_ship" uuid NOT NULL,
	"defender_ship" uuid NOT NULL,
	"winner" uuid,
	"battle_data" jsonb NOT NULL,
	"rewards" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"battle_type" varchar(20) DEFAULT 'pvp' NOT NULL,
	"sector_id" uuid,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "explorations" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"sector_id" uuid NOT NULL,
	"ship_id" uuid NOT NULL,
	"action_type" varchar(30) NOT NULL,
	"energy_cost" integer NOT NULL,
	"results" jsonb NOT NULL,
	"rewards" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"success" boolean NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "guild_members" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"guild_id" uuid NOT NULL,
	"user_id" uuid NOT NULL,
	"role" varchar(20) DEFAULT 'member' NOT NULL,
	"contribution" numeric(20, 2) DEFAULT '0.00' NOT NULL,
	"joined_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "guilds" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"leader_id" uuid NOT NULL,
	"treasury" numeric(20, 2) DEFAULT '0.00' NOT NULL,
	"level" integer DEFAULT 1 NOT NULL,
	"experience" integer DEFAULT 0 NOT NULL,
	"member_limit" integer DEFAULT 10 NOT NULL,
	"is_recruiting" boolean DEFAULT true NOT NULL,
	"requirements" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"perks" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "guilds_name_unique" UNIQUE("name")
);
--> statement-breakpoint
CREATE TABLE "inventory" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"item_id" uuid NOT NULL,
	"quantity" integer DEFAULT 1 NOT NULL,
	"acquired_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "items" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"item_type" varchar(50) NOT NULL,
	"rarity" varchar(20) DEFAULT 'common' NOT NULL,
	"value" numeric(20, 2) DEFAULT '0.00' NOT NULL,
	"stackable" boolean DEFAULT true NOT NULL,
	"max_stack" integer DEFAULT 100 NOT NULL,
	"stats" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"requirements" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"effects" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"is_active" boolean DEFAULT true NOT NULL
);
--> statement-breakpoint
CREATE TABLE "market_listings" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"seller_id" uuid NOT NULL,
	"item_id" uuid NOT NULL,
	"quantity" integer NOT NULL,
	"price_per_unit" numeric(20, 2) NOT NULL,
	"total_price" numeric(20, 2) NOT NULL,
	"is_active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"expires_at" timestamp NOT NULL
);
--> statement-breakpoint
CREATE TABLE "sectors" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" text NOT NULL,
	"coordinates" text NOT NULL,
	"sector_type" varchar(50) DEFAULT 'unexplored' NOT NULL,
	"difficulty" integer DEFAULT 1 NOT NULL,
	"resources" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"hazards" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"discovered_by" uuid,
	"discovered_at" timestamp,
	"visit_count" integer DEFAULT 0 NOT NULL,
	"last_visited" timestamp,
	"is_special" boolean DEFAULT false NOT NULL,
	"special_data" jsonb DEFAULT '{}'::jsonb NOT NULL,
	CONSTRAINT "sectors_coordinates_unique" UNIQUE("coordinates")
);
--> statement-breakpoint
CREATE TABLE "ships" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"name" text NOT NULL,
	"ship_type" varchar(50) DEFAULT 'explorer' NOT NULL,
	"hull" integer DEFAULT 100 NOT NULL,
	"max_hull" integer DEFAULT 100 NOT NULL,
	"shields" integer DEFAULT 50 NOT NULL,
	"max_shields" integer DEFAULT 50 NOT NULL,
	"attack" integer DEFAULT 20 NOT NULL,
	"defense" integer DEFAULT 15 NOT NULL,
	"speed" integer DEFAULT 10 NOT NULL,
	"cargo" integer DEFAULT 100 NOT NULL,
	"max_cargo" integer DEFAULT 100 NOT NULL,
	"fuel" integer DEFAULT 100 NOT NULL,
	"max_fuel" integer DEFAULT 100 NOT NULL,
	"experience" integer DEFAULT 0 NOT NULL,
	"level" integer DEFAULT 1 NOT NULL,
	"is_active" boolean DEFAULT true NOT NULL,
	"upgrades" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"cosmetics" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"discord_id" varchar(20) NOT NULL,
	"username" text NOT NULL,
	"avatar" text,
	"nexium_crystals" numeric(20, 2) DEFAULT '1000.00' NOT NULL,
	"energy" integer DEFAULT 100 NOT NULL,
	"max_energy" integer DEFAULT 100 NOT NULL,
	"last_energy_restore" timestamp DEFAULT now() NOT NULL,
	"rank" integer DEFAULT 0 NOT NULL,
	"total_explored" integer DEFAULT 0 NOT NULL,
	"total_battles_won" integer DEFAULT 0 NOT NULL,
	"joined_at" timestamp DEFAULT now() NOT NULL,
	"last_active" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "users_discord_id_unique" UNIQUE("discord_id")
);
--> statement-breakpoint
ALTER TABLE "battles" ADD CONSTRAINT "battles_attacker_users_id_fk" FOREIGN KEY ("attacker") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "battles" ADD CONSTRAINT "battles_defender_users_id_fk" FOREIGN KEY ("defender") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "battles" ADD CONSTRAINT "battles_attacker_ship_ships_id_fk" FOREIGN KEY ("attacker_ship") REFERENCES "public"."ships"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "battles" ADD CONSTRAINT "battles_defender_ship_ships_id_fk" FOREIGN KEY ("defender_ship") REFERENCES "public"."ships"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "battles" ADD CONSTRAINT "battles_winner_users_id_fk" FOREIGN KEY ("winner") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "battles" ADD CONSTRAINT "battles_sector_id_sectors_id_fk" FOREIGN KEY ("sector_id") REFERENCES "public"."sectors"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "explorations" ADD CONSTRAINT "explorations_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "explorations" ADD CONSTRAINT "explorations_sector_id_sectors_id_fk" FOREIGN KEY ("sector_id") REFERENCES "public"."sectors"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "explorations" ADD CONSTRAINT "explorations_ship_id_ships_id_fk" FOREIGN KEY ("ship_id") REFERENCES "public"."ships"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "guild_members" ADD CONSTRAINT "guild_members_guild_id_guilds_id_fk" FOREIGN KEY ("guild_id") REFERENCES "public"."guilds"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "guild_members" ADD CONSTRAINT "guild_members_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "guilds" ADD CONSTRAINT "guilds_leader_id_users_id_fk" FOREIGN KEY ("leader_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "inventory" ADD CONSTRAINT "inventory_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "inventory" ADD CONSTRAINT "inventory_item_id_items_id_fk" FOREIGN KEY ("item_id") REFERENCES "public"."items"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "market_listings" ADD CONSTRAINT "market_listings_seller_id_users_id_fk" FOREIGN KEY ("seller_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "market_listings" ADD CONSTRAINT "market_listings_item_id_items_id_fk" FOREIGN KEY ("item_id") REFERENCES "public"."items"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "sectors" ADD CONSTRAINT "sectors_discovered_by_users_id_fk" FOREIGN KEY ("discovered_by") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ships" ADD CONSTRAINT "ships_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "battles_attacker_idx" ON "battles" USING btree ("attacker");--> statement-breakpoint
CREATE INDEX "battles_defender_idx" ON "battles" USING btree ("defender");--> statement-breakpoint
CREATE INDEX "battles_winner_idx" ON "battles" USING btree ("winner");--> statement-breakpoint
CREATE INDEX "battles_created_at_idx" ON "battles" USING btree ("created_at");--> statement-breakpoint
CREATE INDEX "explorations_user_idx" ON "explorations" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "explorations_sector_idx" ON "explorations" USING btree ("sector_id");--> statement-breakpoint
CREATE INDEX "explorations_created_at_idx" ON "explorations" USING btree ("created_at");--> statement-breakpoint
CREATE INDEX "guild_members_guild_user_idx" ON "guild_members" USING btree ("guild_id","user_id");--> statement-breakpoint
CREATE INDEX "guild_members_guild_idx" ON "guild_members" USING btree ("guild_id");--> statement-breakpoint
CREATE INDEX "guilds_name_idx" ON "guilds" USING btree ("name");--> statement-breakpoint
CREATE INDEX "guilds_leader_idx" ON "guilds" USING btree ("leader_id");--> statement-breakpoint
CREATE INDEX "inventory_user_item_idx" ON "inventory" USING btree ("user_id","item_id");--> statement-breakpoint
CREATE INDEX "inventory_user_id_idx" ON "inventory" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "items_type_idx" ON "items" USING btree ("item_type");--> statement-breakpoint
CREATE INDEX "items_rarity_idx" ON "items" USING btree ("rarity");--> statement-breakpoint
CREATE INDEX "market_seller_idx" ON "market_listings" USING btree ("seller_id");--> statement-breakpoint
CREATE INDEX "market_item_idx" ON "market_listings" USING btree ("item_id");--> statement-breakpoint
CREATE INDEX "market_active_idx" ON "market_listings" USING btree ("is_active");--> statement-breakpoint
CREATE INDEX "market_price_idx" ON "market_listings" USING btree ("price_per_unit");--> statement-breakpoint
CREATE INDEX "sectors_coordinates_idx" ON "sectors" USING btree ("coordinates");--> statement-breakpoint
CREATE INDEX "sectors_discovered_by_idx" ON "sectors" USING btree ("discovered_by");--> statement-breakpoint
CREATE INDEX "sectors_type_idx" ON "sectors" USING btree ("sector_type");--> statement-breakpoint
CREATE INDEX "ships_user_id_idx" ON "ships" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "ships_active_idx" ON "ships" USING btree ("is_active");--> statement-breakpoint
CREATE INDEX "users_discord_id_idx" ON "users" USING btree ("discord_id");--> statement-breakpoint
CREATE INDEX "users_rank_idx" ON "users" USING btree ("rank");