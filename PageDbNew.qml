import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.14

import "State.js" as State
import "DbFunctions.js" as DbFunctions

Page {
    property StackView stackHolder

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: qsTr("‹")
                onClicked: stackHolder.pop()
                font.pixelSize: 24
            }
        }
    }

    Component.onCompleted: {
        if (!State.db) {
            // TODO: create default error page
            stackHolder.pop()
        }
    }


    Popup {
        id: popupId
        x: parent.x
        y: parent.y + 2 * parent.height / 3
        width: parent.width
        height: parent.height / 3
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        ColumnLayout {
            anchors.fill: parent

            Label {
                id: popupInfoId
                Layout.fillWidth: true
                wrapMode: Label.WordWrap
                text: "PLACE HOLDER"
            }

            Button {
                Layout.fillWidth: true
                text: qsTr("Close")
                onClicked: {
                    popupId.close();
                }
            }
        }
    }

    GridLayout {
        width: parent.width
        anchors.margins: 8
        columns: 2

        Label {
            text: qsTr("Alien word")
        }

        TextField {
            id: alienWordId
            Layout.fillWidth: true
        }

        Label {
            text: qsTr("Translation")
        }

        TextField {
            id: translationId
            Layout.fillWidth: true
        }

        Button {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: qsTr("Create")
            onClicked: {
                if (alienWordId.text.length === 0) {

                }
                if (translationId.text.length === 0) {

                }

                try {
                    var record = {"alien": alienWordId.text, "native": translationId.text};
                    DbFunctions.addRecord(State.db, record)
                    popupInfoId.text = "Record inserted: \n" + JSON.stringify(record)
                } catch (e) {
                    console.error("DB Error: ", e)
                    State.lastError = e
                    popupInfoId.text = "DB Error: " + e

                }
                popupId.open()
            }
        }

    }
}

