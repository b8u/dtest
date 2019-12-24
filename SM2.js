/**
 * Author: Niven Su (sunivengg@gmail.com) https://github.com/sunaiwen/supermemo2.js
 * Edited: b8u (https://github.com/b8u)
 */

.pragma library



/**
 * @params {number} oldFac   the old factor of the previous day
 * @params {number} quality  the quality of review
 */

function calcFactor(oldFac, quality) {
    return oldFac + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
}

/**
 * @params  {number} quality       a number between 0~5 representing the quality of review. 0 is the worse while 5 is the best.
 * @params  {number} lastSchedule  the duration of last review space
 * @params  {number} lastFactor    the factor of last schedual
 */
function calc(quality, lastSchedule, lastFactor) {
    let newFac
    let curSchedule

    if(quality == null || quality < 0 || quality > 5) {
        quality = 0
    }

    if(lastSchedule === 1) {
        curSchedule = 6
        newFac = 2.5
    } else if(lastSchedule == null) {
        curSchedule = 1
        newFac = 2.5
    } else {
        if(quality < 3) {
            newFac = lastFactor
            curSchedule = lastSchedule
        } else {
            newFac = calcFactor(lastFactor, quality)

            if(newFac < 1.3) {
                newFac = 1.3
            }

            curSchedule = Math.round(lastSchedule * newFac)
        }
    }

    return {
        factor: newFac,
        schedule: curSchedule,
        isRepeatAgain: quality < 4
    }
}
