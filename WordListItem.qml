import QtQuick 2.4
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.14

ItemDelegate {
    property bool editMode: false

    RowLayout {


        anchors.rightMargin: 16

        CheckBox {
            visible: editMode
            checked: toDie
            onCheckedChanged: {
                toDie = checked
            }
        }

        Label {
            anchors.leftMargin: 16
            text: "id"
            Layout.alignment: Qt.AlignVCenter

            background: Rectangle{
                border.color: "purple"
                border.width: 1
                color: "transparent"
            }
        }

        Column {
            Layout.fillWidth: true
            anchors.leftMargin: 16

            Label {
                anchors.bottom: parent.bottom
                text: "alien"
                background: Rectangle {
                    border.color: "red"
                    border.width: 1
                    color: "transparent"
                }
            }

            Label {
                text: "answer"
                background: Rectangle {
                    border.color: "blue"
                    border.width: 1
                    color: "transparent"
                }
            }
        }
    }
}
