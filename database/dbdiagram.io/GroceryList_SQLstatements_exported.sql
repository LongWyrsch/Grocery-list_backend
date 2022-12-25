CREATE TABLE "roles" (
  "role" text PRIMARY KEY
);

CREATE TABLE "languages" (
  "language" text PRIMARY KEY
);

CREATE TABLE "units" (
  "unit" text PRIMARY KEY
);

CREATE TABLE "sections" (
  "section" text PRIMARY KEY
);

CREATE TABLE "users" (
  "uuid" uuid PRIMARY KEY,
  "email" text UNIQUE,
  "hashedPassword" text UNIQUE,
  "googleId" text UNIQUE,
  "googleName" text,
  "role" text NOT NULL,
  "language" text NOT NULL,
  "darkmode" boolean NOT NULL
);

CREATE TABLE "avatars" (
  "user_uuid" uuid PRIMARY KEY,
  "variant" text NOT NULL,
  "color1" varchar(6) NOT NULL,
  "color2" varchar(6) NOT NULL,
  "color3" varchar(6) NOT NULL,
  "color4" varchar(6) NOT NULL,
  "color5" varchar(6) NOT NULL
);

CREATE TABLE "recipes" (
  "uuid" uuid PRIMARY KEY,
  "user_uuid" uuid NOT NULL,
  "recipe" text NOT NULL,
  "ingredient" text NOT NULL,
  "quantity" numeric,
  "unit" text,
  "section" text NOT NULL,
  "kCal" numeric
);

CREATE TABLE "lists" (
  "uuid" uuid PRIMARY KEY,
  "title" text NOT NULL,
  "checked" boolean NOT NULL,
  "ingredient" text NOT NULL,
  "quantity" numeric,
  "unit" text
);

CREATE TABLE "list_recipe" (
  "list_title" text,
  "recipe" text,
  PRIMARY KEY ("list_title", "recipe")
);

ALTER TABLE "users" ADD FOREIGN KEY ("role") REFERENCES "roles" ("role");

ALTER TABLE "users" ADD FOREIGN KEY ("language") REFERENCES "languages" ("language");

CREATE TABLE "users_avatars" (
  "users_uuid" uuid,
  "avatars_user_uuid" uuid,
  PRIMARY KEY ("users_uuid", "avatars_user_uuid")
);

ALTER TABLE "users_avatars" ADD FOREIGN KEY ("users_uuid") REFERENCES "users" ("uuid");

ALTER TABLE "users_avatars" ADD FOREIGN KEY ("avatars_user_uuid") REFERENCES "avatars" ("user_uuid");


ALTER TABLE "recipes" ADD FOREIGN KEY ("user_uuid") REFERENCES "users" ("uuid");

ALTER TABLE "recipes" ADD FOREIGN KEY ("section") REFERENCES "sections" ("section");
