function organizeIngredients(allIngredients) {
    let organizedObject = {};
	let organizedArray = [];

	allIngredients.forEach((ingredients) => {
        // Ex: obj = { uuid : [{Ingredient:'Cheese', ...}] }
        //  obj.Lasagna = obj.Lasagna? [...obj.Lasagna, newIngredient] : [newIngredient]
		organizedObject[ingredients['card_uuid']] = organizedObject[ingredients['card_uuid']]
			? [...organizedObject[ingredients['card_uuid']], ingredients]
			: [ingredients];
	});

    // Convert { Lasagna: [{ingredient}, {ingredient},...] } to [ [{ingredient}, {ingredient},...], [{ingredient}, {ingredient},...],...]
	organizedArray = Object.values(organizedObject);

	return organizedArray;
}

module.exports = organizeIngredients;
