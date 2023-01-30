const { body } = require("express-validator");

module.exports.signupSchema = [
    body(['email', 'password']).exists({checkFalsy: true}).escape().isLength({ min: 6 }).matches(/[\w[\]`!@#$%^&*()={}:;<>+'-]*/), // [1] [2] [4]
    body('theme').matches(/^(light|dark)$/), 
    body('language').matches(/^(en|de|fr)$/)
]

module.exports.signinSchema = [
    body(['email', 'password']).exists({checkFalsy: true}).escape().isLength({ min: 6 }).matches(/[\w[\]`!@#$%^&*()={}:;<>+'-]*/),
]

module.exports.updateUserSchema = [
    body('updatedUser.uuid').optional({nullable: true, checkFalsy: true}).escape().isUUID(4),
    body(['updatedUser.email', 'updatedUser.password']).optional({nullable: true, checkFalsy: true}).escape().isLength({ min: 6 }).matches(/[\w[\]`!@#$%^&*()={}:;<>+'-]*/),
    body('updatedUser.language').optional({nullable: true, checkFalsy: true}).escape().matches(/^(en|de|fr)$/),
    body('updatedUser.theme').optional({nullable: true, checkFalsy: true}).escape().matches(/^(light|dark)$/),
    body('updatedUser.google_name').optional({nullable: true, checkFalsy: true}).escape(),
    body('updatedUser.avatar_variant').optional({nullable: true, checkFalsy: true}).escape().matches(/^(beam|marble|pixel|sunset|bauhaus|ring)$/),
    body('updatedUser.avatar_colors.*').optional({nullable: true, checkFalsy: true}).escape(),
    body('updatedUser.layouts_recipes.*.*.*','layouts_lists.lg.*.').optional({nullable: true, checkFalsy: true}).escape(), // [3]
]

module.exports.joinRecipesSchema = [
    body('selectedRecipes.*').escape().isUUID(4)
]

module.exports.recipesSchema = [
    body(['ingredients.*.uuid','ingredients.*.user_uuid','ingredients.*.card_uuid']).escape().isUUID(),
    body(['ingredients.*.title', 'ingredients.*.ingredient', 'ingredients.*.quantity', 'ingredients.*.unit', 'ingredients.*.section', 'ingredients.*.last_modified']).optional({nullable: true, checkFalsy: true}).escape(),
    body('ingredients.*.kcal').optional({nullable: true, checkFalsy: true}).escape().isDecimal(),
    body('ingredients.*.index').escape().isInt()
]

module.exports.listsSchema = [
    body(['ingredients.*.uuid','ingredients.*.user_uuid','ingredients.*.card_uuid']).escape().isUUID(),
    body(['ingredients.*.title', 'ingredients.*.ingredient', 'ingredients.*.quantity', 'ingredients.*.unit', 'ingredients.*.section', 'ingredients.*.last_modified']).optional({nullable: true, checkFalsy: true}).escape(),
    body('ingredients.*.index').escape().isInt(),
    body('ingredients.*.checked').escape().isBoolean(),
    body('ingredients.*.recipes.*').optional({nullable: true, checkFalsy: true}).escape()
]

module.exports.deleteIngredientsSchema = [
    body('row_uuid.*').optional({nullable: true, checkFalsy: true}).escape().isUUID(),
    body('card_uuid').optional({nullable: true, checkFalsy: true}).escape().isUUID()
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

