.pragma library

.import "DBFunctions.js" as DBFunctions
.import "State.js" as State


var window = new Window()


class Window {
    empty() {
        return  !!DBFunctions.peekWindowItem(State.db)
    }
}
