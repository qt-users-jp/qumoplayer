import QtQuick 1.1

ListModel {
    id: root

    property variant ids: []

    property Connections __connections: Connections {
        target: root
        onCountChanged: {
            var ids = new Array()
            for (var i = 0; i < root.count; i++) {
                ids.push(root.get(i).id)
            }
            root.ids = ids
        }
    }

    function database() {
        // QumoPlayer DB
        return openDatabaseSync('Qumoplayer', '1.0', 'Streaming Player', 10000)
    }

    Component.onCompleted: {
        database().readTransaction (
                    function (tx) {
                        var rs = tx.executeSql('SELECT * FROM CurrentPlaylist')
                        for (var i = 0; i < rs.rows.length; i++) {
                            root.append(rs.rows.item(i))
                        }
                    }
                    )
    }

    Component.onDestruction: {
        database().transaction(
                    function (tx) {
                        tx.executeSql('CREATE TABLE IF NOT EXISTS CurrentPlaylist(id TEXT NOT NULL, parent TEXT NOT NULL, title TEXT NOT NULL, isDir TEXT, album TEXT NOT NULL, artist TEXT NOT NULL, track TEXT NOT NULL, year TEXT NOT NULL, genre TEXT NOT NULL, coverArt TEXT NOT NULL, size TEXT NOT NULL, contentType TEXT NOT NULL, suffix TEXT NOT NULL, path TEXT NOT NULL, duration TEXT NOT NULL, bitRate TEXT NOT NULL, streamId TEXT NOT NULL, publishDate TEXT NOT NULL)')
                        tx.executeSql('DELETE FROM CurrentPlaylist')
                        for (var i = 0; i < root.count; i++) {
                            var song = root.get(i)
                            tx.executeSql('INSERT INTO CurrentPlaylist(id, parent, title, isDir, album, artist, track, year, genre, coverArt, size, contentType, suffix, path, duration, bitRate, streamId, publishDate)' +
                                          'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
                                          , [song.id, song.parent, song.title, song.isDir, song.album, song.artist, song.track, song.year, song.genre, song.coverArt, song.size, song.contentType, song.suffix, song.path, song.duration, song.bitRate, song.streamId, song.publishDate])
                        }
                    }
                    )
    }
}
