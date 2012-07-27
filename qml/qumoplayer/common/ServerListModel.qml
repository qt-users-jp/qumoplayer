import QtQuick 1.1

ListModel {
    id: root

    property int currentIndex: -1

    function database() {
        // QumoPlayer DB
        return openDatabaseSync('Qumoplayer', '1.0', 'Streaming Player', 10000)
    }

    function addServer(server) {
        database().transaction(
                    function (tx) {
                        tx.executeSql('CREATE TABLE IF NOT EXISTS Server(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, type TEXT, url TEXT NOT NULL, username TEXT NOT NULL, password TEXT NOT NULL)')
                        var ret = tx.executeSql('INSERT INTO Server(name, type, url, username, password) VALUES (?, ?, ?, ?, ?)', [server.name, server.type, server.url, server.username, server.password])
                        server.id = ret.insertId
                        root.append(server)
                    }
                    )
    }

    function deleteServer(server) {
        database().transaction (
                    function (tx) {
                        tx.executeSql('DELETE FROM Server WHERE id = ?', [server.id])
                        for (var i = 0; i < root.count; i++) {
                            if (root.get(i).id === server.id) {
                                root.remove(i)
                                if (root.currentIndex == i) {
                                    root.currentIndex = -1
                                }
                                break
                            }
                        }
                    }
                    )

    }

    function updateServer(server) {
        database().transaction (
                    function (tx) {
                        tx.executeSql('UPDATE Server SET name = ?, type = ?, url = ?, username = ?, password = ? WHERE id = ?', [server.name, server.type, server.url, server.username, server.password, server.id])
                        for (var i = 0; i < root.count; i++) {
                            if (root.get(i).id === server.id) {
                                root.set(i, server)
                                break
                            }
                        }
                    }
                    )
    }

    Component.onCompleted: {
        database().readTransaction (
                    function (tx) {
                        var rs = tx.executeSql('SELECT * FROM Server')
                        for (var i = 0; i < rs.rows.length; i++) {
                            root.append(rs.rows.item(i))
                        }
                    }
                    )
    }
}
