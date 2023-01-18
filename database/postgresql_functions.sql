create or replace function join_ingredients(recipe_uuid text[], useruuid text)
returns TABLE(user_uuid uuid, ingredient text, quantity numeric, unit text, section text) 
language plpgsql
as $$
begin
RETURN QUERY SELECT r.user_uuid, r.ingredient, SUM(r.quantity), r.unit, r.section
FROM recipes as r
WHERE r.card_uuid::text = ANY(recipe_uuid) AND r.user_uuid = useruuid::uuid
GROUP BY r.user_uuid, r.ingredient, r.unit, r.section
ORDER BY CASE 
    WHEN r.section = 'veggies' THEN 1
    WHEN r.section = 'bread' THEN 2
    WHEN r.section = 'dairies' THEN 3
    WHEN r.section = 'meat' THEN 4
    WHEN r.section = 'seasonings' THEN 5
    WHEN r.section = 'grains' THEN 6
    WHEN r.section = 'other' THEN 7
    END;
end;
$$;










-- Run this to create the select_distinct function in the database.
-- You pass it a user uuid and either 'recipe' or 'list'.
-- It will correspondingly return you all distinct recipes or list for that user.
create or replace function select_distinct(querycolumn text, useruuid uuid)
returns TABLE(distinctvalues text)
language plpgsql
as $$
begin
if querycolumn = 'recipes' then
    return query select distinct card_uuid from recipes where user_uuid = useruuid;
elsif querycolumn = 'lists' then 
    return query select distinct card_uuid from lists where user_uuid = useruuid;
end if;
end;
$$;
-- Uncomment the below statement to test if the function works.
-- select * from select_distinct('recipe', 'f7490a89-0bab-495e-93c3-6ab02c4e9b2a')





create or replace function update_recipe_ingredients(ingredients json) 
returns setof recipes as 
$$
  update recipes as p set 
    title = x.title,
    index = x.index,
    ingredient = x.ingredient, 
    quantity = x.quantity, 
    unit = x.unit, 
    section = x.section, 
    kCal = x.kCal, 
    last_modified = x.last_modified,
    grid_position = x.grid_position
  from (
    select * from json_populate_recordset(null::recipes, ingredients)
  ) as x(uuid, user_uuid, card_uuid, title, index, ingredient, quantity, unit, section, kCal, last_modified, grid_position)
  where p.uuid = x.uuid   
  returning p.*;    
$$ language sql;