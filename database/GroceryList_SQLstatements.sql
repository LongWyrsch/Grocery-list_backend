CREATE TABLE roles (
  role text PRIMARY KEY
);

INSERT INTO roles (role) VALUES 
('user'),
('admin');

CREATE TABLE languages (
  language text PRIMARY KEY
);

INSERT INTO languages (language) VALUES 
('DE'),
('EN'),
('FR');

-- CREATE TABLE units (
--   unit text PRIMARY KEY
-- );

-- INSERT INTO units (unit) VALUES 
-- ('ml'),
-- ('g'),
-- ('tsp'),
-- ('tbsp'),
-- ('bags'),
-- ('to taste'),
-- ('slices'),
-- ('servings');

CREATE TABLE sections (
  section text PRIMARY KEY
);

INSERT INTO sections (section) VALUES 
('veggies'),
('bread'),
('dairies'),
('meat'),
('seasonings'),
('grains'),
('other');

CREATE TABLE users (
  uuid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  email text UNIQUE NULL,
  hashed_password text UNIQUE NULL,
  google_id text UNIQUE NULL,
  google_name text NULL,
  role text NOT NULL DEFAULT 'user' REFERENCES roles(role),
  language text NOT NULL DEFAULT 'EN' REFERENCES languages(language),
  theme text NOT NULL DEFAULT light,
  avatar_variant text NOT NULL,
  avatar_colors varchar(7)[5] NOT NULL,
  layouts_recipes json NULL,
  layouts_lists json NULL
);

INSERT INTO users (email, hashed_password, role, language, theme, avatar_variant, avatar_colors, layouts_recipes) VALUES
('long.nqw@gmail.com', '$2a$10$HBuJAleF8IVQUUjvsnnmnucnyFrkdvYqM82FEuvfPI.zMXpoPih7O', 'admin', 'EN', true, 'beam', ARRAY ['#92A1C6','#146A7C','#F0AB3D','#C271B4','#C20D90'], {"lg":[{"w":2,"h":5,"x":4,"y":0,"i":"67ae76c8-e973-43d3-8981-c99ba6400a27","minW":2,"maxW":2,"minH":1,"maxH":40,"moved":false,"static":false,"isBounded":true},{"w":2,"h":4,"x":0,"y":5,"i":"7df29237-e60f-4a29-9834-e0d196fa98e3","minW":2,"maxW":2,"minH":1,"maxH":40,"moved":false,"static":false,"isBounded":true},{"w":2,"h":5,"x":0,"y":0,"i":"9d9995e2-ac8a-4f5a-8485-801d17143e4f","minW":2,"maxW":2,"minH":1,"maxH":40,"moved":false,"static":false,"isBounded":true},{"w":2,"h":4,"x":6,"y":0,"i":"a6bf5db6-b76b-43af-a963-fab17017d731","minW":2,"maxW":2,"minH":1,"maxH":40,"moved":false,"static":false,"isBounded":true},{"w":2,"h":4,"x":2,"y":0,"i":"6aa80830-8ecc-49b7-958c-9aa6a7b89658","minW":2,"maxW":2,"minH":1,"maxH":40,"moved":false,"static":false,"isBounded":true}]});

CREATE TABLE recipes (
  uuid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_uuid uuid NOT NULL REFERENCES users(uuid),
  card_uuid uuid NOT NULL,
  title text NOT NULL,
  index int NOT NULL,
  ingredient text NOT NULL,
  quantity numeric NULL,
  unit text NULL,
  section text NOT NULL REFERENCES sections(section),
  kcal text NULL,
  last_modified timestamp with time zone NOT NULL DEFAULT (now() at time zone 'utc'),
  -- grid_position json NULL
);

CREATE TABLE lists (
  uuid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_uuid uuid NOT NULL REFERENCES users(uuid),
  card_uuid uuid NOT NULL,
  title text NOT NULL,
  index int NOT NULL,
  ingredient text NOT NULL,
  quantity numeric NULL,
  unit text NULL,
  section text NOT NULL REFERENCES sections(section),
  checked boolean NOT NULL,
  recipes text[] NOT NULL,
  last_modified timestamp with time zone NOT NULL DEFAULT (now() at time zone 'utc'),
  -- grid_position json NULL
);

