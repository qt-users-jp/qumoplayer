import QtQuick 1.1

QtObject {
    id: root

    function database() {
        // QumoPlayer DB
        return openDatabaseSync('Qumoplayer', '1.0', 'Streaming Player', 10000)
    }

    function readData(key, defaultValue) {
        var ret = defaultValue;
        database().readTransaction(
            function(tx) {
                        try {
                            var rs = tx.executeSql('SELECT value FROM Settings WHERE key=?', [key]);

                            if (rs.rows.length > 0) {
                                ret = rs.rows.item(0).value;
                            }
                        } catch(e) {}
            }
        )
        return ret;
    }

    function saveData(key, value) {
        database().transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS Settings(key TEXT, value TEXT)');

                var currentValue;
                var rs = tx.executeSql('SELECT value FROM Settings WHERE key=?', [key]);

                if (rs.rows.length > 0) {
                    currentValue = rs.rows.item(0).value;
                }

                if (currentValue !== value) {
                    if (currentValue !== undefined) {
                        tx.executeSql('UPDATE Settings SET value = ? WHERE key = ?', [ value, key ]);
                    } else {
                        tx.executeSql('INSERT INTO Settings VALUES(?, ?)', [ key, value ]);
                    }
                }
            }
        )
    }
}

