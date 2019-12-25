import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.14

Page {
    property StackView stackHolder

    ColumnLayout {
        anchors.fill: parent

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "✓"
            font.pixelSize: 50
            color: "green"
        }
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "The test is done"
        }
        Button {
            Layout.alignment: Qt.AlignHCenter
            text: "Close"
            onClicked: {
                stackHolder.pop()
            }
        }
    }
}