-- CREATE TABLE lists_recipes (
--   list_card_uuid text NOT NULL lists(card_uuid),
--   recipe_card_uuid text NOT NULL recipes(card_uuid),
--   PRIMARY KEY (list_title, recipe)
-- );

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
-- INSERT BELOW VALUES AFTER CREATING ADMIN USER AND RETRIEVING ITS UUID
-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 

INSERT INTO recipes (user_uuid, card_uuid, title, index, ingredient, quantity, unit, section, kcal, last_modified) VALUES
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 1, 'onions', 1, null, 'veggies', 44.0, '2022-12-30 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 2, 'zuccinis', 1, null, 'veggies', 54.0, '2022-12-30 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 3, 'garlic cloves', 2, null, 'veggies', 0.0, '2022-12-30 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 4, 'cooking oil', 60, 'ml', 'seasonings', 503.9, '2022-12-30 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 5, 'ground beef', 400, 'g', 'meat', 1328.0, '2022-12-30 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 6, 'tomato paste', 156, 'ml', 'seasonings', 161.2, '2022-12-30 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 7, 'chili powder', 0.25, 'tsp', 'seasonings', 1.9, '2022-12-30 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 8, 'nutmeg', 0.25, 'tsp', 'seasonings', 3.0, '2022-12-30 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 9, 'cream', 60, 'ml', 'dairies', 181.6, '2022-12-30 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 10, 'parmesan cheese', 125, 'ml', 'dairies', 274.8, '2022-12-30 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 11, 'salt', null, 'to taste', 'seasonings', 0.0, '2022-12-30 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 12, 'pepper', null, 'to taste', 'seasonings', 0.0, '2022-12-30 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 13, 'spaghetti', 375, 'g', 'grains', 1335.0, '2022-12-30 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '6aa80830-8ecc-49b7-958c-9aa6a7b89658', 'Lasagna', 1, 'ground beef', 400, 'g', 'meat', 1328.0, '2022-12-29 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '6aa80830-8ecc-49b7-958c-9aa6a7b89658', 'Lasagna', 2, 'cream', 200, 'ml', 'dairies', 605.2, '2022-12-29 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '6aa80830-8ecc-49b7-958c-9aa6a7b89658', 'Lasagna', 3, 'lasagna seasonings', 2, 'bags', 'seasonings', 268.3, '2022-12-29 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '6aa80830-8ecc-49b7-958c-9aa6a7b89658', 'Lasagna', 4, 'lasagna', 200, 'g', 'grains', 718.0, '2022-12-29 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '6aa80830-8ecc-49b7-958c-9aa6a7b89658', 'Lasagna', 5, 'grated emmental cheese', 100, 'g', 'dairies', 368.0, '2022-12-29 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '6aa80830-8ecc-49b7-958c-9aa6a7b89658', 'Lasagna', 6, 'canned diced tomato', 800, 'g', 'grains', 192.0, '2022-12-29 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 1, 'rice noodles', 250, 'g', 'grains', 920.0, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 2, 'tamarind puree', 3, 'tbsp', 'seasonings', 113.5, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 3, 'brown sugar', 6, 'tbsp', 'seasonings', 330.3, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 4, 'fish sauce', 4, 'tbsp', 'seasonings', 31.1, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 5, 'oyster sauce', 3, 'tbsp', 'seasonings', 254.6, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 6, 'cooking oil', 2, 'tbsp', 'seasonings', 248.6, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 7, 'onion', 2, null, 'veggies', 88.0, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 8, 'garlic cloves', 4, null, 'veggies', 0.0, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 9, 'chicken', 400, 'g', 'meat', 660.0, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 10, 'eggs', 4, null, 'dairies', 312.0, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 11, 'beansprouts', 1000, 'ml', 'veggies', 82.8, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 12, 'tofu (firm)', 500, 'g', 'dairies', 500.0, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 13, 'green onions', 6, null, 'veggies', 30.0, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 14, 'chopped peanuts', 100, 'g', 'other', 567.0, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 15, 'lime', 1, null, 'veggies', 0.0, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 16, 'chili powder', null, 'to taste', 'seasonings', 0.0, '2022-12-28 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'a6bf5db6-b76b-43af-a963-fab17017d731', 'Spaghetti Carbonara', 1, 'bacon', 2, 'slices', 'meat', 10.8, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'a6bf5db6-b76b-43af-a963-fab17017d731', 'Spaghetti Carbonara', 2, 'green onions', 1, null, 'veggies', 5.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'a6bf5db6-b76b-43af-a963-fab17017d731', 'Spaghetti Carbonara', 3, 'eggs', 2, null, 'dairies', 156.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'a6bf5db6-b76b-43af-a963-fab17017d731', 'Spaghetti Carbonara', 4, 'cream', 125, 'ml', 'dairies', 378.3, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'a6bf5db6-b76b-43af-a963-fab17017d731', 'Spaghetti Carbonara', 5, 'parmesan cheese', 50, 'g', 'dairies', 215.5, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'a6bf5db6-b76b-43af-a963-fab17017d731', 'Spaghetti Carbonara', 6, 'spaghetti', 375, 'g', 'grains', 1335.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 1, 'flat green beans', 100, 'g', 'veggies', 31.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 2, 'cooking oil', 1, 'tbsp', 'seasonings', 124.3, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 3, 'garlic cloves', 1, null, 'veggies', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 4, 'green curry paste', 1, 'tbsp', 'seasonings', 28.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 5, 'coconut milk', 400, 'ml', 'seasonings', 852.7, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 6, 'fish sauce', 2, 'tsp', 'seasonings', 5.1, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 7, 'brown sugar', 1, 'tsp', 'seasonings', 18.2, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 8, 'chicken', 500, 'g', 'meat', 825.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 9, 'basil', null, 'to taste', 'veggies', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 10, 'rice', 6, 'servings', 'grains', 1734.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 11, 'cherry tomatoes', 12, null, 'veggies', 2.2, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '306e4341-9cba-4c67-96b8-601d6977fcf4', 'Beef, broccoli, tofu rice', 0, 'tofu (firm)', 500, 'g', 'dairies', 500.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '306e4341-9cba-4c67-96b8-601d6977fcf4', 'Beef, broccoli, tofu rice', 1, 'cooking oil', 3, 'tsp', 'seasonings', 123.5, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '306e4341-9cba-4c67-96b8-601d6977fcf4', 'Beef, broccoli, tofu rice', 2, 'ground beef', 400, 'g', 'meat', 1328.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '306e4341-9cba-4c67-96b8-601d6977fcf4', 'Beef, broccoli, tofu rice', 3, 'broccoli', 1, null, 'veggies', 150.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '306e4341-9cba-4c67-96b8-601d6977fcf4', 'Beef, broccoli, tofu rice', 4, 'oyster sauce', 125, 'ml', 'seasonings', 716.8, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '306e4341-9cba-4c67-96b8-601d6977fcf4', 'Beef, broccoli, tofu rice', 5, 'onion', 1, null, 'veggies', 44.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '306e4341-9cba-4c67-96b8-601d6977fcf4', 'Beef, broccoli, tofu rice', 6, 'salt', null, 'to taste', 'seasonings', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '306e4341-9cba-4c67-96b8-601d6977fcf4', 'Beef, broccoli, tofu rice', 7, 'pepper', null, 'to taste', 'seasonings', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '306e4341-9cba-4c67-96b8-601d6977fcf4', 'Beef, broccoli, tofu rice', 8, 'rice', 6 , 'rice servings', 'grains', 1734.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 0, 'spicy sausages', 400, 'g', 'meat', 1188.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 1, 'cooking oil', 75 , 'ml', 'seasonings', 629.9, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 2, 'onion', 1, null, 'veggies', 44.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 3, 'red bell pepper', 1, null, 'veggies', 37.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 4, 'cumin', 1 , 'tsp', 'seasonings', 10.5, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 5, 'paprika', 0.5 , 'tsp', 'seasonings', 3.2, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 6, 'curcuma', 0.5 , 'tsp', 'seasonings', 3.1, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 7, 'zuccini', 1, null, 'veggies', 54.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 8, 'garlic cloves', 2, null, 'veggies', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 9, 'tomato paste', 2 , 'tbsp', 'seasonings', 30.6, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 10, 'lemon juice', 2 , 'tbsp', 'seasonings', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 11, 'harissa sauce', 1 , 'tsp', 'seasonings', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 12, 'pine nuts', 150 , 'ml', 'other', 575.4, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 13, 'chicken broth', 500 , 'ml', 'seasonings', 10.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 14, 'dried raisins sultana', 250 , 'ml', 'other', 540.6, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 15, 'couscous', 500 , 'ml', 'grains', 408.8, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 16, 'salt', null, 'to taste', 'seasonings', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '27c41247-f759-494e-bb38-d103f854e7d1', 'Tunesian couscous', 17, 'pepper', null, 'to taste', 'seasonings', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '056f1619-a2ca-4a30-9426-dea1b3439339', 'Kema curry', 0, 'rice', 4 , 'rice servings', 'grains', 1156.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '056f1619-a2ca-4a30-9426-dea1b3439339', 'Kema curry', 1, 'ground beef', 400 , 'g', 'meat', 1328.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '056f1619-a2ca-4a30-9426-dea1b3439339', 'Kema curry', 2, 'zuccini', 1, null, 'veggies', 54.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '056f1619-a2ca-4a30-9426-dea1b3439339', 'Kema curry', 3, 'onion', 1, null, 'veggies', 44.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '056f1619-a2ca-4a30-9426-dea1b3439339', 'Kema curry', 4, 'garlic cloves', 2, null, 'veggies', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '056f1619-a2ca-4a30-9426-dea1b3439339', 'Kema curry', 5, 'ginger', 2 , 'tsp', 'veggies', 3.2, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '056f1619-a2ca-4a30-9426-dea1b3439339', 'Kema curry', 6, 'canned diced tomato', 400 , 'g', 'grains', 96.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '056f1619-a2ca-4a30-9426-dea1b3439339', 'Kema curry', 7, 'curry powder', 4 , 'tbsp', 'seasonings', 78.9, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '056f1619-a2ca-4a30-9426-dea1b3439339', 'Kema curry', 8, 'plain yogurt', 8 , 'tbsp', 'dairies', 75.1, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '056f1619-a2ca-4a30-9426-dea1b3439339', 'Kema curry', 9, 'cooking oil', 4 , 'tbsp', 'seasonings', 497.2, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '056f1619-a2ca-4a30-9426-dea1b3439339', 'Kema curry', 10, 'butter', 3 , 'tbsp', 'dairies', 305.6, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '056f1619-a2ca-4a30-9426-dea1b3439339', 'Kema curry', 11, 'salt', null, 'to taste', 'seasonings', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '056f1619-a2ca-4a30-9426-dea1b3439339', 'Kema curry', 12, 'pepper', null, 'to taste', 'seasonings', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 0, 'beef', 500 , 'g', 'meat', 1500.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 1, 'cooking oil', 3 , 'tbsp', 'seasonings', 372.9, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 2, 'salt', null, 'to taste', 'seasonings', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 3, 'pepper',null, 'to taste', 'seasonings', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 4, 'condensed beef broth', 2 , 'tsp', 'seasonings', 0.4, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 5, 'bitter beer', 150 , 'ml', 'other', 0.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 6, 'carrots', 1, null, 'veggies', 0.4, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 7, 'onion', 1, null, 'veggies', 44.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 8, 'sugar', 1, 'tsp', 'seasonings', 16.7, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 9, 'tomato paste', 2 , 'tbsp', 'seasonings', 30.6, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 10, 'mushroom', 300 , 'g', 'veggies', 39.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 11, 'flour', 3 , 'tbsp', 'seasonings', 95.4, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 12, 'butter', 4 , 'tbsp', 'dairies', 407.5, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '61621a51-3ae1-4b87-b7de-42261cf174ec', 'Beef pie', 13, 'pie pastry', 500 , 'g', 'grains', 2000.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'd2901db9-8ab3-4fed-8fd2-e44238fd5e2e', 'Oyakodon', 14, 'eggs', 8, null, 'dairies', 624.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'd2901db9-8ab3-4fed-8fd2-e44238fd5e2e', 'Oyakodon', 15, 'chicken', 600 , 'g', 'meat', 990.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'd2901db9-8ab3-4fed-8fd2-e44238fd5e2e', 'Oyakodon', 16, 'onion', 1, null, 'veggies', 44.0, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'd2901db9-8ab3-4fed-8fd2-e44238fd5e2e', 'Oyakodon', 17, 'soy sauce', 4 , 'tbsp', 'seasonings', 33.9, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'd2901db9-8ab3-4fed-8fd2-e44238fd5e2e', 'Oyakodon', 18, 'mirin', 4 , 'tbsp', 'seasonings', 203.2, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'd2901db9-8ab3-4fed-8fd2-e44238fd5e2e', 'Oyakodon', 19, 'sake', 2 , 'tbsp', 'seasonings', 35.3, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'd2901db9-8ab3-4fed-8fd2-e44238fd5e2e', 'Oyakodon', 20, 'sugar', 2 , 'tbsp', 'seasonings', 100.6, '2022-12-27 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'd2901db9-8ab3-4fed-8fd2-e44238fd5e2e', 'Oyakodon', 21, 'rice', 4, 'rice servings', 'grains', 1156.0, '2022-12-27 00:01:00+02'::timestamptz);

