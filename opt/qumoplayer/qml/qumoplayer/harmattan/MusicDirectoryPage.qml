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
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import "../common" as Common
import "./Components/"

AbstractLoadablePage {
    id: root
    model: musicDirectoryModel

    property alias _id: musicDirectoryModel._id
    property bool allIsDir: true

    Common.MusicDirectoryModel {
        id: musicDirectoryModel
        onCountChanged: timer.start()
    }

    Timer {
        id: timer
        repeat: false
        interval: 10
        onTriggered: {
            for (var i = 0; i < musicDirectoryModel.count; i++) {
                if (musicDirectoryModel.get(i).isDir !== 'true') {
                    root.allIsDir = false
                    return
                }
            }
            root.allIsDir = true
        }
    }

    Component {
        id: musicDirectoryDelegate
        AbstractTwoLinesDelegate {
            id: musicDirectoryDelItem
            width: ListView.view.width

            icon: musicDirectoryModel.getCoverArt(model.coverArt, 300)
            title: model.title
            detail: model.artist

            onClicked: {
                if (model.isDir === "true") {
                    pageStack.push(musicDirectoryPage, { _id: model.id, title: model.title });
                }
            }

            OperationArea {
                id: operationArea
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                visible: false

                added: currentPlaylistModel.ids.indexOf(model.id) > -1
                onAdd: {
                    currentPlaylistModel.append(musicDirectoryModel.get(model.index))
                }
                onRemove: {
                    for (var i = 0; i < currentPlaylistModel.count; i++) {
                        if (currentPlaylistModel.get(i).id === model.id) {
                            currentPlaylistModel.remove(i)
                            break
                        }
                    }
                }
            }

            states: [
                State {
                    when: model.isDir !== 'true'
                    PropertyChanges {
                        target: operationArea
                        visible: true
                    }
                    PropertyChanges {
                        target: musicDirectoryDelItem
                        rightMargin: operationArea.width
                    }
                }
            ]
        }
    }

    AbstractListView {
        id: musicDirectoryView
        anchors.fill: parent
        anchors.topMargin: root.headerHeight
        anchors.bottomMargin: root.footerWithAdHeight

        model: musicDirectoryModel
        delegate: musicDirectoryDelegate
        clip: true
        loading: root.loading
    }

    function addAll() {
        for(var i = 0; i < musicDirectoryModel.count; i++ ) {
            var item = musicDirectoryModel.get(i)
            if (item.isDir !== 'true') {
                currentPlaylistModel.append(item)
            }
        }
    }

    toolBarLayout: AbstractToolBarLayout {
        id: toolBarLayout
        ToolIcon {
            id: nowPlaying
            iconId: "toolbar-headphones"
            enabled: currentPlaylistModel.count > 0
            opacity: enabled ? 1.0 : 0.5
            onClicked: {
                toolBarLayout.closing()
                pageStack.push(playerPage)
            }
            states: [
                State {
                    name: 'nowPlaying'
                    when: playerPage.playing
                    PropertyChanges {
                        target: nowPlaying
                        iconSource: playerPage.playingimg
                    }
                }
            ]
        }

        ToolIcon {
            id: playNow
            iconId: "toolbar-mediacontrol-play"
            enabled: !root.allIsDir
            opacity: enabled ? 1.0 : 0.5
            onClicked: {
                toolBarLayout.closing()
                currentPlaylistModel.clear()
                root.addAll()
                playerPage.playaudio(0, true, 0)
                pageStack.push(playerPage)
            }
        }

        ToolIcon {
            id: addToPlaylist
            iconId: "toolbar-add"
            enabled: !root.allIsDir
            opacity: enabled ? 1.0 : 0.5
            onClicked: {
                toolBarLayout.closing()
                root.addAll()
                pageStack.pop()
            }
        }
    }
}
