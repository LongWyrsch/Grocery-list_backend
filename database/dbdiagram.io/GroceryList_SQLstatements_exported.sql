CREATE TABLE "roles" (
  "role" text PRIMARY KEY
);

CREATE TABLE "languages" (
  "language" text PRIMARY KEY
);

CREATE TABLE "sections" (
  "section" text PRIMARY KEY
);

CREATE TABLE "users" (
  "uuid" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
  "email" text UNIQUE,
  "hashed_password" text UNIQUE,
  "google_id" text UNIQUE,
  "google_name" text,
  "role" text NOT NULL DEFAULT 'user',
  "language" text NOT NULL DEFAULT 'EN',
  "dark_theme" boolean NOT NULL DEFAULT false,
  "avatar_variant" text NOT NULL,
  "avatar_colors" varchar(6)[] NOT NULL,
  "layouts_recipes" json NULL,
  "layouts_lists" json NULL
);

CREATE TABLE "recipes" (
  "uuid" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
  "user_uuid" uuid NOT NULL,
  "card_uuid" uuid NOT NULL,
  "title" text NOT NULL,
  "index" int NOT NULL,
  "ingredient" text NOT NULL,
  "quantity" numeric,
  "unit" text,
  "section" text NOT NULL,
  "kCal" numeric,
  "last_modified" timestamp NOT NULL DEFAULT ((now() at time zone 'utc')),
);

CREATE TABLE "lists" (
  "uuid" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
  "user_uuid" uuid NOT NULL,
  "card_uuid" uuid NOT NULL,
  "title" text NOT NULL,
  "index" int NOT NULL,
  "ingredient" text NOT NULL,
  "quantity" numeric,
  "unit" text,
  "section" text NOT NULL,
  "checked" boolean NOT NULL,
  "last_modified" timestamp NOT NULL DEFAULT ((now() at time zone 'utc')),
);

ALTER TABLE "users" ADD FOREIGN KEY ("role") REFERENCES "roles" ("role");

ALTER TABLE "users" ADD FOREIGN KEY ("language") REFERENCES "languages" ("language");

ALTER TABLE "recipes" ADD FOREIGN KEY ("user_uuid") REFERENCES "users" ("uuid");

ALTER TABLE "recipes" ADD FOREIGN KEY ("section") REFERENCES "sections" ("section");

ALTER TABLE "lists" ADD FOREIGN KEY ("user_uuid") REFERENCES "users" ("uuid");

ALTER TABLE "lists" ADD FOREIGN KEY ("section") REFERENCES "sections" ("section");
