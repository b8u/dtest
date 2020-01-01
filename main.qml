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

            Grid {
                id: gridId
                anchors.fill: parent
                columns: 2
                spacing: 8
                padding: 8

                readonly property int size: (width - padding * (columns + 1)) / columns

                MainPane  {
                    size:  gridId.size

                    text: "Word list"
                    onClicked: {
                        stackViewId.push("PageDbBrowser.qml", { "stackHolder": stackViewId })
                    }

                }


                MainPane {
                    size:  gridId.size
                    text: testWindow.empty() ? "Start test" : "Continue test"
                    onClicked: {
                        DbFunctions.fillWindow(State.db, 3)
                        stackViewId.push("PageTestWord.qml", { "stackHolder": stackViewId, "window": testWindow })
                    }
                }


                MainPane {
                    size:  gridId.size
                    text: "New words editor"
                    onClicked: {
                        stackViewId.push("PageAddWord.qml", { "stackHolder": stackViewId })
                    }
                }

                MainPane {
                    size:  gridId.size
                    text: "New word list"
                    onClicked: {
                        stackViewId.push("PageWordList.qml", { "stackHolder": stackViewId })
                    }
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
