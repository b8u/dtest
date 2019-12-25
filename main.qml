import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.LocalStorage 2.14
import Qt.labs.qmlmodels 1.0
import Qt.labs.platform 1.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.14

import "."

import "State.js" as State
import "DbFunctions.js" as DbFunctions

ApplicationWindow {
    visible: true
    width: 400
    height: 600
    title: qsTr("Hello World")

    property var testWindow


    StackView {
        id: stackViewId
        anchors.fill: parent

        initialItem: Page {
            id: pageStateId

            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    layoutDirection: Qt.RightToLeft
                    ToolButton {
                        text: qsTr("Settings")
                    }
                }
            }

            ColumnLayout {
                anchors.fill: parent

                Button {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Word list"
                    onClicked: {
                        stackViewId.push("PageDbBrowser.qml", { "stackHolder": stackViewId })
                    }
                }
                Button {
                    Layout.alignment: Qt.AlignHCenter
                    text: testWindow.empty() ? "Start test" : "Continue test"
                    onClicked: {
                        DbFunctions.fillWindow(State.db, 3)
                        stackViewId.push("PageTestWord.qml", { "stackHolder": stackViewId, "window": testWindow })
                    }
                }
                Button {
                    Layout.alignment: Qt.AlignHCenter
                    text: "New words editor"
                    onClicked: {
                        stackViewId.push("PageAddWord.qml", { "stackHolder": stackViewId})
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }
    }

    Component.onCompleted: {
        try {
            State.db = LocalStorage.openDatabaseSync(Settings.dbfile, "", "german tasks", 10000000);

            testWindow = new DbFunctions.Window(State.db)

            if (!State.db) { throw "Can't open db"; }

            DbFunctions.createTables(State.db);

            if (State.db.version !== Settings.dbversion) {
                State.db.changeVersion(State.db.version, Settings.dbversion, function(tx) {
                    DbFunctions.dropTablesTx(tx);
                    DbFunctions.createTablesTx(tx);
                });
            }
        } catch(e) {
            State.lastError = e;
            console.log("DB Error: ", e);
        }
    }
}
