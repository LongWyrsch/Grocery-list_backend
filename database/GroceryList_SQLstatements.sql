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
('ENG'),
('DEU');

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
('meet'),
('seasonings'),
('grains'),
('other');

CREATE TABLE users (
  uuid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  email text UNIQUE NULL,
  hashedPassword text UNIQUE NULL,
  role text NOT NULL DEFAULT 'user' REFERENCES roles(role),
  language text NOT NULL REFERENCES languages(language),
  darkmode boolean NOT NULL,
  googleId text UNIQUE NULL,
  googleName text NULL
);

INSERT INTO users (email, hashedPassword, role, language, darkmode) VALUES
('long.nqw@gmail.com', '$2a$10$doYnT6kWg419.vCB7EO2K.6mLpP1Xyg2JmoLSohOLyJ5WlvPPz9t.', 'admin', 'ENG', true);

CREATE TABLE avatars (
  user_uuid uuid PRIMARY KEY REFERENCES users(uuid),
  variant text NOT NULL,
  colors varchar(6)[] NOT NULL
);

CREATE TABLE recipes (
  uuid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_uuid uuid NOT NULL REFERENCES users(uuid),
  recipe text NOT NULL,
  ingredient text NOT NULL,
  quantity numeric NULL,
  unit text NULL REFERENCES units(unit),
  section text NOT NULL REFERENCES sections(section),
  kCal numeric,
  index int2 NOT NULL
);

CREATE TABLE lists (
  uuid uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  title text NOT NULL,
  checked boolean NOT NULL,
  ingredient text NOT NULL,
  quantity numeric NULL,
  unit text NULL REFERENCES units(unit),
  user_uuid uuid NOT NULL REFERENCES users(uuid),
  section text NOT NULL REFERENCES sections(section),
  index int2 NOT NULL,
  last_modified timestamptz NOT NULL DEFAULT (now() at time zone 'utc')
);

CREATE TABLE lists_recipes (
  list_title text NOT NULL,
  recipe text NOT NULL,
  PRIMARY KEY (list_title, recipe)
);

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
-- INSERT BELOW VALUES AFTER CREATING ADMIN USER AND RETRIEVING ITS UUID
-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 

INSERT INTO recipes (user_uuid, recipe, ingredient, quantity, unit, section, kCal, index) VALUES
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Chili Bolognese', 'onions', 1, null, 'veggies', 44.0, 1),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Chili Bolognese', 'zuccinis', 1, null, 'veggies', 54.0, 2),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Chili Bolognese', 'garlic cloves', 2, null, 'veggies', 0.0, 3),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Chili Bolognese', 'cooking oil', 60, 'ml', 'seasonings', 503.9, 4),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Chili Bolognese', 'ground beef', 400, 'g', 'meat', 1328.0, 5),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Chili Bolognese', 'tomato paste', 156, 'ml', 'seasonings', 161.2, 6),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Chili Bolognese', 'chili powder', 0.25, 'tsp', 'seasonings', 1.9, 7),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Chili Bolognese', 'nutmeg', 0.25, 'tsp', 'seasonings', 3.0, 8),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Chili Bolognese', 'cream', 60, 'ml', 'dairies', 181.6, 9),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Chili Bolognese', 'parmesan cheese', 125, 'ml', 'dairies', 274.8, 10),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Chili Bolognese', 'salt', null, 'to taste', 'seasonings', 0.0, 11),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Chili Bolognese', 'pepper', null, 'to taste', 'seasonings', 0.0, 12),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Chili Bolognese', 'spaghetti', 375, 'g', 'grains', 1335.0, 13),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Lasagna', 'ground beef', 400, 'g', 'meat', 1328.0, 1),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Lasagna', 'cream', 200,	'ml', 'dairies', 605.2, 2),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Lasagna', 'lasagna seasonning', 2, 'bags', 'seasonings', 268.3, 3),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Lasagna', 'lasagna', 200, 'g', 'grains', 718.0, 4),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Lasagna', 'grated emmental cheese', 100, 'g', 'dairies', 368.0, 5),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Lasagna', 'canned diced tomato', 800, 'g', 'grains', 192.0, 6),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'rice noodles', 250, 'g', 'grains', 920.0, 1),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'tamarind puree', 3, 'tbsp', 'seasonings', 113.5, 2),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'brown sugar', 6, 'tbsp', 'seasonings', 330.3, 3),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'fish sauce', 4, 'tbsp', 'seasonings', 31.1, 4),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'oyster sauce', 3, 'tbsp', 'seasonings', 254.6, 5),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'cooking oil', 2, 'tbsp', 'seasonings', 248.6, 6),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'onion', 2, null, 'veggies', 88.0, 7),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'garlic cloves', 4, null, 'veggies', 0.0, 8),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'chicken', 400, 'g', 'meat', 660.0, 9),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'eggs', 4, null, 'dairies', 312.0, 10),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'beansprouts', 1000, 'ml', 'veggies', 82.8, 11),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'tofu (firm)', 500, 'g', 'dairies', 500.0, 12),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'green onions', 6, null, 'veggies', 30.0, 13),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'chopped peanuts', 100, 'g', 'other', 567.0, 14),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'lime', 1, null, 'veggies', 0.0, 15),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Pad thai', 'chili powder', null, 'to taste', 'seasonings', 0.0, 16),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Spaghetti Carbonara', 'bacon', 2, 'slices', 'meat', 10.8, 1),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Spaghetti Carbonara', 'green onions', 1, null, 'veggies', 5.0, 2),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Spaghetti Carbonara', 'eggs', 2, null, 'dairies', 156.0, 3),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Spaghetti Carbonara', 'cream', 125, 'ml', 'dairies', 378.3, 4),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Spaghetti Carbonara', 'parmesan cheese', 50, 'g', 'dairies', 215.5, 5),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Spaghetti Carbonara', 'spaghetti', 375, 'g', 'grains', 1335.0, 6),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai Green Curry', 'flat green beans', 100, 'g', 'veggies', 31.0, 1),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai Green Curry', 'cooking oil', 1, 'tbsp', 'seasonings', 124.3, 2),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai Green Curry', 'garlic cloves', 1, null, 'veggies', 0.0, 3),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai Green Curry', 'green curry paste', 1, 'tbsp', 'seasonings', 28.0, 4),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai Green Curry', 'coconut milk', 400, 'ml', 'seasonings', 852.7, 5),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai Green Curry', 'fish sauce', 2, 'tsp', 'seasonings', 5.1, 6),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai Green Curry', 'brown sugar', 1, 'tsp', 'seasonings', 18.2, 7),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai Green Curry', 'chicken', 500, 'g', 'meat', 825.0, 8),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai Green Curry', 'basil', null, 'to taste', 'veggies', 0.0, 9),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai Green Curry', 'rice', 6, 'servings', 'grains', 1734.0, 10),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai Green Curry', 'cherry tomatoes', 12, null, 'veggies', 2.2, 11);

