import QtQuick 2.0
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.14


Item {
    id: rootId
    width: 400
    height: 88

    property bool editMode: false

    property alias header:  titleId.text
    property alias secondary: secondaryTextId.text
    property alias mark: markId.text
    property alias checkState: checkboxId.checkState
    property real progress: -2.5


    readonly property bool debugBoxes: false
    readonly property real leftWidth: 40
    readonly property real rightWidth: 24

    Rectangle {
        border.color: "cyan"
        anchors.fill: parent
        border.width: debugBoxes ? 1 : 0

        Rectangle {
            anchors.topMargin: 16
            anchors.bottomMargin: 16
            border.color: "black"
            anchors.fill: parent
            border.width: debugBoxes ? 1 : 0

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    width: 40
                    Layout.fillHeight: true
                    Layout.leftMargin: 16

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
                            text: progress
                            font.weight: Font.Medium
                            font.pixelSize: 16
                            color: "gray"

                        }
                    }
                    border.color: "gray"
                    border.width: debugBoxes ? 1 : 0

                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
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
                                id: markId
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

                Rectangle {
                    width: 24
                    Layout.fillHeight: true
                    border.color: "gray"
                    Layout.rightMargin: 16
                    border.width: debugBoxes ? 1 : 0
                    visible: editMode


                    CheckBox {
                        id: checkboxId
                        checked: true
                        y: parent.y + 8
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
}