INSERT INTO lists (user_uuid, card_uuid, title, index, ingredient, quantity, unit, section, checked, recipes, last_modified) VALUES
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 1, 'garlic cloves', 2, null, 'veggies', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 2, 'onion', 1, null, 'veggies', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 3, 'zuccini', 1, null, 'veggies', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 4, 'cream', 260, 'ml', 'dairies', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 5, 'grated emmental cheese', 100, 'g', 'dairies', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 6, 'parmesan cheese', 125, 'g', 'dairies', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 7, 'ground beef', 800, 'g', 'meat', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 8, 'chili powder', 0.25, 'tsp', 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 9, 'cooking oil', 60, 'ml', 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 10, 'lasagna seasonings', 2, 'bags', 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 11, 'muskatnuss	0', 0.25, 'tsp' , 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 12, 'pepper', null, 'to taste', 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 13, 'salt', null, 'to taste', 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 14, 'tomato paste', 156, 'ml', 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 15, 'canned diced tomato', 800, 'g', 'grains', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 16, 'lasagna', 200, 'g', 'grains', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 17, 'spaghetti', 375, 'g', 'grains', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 1, 'basil', null, 'to taste', 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 2, 'beansprouts', 1000, 'ml', 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 3, 'cherry tomatoes', 12, null, 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 4, 'flat green beans', 100, 'g', 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 5, 'garlic cloves', 5, null, 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 6, 'green onions', 6, null, 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-05 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 7, 'lime', 1, null, 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 8, 'onion', 2, null, 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 9, 'eggs', 4, null, 'dairies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 10, 'tofu (firm)',	 00, 'g', 'dairies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 11, 'chicken', 900, 'g', 'meat', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 12, 'brown sugar', 7, 'tbsp', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 13, 'chili powder', null, 'to taste', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 14, 'coconut milk', 400, 'ml', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 15, 'cooking oil', 3, 'tbsp', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 16, 'fish sauce', 6, 'tsp', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 17, 'green curry paste', 1, 'tbsp', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 18, 'oyster sauce', 3, 'tbsp', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 19, 'tamarind puree', 3, 'tbsp', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 20, 'rice', 6, 'servings', 'grains', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 21, 'rice noodles', 250, 'g', 'grains', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz),
('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 22, 'chopped peanuts', 100, 'g', 'other', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz);

-- INSERT INTO recipes (user_uuid, card_uuid, title, index, ingredient, quantity, unit, section, kCal, last_modified) VALUES
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 1, 'onions', 1, null, 'veggies', 44.0, '2022-12-30 00:01:00+02'::timestamptz, '{"i": "9d9995e2-ac8a-4f5a-8485-801d17143e4f", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 2, 'zuccinis', 1, null, 'veggies', 54.0, '2022-12-30 00:01:00+02'::timestamptz, '{"i": "9d9995e2-ac8a-4f5a-8485-801d17143e4f", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 3, 'garlic cloves', 2, null, 'veggies', 0.0, '2022-12-30 00:01:00+02'::timestamptz, '{"i": "9d9995e2-ac8a-4f5a-8485-801d17143e4f", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 4, 'cooking oil', 60, 'ml', 'seasonings', 503.9, '2022-12-30 00:01:00+02'::timestamptz, '{"i": "9d9995e2-ac8a-4f5a-8485-801d17143e4f", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 5, 'ground beef', 400, 'g', 'meat', 1328.0, '2022-12-30 00:01:00+02'::timestamptz, '{"i": "9d9995e2-ac8a-4f5a-8485-801d17143e4f", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 6, 'tomato paste', 156, 'ml', 'seasonings', 161.2, '2022-12-30 00:01:00+02'::timestamptz, '{"i": "9d9995e2-ac8a-4f5a-8485-801d17143e4f", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 7, 'chili powder', 0.25, 'tsp', 'seasonings', 1.9, '2022-12-30 00:01:00+02'::timestamptz, '{"i": "9d9995e2-ac8a-4f5a-8485-801d17143e4f", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 8, 'nutmeg', 0.25, 'tsp', 'seasonings', 3.0, '2022-12-30 00:01:00+02'::timestamptz, '{"i": "9d9995e2-ac8a-4f5a-8485-801d17143e4f", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 9, 'cream', 60, 'ml', 'dairies', 181.6, '2022-12-30 00:01:00+02'::timestamptz, '{"i": "9d9995e2-ac8a-4f5a-8485-801d17143e4f", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 10, 'parmesan cheese', 125, 'ml', 'dairies', 274.8, '2022-12-30 00:01:00+02'::timestamptz, '{"i": "9d9995e2-ac8a-4f5a-8485-801d17143e4f", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 11, 'salt', null, 'to taste', 'seasonings', 0.0, '2022-12-30 00:01:00+02'::timestamptz, '{"i": "9d9995e2-ac8a-4f5a-8485-801d17143e4f", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 12, 'pepper', null, 'to taste', 'seasonings', 0.0, '2022-12-30 00:01:00+02'::timestamptz, '{"i": "9d9995e2-ac8a-4f5a-8485-801d17143e4f", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '9d9995e2-ac8a-4f5a-8485-801d17143e4f', 'Chili Bolognese', 13, 'spaghetti', 375, 'g', 'grains', 1335.0, '2022-12-30 00:01:00+02'::timestamptz, '{"i": "9d9995e2-ac8a-4f5a-8485-801d17143e4f", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '6aa80830-8ecc-49b7-958c-9aa6a7b89658', 'Lasagna', 1, 'ground beef', 400, 'g', 'meat', 1328.0, '2022-12-29 00:01:00+02'::timestamptz, '{"i": "6aa80830-8ecc-49b7-958c-9aa6a7b89658", "x": 2, "y": 0, "w": 2, "h": 3, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '6aa80830-8ecc-49b7-958c-9aa6a7b89658', 'Lasagna', 2, 'cream', 200,	'ml', 'dairies', 605.2, '2022-12-29 00:01:00+02'::timestamptz, '{"i": "6aa80830-8ecc-49b7-958c-9aa6a7b89658", "x": 2, "y": 0, "w": 2, "h": 3, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '6aa80830-8ecc-49b7-958c-9aa6a7b89658', 'Lasagna', 3, 'lasagna seasonings', 2, 'bags', 'seasonings', 268.3, '2022-12-29 00:01:00+02'::timestamptz, '{"i": "6aa80830-8ecc-49b7-958c-9aa6a7b89658", "x": 2, "y": 0, "w": 2, "h": 3, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '6aa80830-8ecc-49b7-958c-9aa6a7b89658', 'Lasagna', 4, 'lasagna', 200, 'g', 'grains', 718.0, '2022-12-29 00:01:00+02'::timestamptz, '{"i": "6aa80830-8ecc-49b7-958c-9aa6a7b89658", "x": 2, "y": 0, "w": 2, "h": 3, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '6aa80830-8ecc-49b7-958c-9aa6a7b89658', 'Lasagna', 5, 'grated emmental cheese', 100, 'g', 'dairies', 368.0, '2022-12-29 00:01:00+02'::timestamptz, '{"i": "6aa80830-8ecc-49b7-958c-9aa6a7b89658", "x": 2, "y": 0, "w": 2, "h": 3, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '6aa80830-8ecc-49b7-958c-9aa6a7b89658', 'Lasagna', 6, 'canned diced tomato', 800, 'g', 'grains', 192.0, '2022-12-29 00:01:00+02'::timestamptz, '{"i": "6aa80830-8ecc-49b7-958c-9aa6a7b89658", "x": 2, "y": 0, "w": 2, "h": 3, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 1, 'rice noodles', 250, 'g', 'grains', 920.0, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 2, 'tamarind puree', 3, 'tbsp', 'seasonings', 113.5, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 3, 'brown sugar', 6, 'tbsp', 'seasonings', 330.3, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 4, 'fish sauce', 4, 'tbsp', 'seasonings', 31.1, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 5, 'oyster sauce', 3, 'tbsp', 'seasonings', 254.6, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 6, 'cooking oil', 2, 'tbsp', 'seasonings', 248.6, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 7, 'onion', 2, null, 'veggies', 88.0, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 8, 'garlic cloves', 4, null, 'veggies', 0.0, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 9, 'chicken', 400, 'g', 'meat', 660.0, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 10, 'eggs', 4, null, 'dairies', 312.0, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 11, 'beansprouts', 1000, 'ml', 'veggies', 82.8, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 12, 'tofu (firm)', 500, 'g', 'dairies', 500.0, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 13, 'green onions', 6, null, 'veggies', 30.0, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 14, 'chopped peanuts', 100, 'g', 'other', 567.0, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 15, 'lime', 1, null, 'veggies', 0.0, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '67ae76c8-e973-43d3-8981-c99ba6400a27', 'Pad thai', 16, 'chili powder', null, 'to taste', 'seasonings', 0.0, '2022-12-28 00:01:00+02'::timestamptz, '{"i": "67ae76c8-e973-43d3-8981-c99ba6400a27", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'a6bf5db6-b76b-43af-a963-fab17017d731', 'Spaghetti Carbonara', 1, 'bacon', 2, 'slices', 'meat', 10.8, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "a6bf5db6-b76b-43af-a963-fab17017d731", "x": 6, "y": 0, "w": 2, "h": 3, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'a6bf5db6-b76b-43af-a963-fab17017d731', 'Spaghetti Carbonara', 2, 'green onions', 1, null, 'veggies', 5.0, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "a6bf5db6-b76b-43af-a963-fab17017d731", "x": 6, "y": 0, "w": 2, "h": 3, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'a6bf5db6-b76b-43af-a963-fab17017d731', 'Spaghetti Carbonara', 3, 'eggs', 2, null, 'dairies', 156.0, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "a6bf5db6-b76b-43af-a963-fab17017d731", "x": 6, "y": 0, "w": 2, "h": 3, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'a6bf5db6-b76b-43af-a963-fab17017d731', 'Spaghetti Carbonara', 4, 'cream', 125, 'ml', 'dairies', 378.3, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "a6bf5db6-b76b-43af-a963-fab17017d731", "x": 6, "y": 0, "w": 2, "h": 3, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'a6bf5db6-b76b-43af-a963-fab17017d731', 'Spaghetti Carbonara', 5, 'parmesan cheese', 50, 'g', 'dairies', 215.5, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "a6bf5db6-b76b-43af-a963-fab17017d731", "x": 6, "y": 0, "w": 2, "h": 3, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'a6bf5db6-b76b-43af-a963-fab17017d731', 'Spaghetti Carbonara', 6, 'spaghetti', 375, 'g', 'grains', 1335.0, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "a6bf5db6-b76b-43af-a963-fab17017d731", "x": 6, "y": 0, "w": 2, "h": 3, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 1, 'flat green beans', 100, 'g', 'veggies', 31.0, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "7df29237-e60f-4a29-9834-e0d196fa98e3", "x": 0, "y": 6, "w": 2, "h": 4, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 2, 'cooking oil', 1, 'tbsp', 'seasonings', 124.3, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "7df29237-e60f-4a29-9834-e0d196fa98e3", "x": 0, "y": 6, "w": 2, "h": 4, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 3, 'garlic cloves', 1, null, 'veggies', 0.0, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "7df29237-e60f-4a29-9834-e0d196fa98e3", "x": 0, "y": 6, "w": 2, "h": 4, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 4, 'green curry paste', 1, 'tbsp', 'seasonings', 28.0, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "7df29237-e60f-4a29-9834-e0d196fa98e3", "x": 0, "y": 6, "w": 2, "h": 4, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 5, 'coconut milk', 400, 'ml', 'seasonings', 852.7, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "7df29237-e60f-4a29-9834-e0d196fa98e3", "x": 0, "y": 6, "w": 2, "h": 4, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 6, 'fish sauce', 2, 'tsp', 'seasonings', 5.1, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "7df29237-e60f-4a29-9834-e0d196fa98e3", "x": 0, "y": 6, "w": 2, "h": 4, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 7, 'brown sugar', 1, 'tsp', 'seasonings', 18.2, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "7df29237-e60f-4a29-9834-e0d196fa98e3", "x": 0, "y": 6, "w": 2, "h": 4, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 8, 'chicken', 500, 'g', 'meat', 825.0, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "7df29237-e60f-4a29-9834-e0d196fa98e3", "x": 0, "y": 6, "w": 2, "h": 4, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 9, 'basil', null, 'to taste', 'veggies', 0.0, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "7df29237-e60f-4a29-9834-e0d196fa98e3", "x": 0, "y": 6, "w": 2, "h": 4, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 10, 'rice', 6, 'servings', 'grains', 1734.0, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "7df29237-e60f-4a29-9834-e0d196fa98e3", "x": 0, "y": 6, "w": 2, "h": 4, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', '7df29237-e60f-4a29-9834-e0d196fa98e3', 'Thai Green Curry', 11, 'cherry tomatoes', 12, null, 'veggies', 2.2, '2022-12-27 00:01:00+02'::timestamptz, '{"i": "7df29237-e60f-4a29-9834-e0d196fa98e3", "x": 0, "y": 6, "w": 2, "h": 4, "minW": 2, "maxW": 2, "minH": 1, "maxH": 40, "isBounded": true}');

-- INSERT INTO lists (user_uuid, card_uuid, title, index, ingredient, quantity, unit, section, checked, recipes, last_modified) VALUES
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 1, 'garlic cloves', 2, null, 'veggies', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 2, 'onion', 1, null, 'veggies', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 3, 'zuccini', 1, null, 'veggies', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 4, 'cream', 260, 'ml', 'dairies', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 5, 'grated emmental cheese', 100, 'g', 'dairies', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 6, 'parmesan cheese', 125, 'g', 'dairies', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 7, 'ground beef', 800, 'g', 'meat', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 8, 'chili powder', 0.25, 'tsp', 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 9, 'cooking oil', 60, 'ml', 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 10, 'lasagna seasonings', 2, 'bags', 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 11, 'muskatnuss	0', 0.25, 'tsp' , 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 12, 'pepper', null, 'to taste', 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 13, 'salt', null, 'to taste', 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 14, 'tomato paste', 156, 'ml', 'seasonings', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 15, 'canned diced tomato', 800, 'g', 'grains', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 16, 'lasagna', 200, 'g', 'grains', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'f60b5f34-5451-44d9-869c-2c42149b8139', 'Italian', 17, 'spaghetti', 375, 'g', 'grains', false, ARRAY ['Chili Bolognese', 'Lasagna', 'Spaghetti Carbonara'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "f60b5f34-5451-44d9-869c-2c42149b8139", "x": 0, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 1, 'basil', null, 'to taste', 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 2, 'beansprouts', 1000, 'ml', 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 3, 'cherry tomatoes', 12, null, 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 4, 'flat green beans', 100, 'g', 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 5, 'garlic cloves', 5, null, 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 6, 'green onions', 6, null, 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-05 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 7, 'lime', 1, null, 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 8, 'onion', 2, null, 'veggies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 9, 'eggs', 4, null, 'dairies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 10, 'tofu (firm)',	 00, 'g', 'dairies', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 11, 'chicken', 900, 'g', 'meat', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 12, 'brown sugar', 7, 'tbsp', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 13, 'chili powder', null, 'to taste', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 14, 'coconut milk', 400, 'ml', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 15, 'cooking oil', 3, 'tbsp', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 16, 'fish sauce', 6, 'tsp', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 17, 'green curry paste', 1, 'tbsp', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 18, 'oyster sauce', 3, 'tbsp', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 19, 'tamarind puree', 3, 'tbsp', 'seasonings', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 20, 'rice', 6, 'servings', 'grains', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 21, 'rice noodles', 250, 'g', 'grains', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}'),
-- ('5e08e3ee-b46e-46e4-a672-b364ed62c6a9', 'aa90030a-355b-4b33-a9b0-c5673b524f90', 'Thai', 22, 'chopped peanuts', 100, 'g', 'other', false, ARRAY ['Pad Thai', 'Thai Green Curry'], '2023-01-04 00:01:00+02'::timestamptz, '{"i": "aa90030a-355b-4b33-a9b0-c5673b524f90", "x": 4, "y": 0, "w": 2, "h": 5, "minW": 1, "maxW": 5, "minH": 1, "maxH": 40, "isBounded": true}');

-- INSERT INTO lists_recipes (list_card_uuid, recipe_card_uuid) VALUES
-- ('f60b5f34-5451-44d9-869c-2c42149b8139','9d9995e2-ac8a-4f5a-8485-801d17143e4f')
-- ('f60b5f34-5451-44d9-869c-2c42149b8139','6aa80830-8ecc-49b7-958c-9aa6a7b89658')
-- ('f60b5f34-5451-44d9-869c-2c42149b8139','a6bf5db6-b76b-43af-a963-fab17017d731')
-- ('aa90030a-355b-4b33-a9b0-c5673b524f90','67ae76c8-e973-43d3-8981-c99ba6400a27')
-- ('aa90030a-355b-4b33-a9b0-c5673b524f90','7df29237-e60f-4a29-9834-e0d196fa98e3')



