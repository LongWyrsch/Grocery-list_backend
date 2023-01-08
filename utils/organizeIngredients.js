const { all } = require("../routes/lists");

function organizeIngredients(cardType, distinctGroup, allIngredients) {
    let splitCriteria = cardType==='lists'? 'title' : 'recipe'
    let organizedArray = []
    distinctGroup.forEach(group => {
        allIngredients.
    });    

    allIngredients.forEach((ingredient) => { 
        ingredient[splitCriteria]
     })

     distinctGroup.map(object=>{
        object[splitCriteria]
     })






    return organizedArray
}






module.exports = organizeIngredients