INSERT INTO lists (user_uuid, title, checked, ingredient, quantity, unit, section, index) VALUES
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'garlic cloves', 2, null, 'veggies', 1),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'onion', 1, null, 'veggies', 2),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'zuccini', 1, null, 'veggies', 3),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'cream', 260, 'ml', 'dairies', 4),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'grated emmental cheese', 100, 'g', 'dairies', 5),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'parmesan cheese', 125, 'g', 'dairies', 6),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'ground beef', 800, 'g', 'meat', 7),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'chili powder', 0.25, 'tsp', 'seasonings', 8),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'cooking oil', 60, 'ml', 'seasonings', 9),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'lasagna seasonning', 2, 'bags', 'seasonings', 10),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'muskatnuss	0', 0.25, 'tsp' , 'seasonings', 11),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'pepper', null, 'to taste', 'seasonings', 12),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'salt', null, 'to taste', 'seasonings', 13),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'tomato paste', 156, 'ml', 'seasonings', 14),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'canned diced tomato', 800, 'g', 'grains', 15),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'lasagna', 200, 'g', 'grains', 16),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Italian', false, 'spaghetti', 375, 'g', 'grains', 17),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'basil', null, 'to taste', 'veggies', 1),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'beansprouts', 1000, 'ml', 'veggies', 2),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'cherry tomatoes', 12, null, 'veggies', 3),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'flat green beans', 100, 'g', 'veggies', 4),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'garlic cloves', 5, null, 'veggies', 5),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'green onions', 6, null, 'veggies', 6),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'lime', 1, null, 'veggies', 7),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'onion', 2, null, 'veggies', 8),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'eggs', 4, null, 'dairies', 9),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'tofu (firm)',	 00, 'g', 'dairies', 10),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'chicken', 900, 'g', 'meat', 11),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'brown sugar', 7, 'tbsp', 'seasonings', 12),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'chili powder', null, 'to taste', 'seasonings', 13),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'coconut milk', 400, 'ml', 'seasonings', 14),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'cooking oil', 3, 'tbsp', 'seasonings', 15),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'fish sauce', 6, 'tsp', 'seasonings', 16),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'green curry paste', 1, 'tbsp', 'seasonings', 17),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'oyster sauce', 3, 'tbsp', 'seasonings', 18),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'tamarind puree', 3, 'tbsp', 'seasonings', 19),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'rice', 6, 'servings', 'grains', 20),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'rice noodles', 250, 'g', 'grains', 21),
('f7490a89-0bab-495e-93c3-6ab02c4e9b2a', 'Thai', false, 'chopped peanuts', 100, 'g', 'other', 22);