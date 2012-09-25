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
