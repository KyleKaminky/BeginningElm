var scoreMultiplier = 2;
var highestScores = [316, 320, 312, 370, 337, 318, 314];

function doubleScores(scores) {

    if (Array.isArray(scores) === false) {
        throw new Error("Input must be of type array");
    }

    var newScores = [];

    for (var i = 0; i < scores.length; i++) {
        if (typeof scores[i] !== "number") {
            throw new Error("Input array must contain numbers only");
        }
        else {
            newScores[i] = scores[i] * scoreMultiplier;
        }
        
    }

    return newScores;
}