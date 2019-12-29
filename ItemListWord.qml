import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.14


Item {
    id: rootId
    width: 400
    height: 88

    readonly property bool debugBoxes: false

    property alias header:  titleId.text
    property alias secondary: secondaryTextId

    Rectangle {
        border.color: "cyan"
        anchors.fill: parent
        border.width: debugBoxes ? 1 : 0

        Rectangle {
            anchors.leftMargin: 16
            border.color: "black"
            anchors.fill: parent
            anchors.margins: 16
            border.width: debugBoxes ? 1 : 0

            Row {
                anchors.fill: parent

                Rectangle {
                    id: picId
                    border.color: Material.accentColor
                    border.width: 4
                    width: 40
                    height: 40
                    radius: width / 2

                    // 1.1 - 2.5

                    Label {
                        anchors.centerIn: parent
                        text: "2.5"
                        font.weight: Font.Medium
                        font.pixelSize: 16
                        color: "gray"

                    }
                }

                Rectangle {
                    x: picId.x + picId.width
                    width: parent.width - picId.width - checkboxId.width
                    border.color: "green"
                    border.width: debugBoxes ? 1 : 0
                    height: parent.height



                    Column {
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        anchors.fill: parent
                        Row {
                            width: parent.width
                            height: titleId.height
                            Label {
                                id: titleId
                                text: "die Folge | die Folgen"
                                font.weight: Font.Medium
                                font.pixelSize: 16

                                background: Rectangle {
                                    border.color: "red"
                                    border.width: debugBoxes ? 1 : 0
                                }
                            }
                            Label {
                                text: "substantiv"
                                height: parent.height
                                width: parent.width - titleId.width
                                font.weight: Font.DemiBold
                                font.pixelSize: 12
                                color: "gray"
                                anchors.baseline: titleId.baseline
                                horizontalAlignment: Text.AlignRight

                                background: Rectangle {
                                    border.color: "yellow"
                                    border.width: debugBoxes ? 1 : 0
                                }

                            }
                        }
                        Label {
                            id: secondaryTextId
                            text: "1. Последствие\n2. последовательность"
                            height: parent.height - titleId.height
                            width: parent.width
                            font.pixelSize: 14

                            background: Rectangle {
                                border.color: "blue"
                                border.width: debugBoxes ? 1 : 0
                            }
                            color: "gray"
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                        }
                    }
                }
                CheckBox {
                    id: checkboxId
                    checked: true
                    y: parent.y + 8
                    anchors.right: parent.right
                    height: 24
                    width: 24

                    background: Rectangle {
                        border.color: "red"
                        border.width: debugBoxes ? 1 : 0
                    }
                }

            }
        }
    }
}
