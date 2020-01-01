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

    readonly property real animationDuration: 200
    readonly property int minElevation: 1
    readonly property int maxElevation: 8

    width:  size
    height: size

    Material.elevation: 1

    Label {
        id: labelId
        text: "New words editor"
        anchors.leftMargin: 16
        anchors.rightMargin: 24


        font.pixelSize: 24
        width: parent.width - (x - parent.x) - 24
        wrapMode: Text.WordWrap
        maximumLineCount: 2
        color: "#232F34"
    }

    NumberAnimation on Material.elevation {
        running: mouseAreaId.pressed
        from: minElevation
        to: maxElevation
        duration: animationDuration
    }

    MouseArea {
        id: mouseAreaId
        anchors.fill: parent

        onPressed: {
            rootId.Material.elevation = maxElevation
        }

        onClicked: rootId.clicked()

        onReleased: {
            rootId.released();
            rootId.Material.elevation = minElevation
        }

    }

}
