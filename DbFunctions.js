.pragma library

function dropTablesTx(tx) {
    tx.executeSql('DROP TABLE IF EXISTS "words";');
    tx.executeSql('DROP TABLE IF EXISTS "window";');
}

function dropTables(db) {
    db.transaction(dropTablesTx);
}

/*!
 * \param record is an object { alien: "string", native: "string" }
 */
function addRecord(db, record) {
    db.transaction(function(tx) {
        if (typeof record.last_answer === 'undefined') {
            const date = new Date(Date.now())
            record.last_answer = date.toISOString().substr(0, 10)
        }
        tx.executeSql("INSERT INTO words(alien, native, last_answer) VALUES(?, ?, ?)",
                      [record.alien, record.native, record.last_answer]);
    });
}

function updateRecordTx(tx, record) {
    tx.executeSql("UPDATE words SET efactor = ?, 'interval' = ?, last_answer = ? WHERE id = ?",
                  [
                      record.efactor,
                      record.interval,
                      record.last_answer,
                      record.id
                  ])

}

function cleanWindowTx(tx) {
    tx.executeSql("DELETE FROM window;")
}

function cleanWindow(db) {
    db.transaction(createTablesTx)
}

function fillWindow(db, size) {
    db.transaction(function (tx) {

        cleanWindowTx(tx)

        var results = tx.executeSql("SELECT * FROM words WHERE strftime('%s', date('now')) >= strftime('%s', last_answer) LIMIT ?", [size])

        for (var i = 0; i < results.rows.length; ++i) {
            const result = results.rows.item(i)
            // TODO: some transformations
            tx.executeSql("INSERT into window(id, question, answer, efactor, 'interval', last_answer, id_original) VALUES(?, ?, ?, ?, ?, ?, ?)",
                          [
                              Math.floor(Math.random() * 1000000),
                              result.alien,
                              result.native,
                              result.efactor,
                              result.interval,
                              result.last_answer,
                              result.id
                          ])
        }
    })
}

function peekWindowItem(db) {
    var item

    db.transaction(function (tx) {
        const results = tx.executeSql("SELECT * FROM window ORDER BY id LIMIT 1")

        if (results.rows.length > 0) {
            item = results.rows.item(0)
        }
    })

    return item
}

function getWindowItemTx(tx, id_original) {
    const results = tx.executeSql("SELECT * FROM window WHERE id_original = ?", [id_original])

    if (results.rows.length > 0) {
        return results.rows.item(0)
    }
}

function removeWindowItemTx(tx, id_original) {
    const windowItem = getWindowItemTx(tx, id_original)
    if (windowItem) {
        updateRecordTx(tx,
                       {
                           "id"          : windowItem.id_original,
                           "efactor"     : windowItem.efactor,
                           "interval"    : windowItem.interval,
                           "last_answer" : windowItem.last_answer,
                       })
    }

    const res = tx.executeSql("DELETE FROM window WHERE id_original = ?", [id_original])
    console.debug("removeWindowItemTx(", id_original, ") = ", JSON.stringify(res))
}

function removeWindowItem(db, id) {
    db.transaction(function (tx) {
        removeWindowItemTx(tx, id)
    })
}

function updateWindowItem(db, item) {
    db.transaction(function (tx) {
        const date = new Date(Date.now())
        item.last_answer = date.toISOString().substr(0, 10)
        const updateRes = tx.executeSql("UPDATE window SET id = ?, efactor = ?, 'interval' = ?, last_answer = ? WHERE id_original = ?",
                                        [
                                            Math.floor(Math.random() * 1000000),
                                            item.efactor,
                                            item.interval,
                                            item.last_answer,
                                            item.id_original
                                        ])

    })
}

function readAll(db, append) {
    db.transaction(function (tx) {
        var results = tx.executeSql(
                    'SELECT id, alien, native FROM words order by id desc;')
        for (var i = 0; i < results.rows.length; ++i) {
            const result = results.rows.item(i)
            append({
                       "id"    : result.id,
                       "alien" : result.alien,
                       "answer": result.native
                   });
        }
    });
}

function removeRecord(db, ids) {
    db.transaction(function (tx) {
        console.debug("Delete words(ids): ", JSON.stringify(ids))

        if (typeof ids === 'number') {
            tx.executeSql("DELETE FROM words WHERE id = ?;", [ids])
        } else {
            ids.forEach(id => tx.executeSql("DELETE FROM words WHERE id = ?;", [id]))
        }
    })
}

function createTablesTx(tx) {
    tx.executeSql(`CREATE TABLE IF NOT EXISTS "words" (
    "id"               INTEGER PRIMARY KEY AUTOINCREMENT,
    "alien"            TEXT    NOT NULL UNIQUE,
    "native"           TEXT    NOT NULL,
    "efactor"          REAL    DEFAULT 2.5,
    "response_quality" INTEGER DEFAULT 0,
    "interval"         INTEGER DEFAULT 0,
    "last_answer"      TEXT    NOT NULL);`)

    tx.executeSql(`CREATE TABLE IF NOT EXISTS "window" (
    "id"               INTEGER DEFAULT 'random()',
    "question"         TEXT    NOT NULL UNIQUE,
    "answer"           TEXT    NOT NULL,
    "efactor"          REAL    NOT NULL,
    "interval"         INTEGER NOT NULL,
    "last_answer"      INTEGER NOT NULL,
    "id_original"      INTEGER NOT NULL UNIQUE,
    PRIMARY KEY("id"));`)
}

function createTables(db) {
    db.transaction(createTablesTx)
}
