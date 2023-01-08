module.exports = function randomColorsArray() {
    let randomColors = []
    for (let i=0; i<5; i++) {
        let randomColor = Math.floor(Math.random()*16777215).toString(16)
        randomColors.push('#'+ randomColor)
    }
    return randomColors
}

