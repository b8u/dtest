import QtQuick 2.14

import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.14

Item {
    property var word:
        { "id"             : 1
        , "type_word"      : 1
        , "gender"         : 1
        , "singular"       : "Hund"
        , "plural"         : "Hunde"
        , "id_translation" : 1
        , "efactor"        : 2.5
        , "interval"       : 1
        , "last_answer"    : ""  // Хз что это
        , "translations"   : [ 'собака'
                             , 'пёс'
                             ]
        }


    Rectangle {
        id: helperId
        height: 24
        width: parent.width
        anchors.top: parent.top
    }

    Rectangle {
        id: helper2Id
        height: 28
        width: parent.width
        anchors.top: helperId.bottom
    }

    Rectangle {
        id: helper3Id
        height: 10
        //width: parent.width
        anchors.top: helper2Id.bottom
    }

    Label {
        id: overlineId
        font.pixelSize: 14
        color: "gray"
        anchors.baseline: helperId.bottom

        text: Settings.wordTypeToString(word.type_word)
        background: Rectangle {
            //border.color: "red"
        }
    }

    Label {
        anchors.baseline: helper2Id.bottom
        font.pixelSize: 24
        color: Material.primaryTextColor
        text: getNounHeader(word)
        background: Rectangle {
            //border.color: "red"
        }
    }

    Column {
        anchors.top: helper3Id.bottom
        width: parent.width
        Repeater {
            model: word.translations
            Label {
                font.pixelSize: 14
                color: Material.primaryTextColor
                text: '\u2022 ' + modelData
                background: Rectangle {
                    //border.color: "blue"
                }
            }
        }
    }

    function getNounHeader(noun) {
        console.assert(noun.type_word === Settings.noun)
        return Settings.genderToString(noun.gender) + ' ' + noun.singular + ' | ' + noun.plural
    }

}
