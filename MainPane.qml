import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.12

Pane {
    id: rootId

    property alias text: labelId.text
    signal clicked
    signal released
    signal pressed
    property real size

    width:  size
    height: size

    Material.elevation: 2

    Label {
        id: labelId
        text: "New words editor"
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseAreaId
        anchors.fill: parent

        onPressed: {
            rootId.Material.elevation = 8
        }

        onClicked: rootId.clicked()

        onReleased: {
            rootId.released();
            rootId.Material.elevation = 2
        }

    }

}
