pragma Singleton
import QtQuick 2.0
import Qt.labs.platform 1.0

QtObject {
    property bool debug: true
    property string appName: "dtest"
    property string dbfile: appName + ".db"
    property string dbversion: "1.0"


    /**
     *
     * German language settings
     *
     */

    readonly property int noun: 1
    readonly property int verb: 2
    readonly property int adj : 3
    readonly property int adv : 4

    function wordTypeToString(id) {
        switch(id) {
        case noun:
            return qsTr("noun")
        case verb:
            return qsTr("verb")
        case adj:
            return qsTr("adjective")
        case adv:
            return qsTr("adverb")
        default:
            throw "unknwon word type"
        }
    }

    readonly property int masculine: 1
    readonly property int feminine: 2
    readonly property int neutral: 3

    function genderToString(id) {
        switch(id) {
        case masculine: return "der"
        case feminine:  return "die"
        case neutral:   return "das"
        default:
            throw "unknown gender"
        }
    }

    readonly property var articles: // the order is important!
        [ genderToString(masculine)
        , genderToString(feminine)
        , genderToString(neutral)
        ]

    function getGender(str) {
        try
        {
            if (str[3] === ' ') {
                const givenGender = str.substr(0, 3).toLowerCase()
                const genderId = articles.findIndex(e => e === givenGender)
                if (genderId !== -1) {
                    return {"genderId": genderId + 1, "word": str.substr(4)}
                }
            }
        } catch (e) {
            console.error("getGender(): ", e)
        }
    }
}
