async function getKcal (ingredient, quantity, unit) {
	if (!['ml', 'L', 'g', 'kg', 'tsp', 'tbsp', 'cup'].includes(unit)) {
		return '-';
	}

	let fooddata = {};
    let nutrients = []
    let kcal100g = 0
	try {
		const searchParams = new URLSearchParams({api_key: process.env.FOODDATA_API_KEY, query: ingredient, pageSize: 1, pageNumber: 1});
		let response = await fetch(
			`https://api.nal.usda.gov/fdc/v1/foods/search?${searchParams}`
		);
        fooddata = await response.json()
        nutrients = fooddata.foods[0].foodNutrients;
        kcal100g = nutrients.filter((nutrient) => nutrient.unitName === 'KCAL')[0].value;
	} catch (e) {
		return '-';
	}

    if (typeof(kcal100g) !== 'number') return '-'

	// All quantity must be converted to g because API gives kCal per 100g.
    // Assume all food have density of water. Convert all to g.
    // Ex: 1 tbsp of sugar is the g equivalent of 1 tbsp of water.
	let updatedQuantity = quantity;
	if (unit === 'L' || unit === 'kg') {
		updatedQuantity *= 1000;
	} else if (unit === 'tsp') {
		updatedQuantity *= 4.92892;
	} else if (unit === 'tbsp') {
		updatedQuantity *= 236.588;
	}

    // console.log('ingredient: ', ingredient, ', kcal100g: ', kcal100g, ', quantity: ', quantity)

	return Math.trunc(kcal100g * updatedQuantity / 100);
};

module.exports = getKcal;
