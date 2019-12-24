import QtQuick 2.4
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.14
import QtQuick.Dialogs 1.2

import "State.js" as State
import "DbFunctions.js" as DbFunctions

Page {
    property bool editMode: false
    property StackView stackHolder

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: qsTr("‹")
                onClicked: stackHolder.pop()
                font.pixelSize: 24
            }

            Rectangle {
                id: toolBarPlaceholder
                Layout.fillWidth: true
            }

            ToolButton {
                text: qsTr("Edit")
                visible: !editMode
                onClicked: { editMode = true; }
            }
            ToolButton {
                text: qsTr("Cancel")
                visible: editMode
                onClicked: { editMode = false; }
            }
            ToolButton {
                text: qsTr("Remove")
                visible: editMode
                onClicked: {
                    editMode = false
                    removeSelectedItems()
                }
            }
            ToolButton {
                text: qsTr("Add")
                visible: !editMode
                onClicked: { stackHolder.push("PageDbNew.qml", {"stackHolder": stackHolder })}
            }
            ToolButton {
                text: qsTr("↻")
                visible: !editMode
                onClicked: { updateList() }
            }
        }
    }

    ListView {
        id: tasksViewId
        width: parent.width
        height: parent.height / 2

        model: ListModel{
            id: tasksModelId
        }
        delegate: ItemDelegate {

            width: parent.width
            height: Material.delegateHeight

            contentItem: RowLayout {
                anchors.fill: parent

                CheckBox {
                    visible: editMode
                    checked: toDie
                    onCheckedChanged: {
                        toDie = checked
                    }
                }
                Label {
                    text: id
                }

                Column {
                    Layout.fillWidth: true

                    Label {
                        text: alien
                    }
                    Label {
                        text: answer
                    }
                }
            }
        }
    }

    function updateList() {
        try {
            tasksViewId.model.clear()
            if (State.db) {
                DbFunctions.readAll(State.db, function(obj) {
                    obj.toDie = false
                    tasksViewId.model.append(obj);
                });
            }
        } catch (e) {
            console.log("DB Error: ", e);
        }
    }

    function removeSelectedItems() {
        try {
            var ids = []
            for (var i = 0; i < tasksViewId.model.count; ++i) {
                const item = tasksViewId.model.get(i)
                if (item.toDie) {
                    ids.push(item.id)
                }
            }
            DbFunctions.removeRecord(State.db, ids)
        } catch (e) {
            console.error("DB Error: ", e)
        }
        updateList()
    }

    Component.onCompleted: {
        updateList()
    }

}
