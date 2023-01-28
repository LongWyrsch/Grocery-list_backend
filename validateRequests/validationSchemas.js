const { body } = require("express-validator");

module.exports.signupSchema = [
    body('email', 'password').exists({checkFalsy: true}).escape().isLength({ min: 6 }).matches(/[\w[\]`!@#$%^&*()={}:;<>+'-]*/), // [1] [2] [4]
    body('theme').matches(/^(light|dark)$/), 
    body('language').matches(/^(EN|DE|FR)$/)
]

module.exports.signinSchema = [
    body('email', 'password').exists({checkFalsy: true}).escape().isLength({ min: 6 }).matches('foo', /[\w[\]`!@#$%^&*()={}:;<>+'-]*/),
]

module.exports.updateUserSchema = [
    body('uuid').escape().isUUID(4),
    body('email', 'password').escape().isLength({ min: 6 }).matches(/[\w[\]`!@#$%^&*()={}:;<>+'-]*/),
    body('language').escape().matches(/^(EN|DE|FR)$/),
    body('theme').escape().matches(/^(light|dark)$/),
    body('google_name').escape(),
    body('avatar_variant').escape().matches(/^(beam|marble|pixel|sunset|bauhaus|ring)$/),
    body('avatar_colors.*').escape().isHexColor(),
    body('layouts_recipes.*.*.*','layouts_lists.lg.*.').escape(), // [3]
]

module.exports.joinRecipesSchema = [
    body('selectedRecipes.*').escape().isUUID(4)
]

module.exports.recipesSchema = [
    body('ingredients.*.uuid','ingredients.*.user_uuid','ingredients.*.card_uuid').escape().isUUID(),
    body('ingredients.*.title', 'ingredients.*.ingredient', 'ingredients.*.quantity', 'ingredients.*.unit', 'ingredients.*.section', 'ingredients.*.last_modified').escape(),
    body('ingredients.*.kcal').escape().isDecimal(),
    body('ingredients.*.index').escape().isInt()
]

module.exports.listsSchema = [
    body('ingredients.*.uuid','ingredients.*.user_uuid','ingredients.*.card_uuid').escape().isUUID(),
    body('ingredients.*.title', 'ingredients.*.ingredient', 'ingredients.*.quantity', 'ingredients.*.unit', 'ingredients.*.section', 'ingredients.*.last_modified').escape(),
    body('ingredients.*.index').escape().isInt(),
    body('ingredients.*.checked').escape().isBoolean(),
    body('ingredients.*.recipes.*').escape()
]

module.exports.deleteIngredientsSchema = [
    body('row_uuid.*').escape().isUUID(),
    body('card_uuid').escape().isUUID()
]



// [1]
// .exists() will check that the req.body has the key, ex {email: ...} .
// checkFalsy: true will make that the the value is not null. Othewise, {email: ''} will pass the test.

// [2]
// /[\w[\]`!@#$%^&*()={}:;<>+'-]*/    Validates all letters, numbers and scpedical characters except backslash \

// [3]
// star * means "all array items, or object keys", so 'layouts_recipes.*.*.*' gets all keys (x, y, w, h, ...) of all items in arrays of every keys (lg, md, sm, ...)

// [4]
// .escape() explanation: https://stackoverflow.com/questions/23995697/what-do-html-is-escaping-means

