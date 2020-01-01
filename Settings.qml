pragma Singleton
import QtQuick 2.0
import Qt.labs.platform 1.0

QtObject {
    property bool debug: true
    property string appName: "dtest"
    property string dbfile: appName + ".db"
    property string dbversion: "1.0"

    property int noun: 1
    property int verb: 2
    property int adj : 3
    property int adv : 4

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
            return "??"
        }
    }
}
