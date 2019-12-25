import QtQuick 2.4
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.14
import QtQuick.Dialogs 1.2

import "State.js" as State
import "DbFunctions.js" as DbFunctions

Page {
    property StackView stackHolder
    property var words: new DbFunctions.Words(State.db)

    readonly property int noun: 0
    readonly property int verb: 1
    readonly property int adj : 2
    readonly property int adv : 3

    property int mode: noun


    id: pageId

    header: ToolBar {
        RowLayout {
            anchors.fill: parent

            ToolButton {
                text: qsTr("‹")
                onClicked: stackHolder.pop()
                font.pixelSize: 24
            }

            Rectangle {
                Layout.fillWidth: true
            }

            ToolButton {
                text: "\u2713"
                font.pixelSize: 18

                onClicked: {

                    var translations = []

                    for (var i = 0; i < translationsModelId.count; ++i) {

                        const tr = translationsModelId.get(i).translation
                        translations.push(tr)
                    }

                    const singular = germanWordId.text.trim()
                    const plural = hasPluralId.checked ? pluralWordId.text.trim() : null
                    const gender = wordGenderModelId.get(wordGenderId.currentIndex)

                    DbFunctions.createNoun(State.db, singular, plural, gender, translations)
                    stackHolder.pop()
                }
            }
        }
    }

    Popup {
        id: popupId
        width: parent.width
        height: parent.height / 3
        x: parent.x
        y: parent.height - height
        modal: true
        focus: true

        ColumnLayout {
            anchors.fill: parent

            Label {
                font.bold: true
                text: "Введите новый перевод"
            }

            TextField {
                id: newTranslationId
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            Button {
                Layout.fillWidth: true
                text: qsTr("Добавить")
                onClicked: {
                    translationsModelId.append({"translation": newTranslationId.text.trim()})
                    popupId.close();
                }
            }
        }
    }

    Rectangle {
        border.width: 0
        border.color: "green"
        anchors.fill: parent
        anchors.margins: 16
        GridLayout {
            anchors.fill: parent
            columns: 2

            Label {
                text: "Часть речи"
            }
            ComboBox {
                Layout.minimumWidth: parent.width * 0.5
                Layout.alignment: Qt.AlignRight

                id: wordTypeId
                textRole: "name"
                currentIndex: 0

                onCurrentTextChanged: {
                    if (currentText == "Substantive") {
                        mode = noun
                    } else if (currentText == "Verb") {
                        mode = verb
                    } else if (currentText == "Adjektiv") {
                        mode = adj
                    } else if (currentText == "Adverb") {
                        mode = adv
                    }
                }
            }


            Label {
                visible: mode == noun

                text: "Род"
            }
            ComboBox {
                visible: mode == noun

                Layout.minimumWidth: parent.width * 0.5
                Layout.alignment: Qt.AlignRight

                id: wordGenderId
                model: ListModel {
                    id: wordGenderModelId
                }

                textRole: "name"
                currentIndex: 0
            }

            TextField {
                Layout.columnSpan: 2
                Layout.fillWidth: true

                id: germanWordId
                placeholderText: "German word here"

                onTextChanged: {
                    const article = germanWordId.text.substring(0, 3)
                    console.debug("Article: ", article)
                }
            }

            RowLayout {
                Layout.columnSpan: 2
                Layout.fillWidth: true

                TextField {
                    id: pluralWordId
                    placeholderText: "Форма множественного числа"
                    readOnly: !hasPluralId.checked
                    Layout.fillWidth: true
                }

                CheckBox {
                    id: hasPluralId
                    checked: true

                    onCheckStateChanged: {
                        pluralWordId.readOnly = !checked
                    }
                }
            }

            ListView {
                id: translationsId
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.columnSpan: 2

                model: ListModel {
                    id: translationsModelId
                    Component.onCompleted: {
                        append({ "translation": "Перевод1" })
                        append({ "translation": "Перевод2" })
                    }
                }

                delegate: ItemDelegate {
                    height: 48
                    width: parent.width

                    Label {
                        anchors.topMargin: 16
                        anchors.fill: parent
                        text: translation
                    }
                }

            }

            Button {
                Layout.columnSpan: 2
                Layout.alignment: Qt.AlignRight

                text: "Добавить перевод"

                onClicked: {
                    popupId.open()
                }
            }
        }
    }

    Component.onCompleted: {
        wordTypeId.model = words.getWordTypes()
        words.getGenders().forEach(x => wordGenderModelId.append(x))
    }
}
