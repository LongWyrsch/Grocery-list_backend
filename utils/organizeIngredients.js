function organizeIngredients(cardType, allIngredients) {
	let groupType = cardType === 'lists' ? 'title' : 'recipe';
    let organizedObject = {};
	let organizedArray = [];

	allIngredients.forEach((ingredients) => {
        // Ex: obj = { Lasagna : [{Ingredient:'Cheese', ...}] }
        //  obj.Lasagna = obj.Lasagna? [...obj.Lasagna, newIngredient] : [newIngredient]
		organizedObject[ingredients[groupType]] = organizedObject[ingredients[groupType]]
			? [...organizedObject[ingredients[groupType]], ingredients]
			: [ingredients];
	});

    // Convert { Lasagna: [{ingredient}, {ingredient},...] } to [ [{ingredient}, {ingredient},...], [{ingredient}, {ingredient},...],...]
	organizedArray = Object.values(organizedObject);

	return organizedArray;
}

module.exports = organizeIngredients;
