/* Copyright (c) 2012 QumoPlayer Project.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the QumoPlayer nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL QUMOPLAYER BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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
