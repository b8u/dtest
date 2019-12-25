import QtQuick 2.4
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.14

ItemDelegate {
    property bool editMode: false

    height: 64

    GridLayout {
        anchors.fill: parent
        anchors.margins: 8
        columns: 3
        rows: 2

        CheckBox {
            Layout.rowSpan: 2
            visible: editMode
            //background: Rectangle { border.color: "red"; border.width: 1 }
        }

        Label {
            Layout.rowSpan: 2
            visible: !editMode
            text: id
            anchors.margins: 8
            //background: Rectangle { border.color: "red"; border.width: 1 }
        }




        Label {
            Layout.fillWidth: true

            text: alien
            font.pixelSize: 16
            font.bold: true

            //background: Rectangle { border.color: "red"; border.width: 1 }

        }

        Label {
            text: last_update
            font.pixelSize: 12
            font.bold: true

            //background: Rectangle { border.color: "red"; border.width: 1 }
        }

        Label {
            text: answer
            font.pixelSize: 12

            //background: Rectangle { border.color: "red"; border.width: 1 }
        }

        Label {
            text: efactor

            font.pixelSize: 12

            //background: Rectangle { border.color: "red"; border.width: 1 }
        }

    }
}
