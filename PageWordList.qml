import QtQuick 2.4
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.14
import QtQuick.Dialogs 1.2

import "State.js" as State
import "DbFunctions.js" as DbFunctions
import "."

Page {
    id: rootId
    property bool editMode: false

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: qsTr("‹")
                onClicked: stackViewId.pop()
                font.pixelSize: 24
            }

            Rectangle {
                id: toolBarPlaceholder
                Layout.fillWidth: true
            }

            ToolButton {
                text: qsTr("Edit")
                visible: !editMode
                onClicked: {
                    rootId.editMode = true
                }
            }
            ToolButton {
                text: qsTr("Cancel")
                visible: editMode
                onClicked: {
                    rootId.editMode = false
                }
            }
            ToolButton {
                text: qsTr("Remove")
                visible: editMode
                onClicked: {
                    rootId.editMode = false
                    removeSelectedItems()
                }
            }
            ToolButton {
                text: qsTr("Add")
                visible: !rootId.editMode
                onClicked: { stackViewId.push("PageAddWord.qml") }
            }
            ToolButton {
                text: qsTr("↻")
                font.pixelSize: 24
                visible: !rootId.editMode
                onClicked: { updateList() }
            }
        }
    }

    ListView {
        id: tasksViewId
        width: parent.width
        height: parent.height / 2

        delegate: ItemListWord {
            id: wordListItemId
            width: parent.width
            editMode: rootId.editMode
            header: modelData.singular + " | " + modelData.plural
            secondary: modelData.translations[0].translation
            mark: Settings.wordTypeToString(modelData.type_word)
            progress: modelData.efactor
        }
    }

    function updateList() {
        try {
            const words = new DbFunctions.Words(State.db)
            tasksViewId.model = words.getNouns()
        } catch (e) {
            console.log("DB Error: ", e);
        }
    }

    //function removeSelectedItems() {
    //    try {
    //        var ids = []
    //        for (var i = 0; i < tasksViewId.model.count; ++i) {
    //            const item = tasksViewId.model.get(i)
    //            if (item.toDie) {
    //                ids.push(item.id)
    //            }
    //        }
    //        DbFunctions.removeRecord(State.db, ids)
    //    } catch (e) {
    //        console.error("DB Error: ", e)
    //    }
    //    updateList()
    //}

    Component.onCompleted: {
        updateList()
    }
}
