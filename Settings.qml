pragma Singleton
import QtQuick 2.0
import Qt.labs.platform 1.0

QtObject {
    property bool debug: true
    property string appName: "dtest"
    property string dbfile: appName + ".db"
    property string dbversion: "1.0"
}
