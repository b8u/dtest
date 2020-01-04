import QtQuick 2.14

import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.14

import "SM2.js" as SM2
import "StringDistance.js" as StrDst

// 4   12    20    28    36    44    52
//   8    16    24    32    40    48    56

ColumnLayout {
    id: rootId

    signal complete(real efactor, int interval, bool repeat)

    readonly property alias singularAnswer: singularId.text
    readonly property alias pluralAnswer: pluralId.text

    property var noun: {
        "id"             : 1,
        "type_word"      : 1,
        "gender"         : 1,
        "singular"       : "Hund",
        "plural"         : "Hunde",
        "id_translation" : 1,
        "efactor"        : 2.5,
        "interval"       : 1,
        "last_answer"    : "",  // Хз что это
    }
    readonly property bool hasPlural: typeof noun.plural === 'string'

    readonly property bool debugBorders: true

    spacing: 16
    anchors.margins: 16
    state: "initial"

    Label {
        text: "State: " + rootId.state
    }

    Column {
        Layout.fillWidth: true
        TextField {
            id: singularId
            width: parent.width
            placeholderText: qsTr("Singular form")

        }
        Label {
            id: hintId
            height: 16
            anchors.leftMargin: 12
            //width: parent.width
            text: "с артиклем"
            font.pixelSize: 12
            color: Material.hintTextColor
            background: Rectangle {
                border.width: debugBorders ? 1 : 0
                border.color: "red"
            }
        }
    }


    TextField {
        id: pluralId
        Layout.fillWidth: true
        //visible: false
        placeholderText: qsTr("Plural form")
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Material.backgroundColor
    }

    Button {
        Layout.fillWidth: true
        text: qsTr("Check")
        onClicked: {
            if (rootId.state == "") {
                rootId.state = 'initial'
            } else if (rootId.state == 'initial' || rootId.state == 'hintHighlight') {

                const pair = Settings.getGender(singularId.text.trim());

                if (typeof pair === 'undefined') {
                    rootId.state = 'hintHighlight'
                } else {
                    if (pair.genderId === noun.gender) {

                        const usersWord = pair.word.toLowerCase()
                        const rightWord = noun.singular.toLowerCase()

                        if (usersWord === rightWord) {

                            // Единственное число прошо, все ок

                            rootId.state = 'singularPassed'

                            if (!hasPlural) {

                                // Если нет множественного числа, просто заканчиваем с этим словом

                                const res = SM2.calc(5, noun.iterval, noun.efactor);
                                complete(res.factor, res.schedule, res.isRepeatAgain)
                            }
                        } else {

                            // Само слово неправильно написано

                            rootId.state = 'singularError'

                            const distance = StrDst.distance(usersWord, rightWord)
                            const distancePercent = distance === 0 ? 1 : (1.0 - (distance / rightWord.length))
                            const quality = distance === 0 ? 5 : Math.round(distancePercent * 4)
                            const res = SM2.calc(quality, noun.iterval, noun.efactor);
                            console.debug(distance, distancePercent, quality, JSON.stringify(res))

                            complete(res.factor, res.schedule, res.isRepeatAgain)
                            console.debug("Singular error: ", pair.word.toLowerCase(), noun.singular.toLowerCase())
                        }
                    } else {
                        // Проблема в артикле
                        singularId.text = Settings.genderToString(noun.gender) + ' ' + noun.singular
                        rootId.state = 'singularError'
                        complete(2.5, 1, true)
                    }
                }
            } else if (rootId.state === 'singularPassed') {
                var usersWord = pluralId.text.trim()
                const pair = Settings.getGender(usersWord);
                if (typeof pair !== 'undefined') {
                    usersWord = pair.word
                }
                usersWord = usersWord.toLowerCase()
                const rightWord = noun.plural.toLowerCase()

                const distance = StrDst.distance(usersWord, rightWord)
                const distancePercent = distance === 0 ? 1 : (1.0 - (distance / rightWord.length))
                const quality = distance === 0 ? 5 : Math.round(distancePercent * 4)
                const res = SM2.calc(quality, noun.iterval, noun.efactor);
                console.debug(distance, distancePercent, quality, JSON.stringify(res))

                if (distance === 0) {
                    rootId.state = 'pluralPassed'
                } else {
                    rootId.state = 'pluralError'
                }

                complete(res.factor, res.schedule, res.isRepeatAgain)
                console.debug("Singular error: ", pair.word.toLowerCase(), noun.singular.toLowerCase())
            }
        }
    }

    states: [
        State {
            name: "initial"
            PropertyChanges {
                target: singularId
                enabled: true
            }
            PropertyChanges {
                target: pluralId
                visible: false
            }
        },
        State {
            name: "hintHighlight"
            PropertyChanges {
                target: singularId
                enabled: true
            }
            PropertyChanges {
                target: pluralId
                visible: false
            }
            PropertyChanges {
                target: hintId
                color: Material.accentColor
            }
        },

        State {
            name: "singularError"
            PropertyChanges {
                target: singularId
                enabled: false
                color: Material.accentColor

            }
            PropertyChanges {
                target: pluralId
                visible: false
            }
        },
        State {
            name: "singularPassed"
            PropertyChanges {
                target: singularId
                enabled: false
                color: Material.hintTextColor

            }
            PropertyChanges {
                target: pluralId
                visible: true
                enabled: true
            }
        },
        State {
            name: "pluralError"
            PropertyChanges {
                target: singularId
                enabled: false
                color: Material.hintTextColor

            }
            PropertyChanges {
                target: pluralId
                visible: true
                enabled: true
                color: Material.accentColor
            }
        },
        State {
            name: "pluralPassed"
            PropertyChanges {
                target: singularId
                enabled: false
                color: Material.hintTextColor

            }
            PropertyChanges {
                target: pluralId
                visible: true
                enabled: false
                color: Material.hintTextColor
            }
        }

    ]

}
