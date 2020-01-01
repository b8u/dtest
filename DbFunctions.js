.pragma library

class Window {
    constructor(db) {
        this.db = db
    }

    size(tx) {
        var res

        const txFunction = function (tx) { res = tx.executeSql("SELECT COUNT(*) AS size FROM 'window'") }

        if (typeof tx === 'object') {
            txFunction(tx)
        } else {
            this.db.readTransaction(txFunction);
        }

        if (res.rows.length === 1) {
            const item = res.rows.item(0);
            return item.size
        }
    }

    empty(tx) {
        return this.size(tx) === 0
    }

    clear(tx) {
        if (typeof tx === 'object') {
            cleanWindowTx(tx)
        } else {
            cleanWindow(this.db)
        }
    }
}

class Words {
    constructor(db) {
        this.db = db
    }

    /**
     * @param   {object} { id: {number}, translation: {string} }
     * @returns {number} translations.id
     */
    translate(translation, tx) {
        var res = tx.executeSql(`SELECT id FROM translations WHERE translation = ?`, [translation])
        if (res.rows.length === 1) { // it's a unique field
            return res.rows.item(0).id
        } else {
            res = tx.executeSql(`INSERT INTO translations(translation) VALUES(?);`, [translation])
            return res.insertId;
        }
    }

    /**
     * @returns [{ translation {string}, id {number} }]  an array of translations
     */
    getTranslations(translationTableId, tx) {
        const res = tx.executeSql(`SELECT translations.translation as translation, translation_table.id_translation as id FROM translation_table LEFT JOIN translations ON translation_table.id_translation = translations.id WHERE translation_table.id = ?;`,
                                  [translationTableId])

        var translations = []
        for (var i = 0; i < res.rows.length; ++i) {
            translations.push(res.rows.item(i))
        }

        return translations
    }

    /**
     * @returns { id {number}, article {string}, name {string} }
     */
    getGender(article, tx) {
        const res = tx.executeSql(`SELECT * FROM "genders" WHERE "article" = ?`, [article])
        if (res.rows.length === 1) {
            return res.rows.item(0)
        }
    }

    getGenders(tx) {
        var genders = []

        const f = function(tx) {
            const res = tx.executeSql(`SELECT * FROM "genders";`)
            for (var i = 0; i < res.rows.length; ++i) {
                genders.push(res.rows.item(i))
            }
        }

        if (typeof tx === 'object') {
            f(tx);
        } else {
            this.db.transaction(f)
        }

        return genders
    }

    /**
     * @returns [{ id {number}, name {string} }]
     */
    getWordTypes(tx) {
        var types = []

        const f = function(tx) {
            const res = tx.executeSql(`SELECT * FROM "word_types"`)
            for (var i = 0; i < res.rows.length; ++i) {
                types.push(res.rows.item(i))
            }
        }

        if (typeof tx === 'object') {
            f(tx);
        } else {
            this.db.readTransaction(f)
        }

        return types
    }

    getNouns(tx) {
        var words = []
        const self = this;
        const f = function(tx) {
            const res = tx.executeSql(`SELECT w.id, w.type_word, s.gender, s.singular, s.plural, s.id_translation, sm2.efactor, sm2.interval, sm2.last_answer FROM words_new AS w INNER JOIN words_substantive AS s ON s.id = w.id_word LEFT JOIN sm2 ON sm2.word_id = w.id WHERE w.type_word = 1;`)
            for (var i = 0; i < res.rows.length; ++i) {
                var item = res.rows.item(i)
                item.translations = self.getTranslations(item.id_translation, tx)
                words.push(item)
            }
        }

        if (typeof tx === 'object') {
            f(tx);
        } else {
            this.db.readTransaction(f)
        }

        return words
    }
}


function createNoun(db, germanWord, pluralForm, gender, translations) {
    const wordsAPI = new Words(db)

    var translation_ids = []
    db.transaction(tx => {
                       translations.forEach(translation => {
                                                translation_ids.push(wordsAPI.translate(translation, tx))
                                            })
                   })
    db.transaction(tx => {
                       var max = tx.executeSql(`SELECT MAX(id) as max FROM translation_table;`).rows.item(0).max + 1

                       translation_ids.forEach(itraslationId => {
                                                   tx.executeSql(`INSERT INTO translation_table(id, id_translation) VALUES(?, ?)`, [max, itraslationId])
                                               })

                       if (germanWord.substr(0, 3).toLowerCase() === gender.article) {
                           germanWord = germanWord.substr(gender.article.length).trim()
                       }

                       const res = tx.executeSql(`INSERT INTO words_substantive(gender, singular, plural, id_translation) VALUES(?, ?, ?, ?);`,[
                                         gender.id, germanWord, pluralForm, max])

                       tx.executeSql(`INSERT INTO sm2(word_id) VALUES(?);`, [res.insertId])

                   })
}


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
