import QtQuick 2.14

import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.14

import "State.js" as State
import "DbFunctions.js" as DbFunctions
import "SM2.js" as SM2
import "StringDistance.js" as StrDst

Page {
    property var record
    property var window

    //width: 400
    //height: 800

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: qsTr("‹")
                onClicked: stackViewId.pop()
                font.pixelSize: 24
            }
        }
    }

    Popup {
        id: popupId
        width: parent.width
        height: parent.height / 3
        x: parent.x
        y: parent.height - height
        modal: true
        focus: true

        ColumnLayout {
            anchors.fill: parent
            Label {
                id: popupLabelId
                wrapMode: Label.WordWrap
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            Button {
                text: "Next"
                Layout.fillWidth: true
                onClicked: {
                    popupId.close()


                    if (!window.empty()) {
                        stackViewId.replace("PageTestWord.qml", { "window": window })
                    } else {
                        stackViewId.replace("PageTestDone.qml")
                    }
                }
            }
        }
    }


    Column {
        anchors.margins: 16
        anchors.fill: parent
        Rectangle {
            border.color: "blue"
            border.width: 0
            width: parent.width
            height: parent.height / 3
            Label {
                text: "Question"
                anchors.centerIn: parent
                font.pixelSize: 28
            }

            color: Material.backgroundColor
        }

        TestNoun {
            width: parent.width
            height: 2 * parent.height / 3


            onComplete: {
                console.log("Complete: ", efactor, ", ", repeat, ", ", interval)
                popupId.open()
            }
        }
    }

    //ColumnLayout {
    //    anchors.fill: parent
    //
    //    Label {
    //        Layout.alignment: Qt.AlignHCenter
    //        text: record.question
    //    }
    //
    //    TextField {
    //        id: answerId
    //        text: record.answer
    //        Layout.alignment: Qt.AlignHCenter
    //        Layout.fillWidth: true
    //    }
    //
    //    // placeholder
    //    Rectangle {
    //        Layout.fillHeight: true
    //    }
    //
    //    Button {
    //        Layout.fillWidth: true
    //        text: qsTr("check")
    //        onClicked: {
    //            const distance = StrDst.distance(answerId.text, record.answer)
    //            const distancePercent = distance === 0 ? 1 : (1.0 - (distance / answerId.text.length))
    //            const quality = distance === 0 ? 5 : Math.round(distancePercent * 4)
    //            // quality, lastSchedule, lastFactor
    //            const res = SM2.calc(quality, record.iterval, record.efactor);
    //
    //
    //            popupLabelId.text = "Distance(" + answerId.text + ", " + record.answer + ") = " + distance + "\nQuality: " + quality + "\nRes: " + JSON.stringify(res)
    //
    //
    //            var newRecord = record
    //            newRecord.interval = res.schedule
    //            newRecord.efactor = res.factor
    //            // TODO: newRecord.last_answer
    //
    //            DbFunctions.updateWindowItem(State.db, newRecord)
    //
    //            if (!res.isRepeatAgain) {
    //                DbFunctions.removeWindowItem(State.db, record.id_original)
    //            }
    //
    //            popupId.open()
    //        }
    //    }
    //}

    Component.onCompleted: {
        //record = DbFunctions.peekWindowItem(State.db)
        //console.debug("Record: ", JSON.stringify(record))
    }
}
