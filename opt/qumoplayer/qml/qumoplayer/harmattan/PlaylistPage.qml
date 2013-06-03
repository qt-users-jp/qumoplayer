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
    model: playlistModel
    property alias _id: playlistModel._id

    Common.PlaylistModel {
        id: playlistModel
    }

    Component {
        id: playlistDelegate
        AbstractTwoLinesDelegate {
            id: playlistDelgateItem
            width: ListView.view.width
            rightMargin: operationArea.width

            icon: playlistModel.getCoverArt(model.coverArt, 300)

            title: model.title
            detail: model.artist

            OperationArea {
                id: operationArea
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right

                added: currentPlaylistModel.ids.indexOf(model.id) > -1
                onAdd: {
                    currentPlaylistModel.append(playlistModel.get(model.index))
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
        }
    }

    function addAll() {
        for(var i = 0; i < playlistModel.count; i++ ) {
            var item = playlistModel.get(i)
            currentPlaylistModel.append(item)
        }
    }

    AbstractListView {
        id: playlistView
        anchors.fill: parent
        anchors.topMargin: root.headerHeight
        anchors.bottomMargin: root.footerWithAdHeight
        model: playlistModel
        delegate: playlistDelegate
        clip: true
        loading: root.loading
        onCurrentIndexChanged: console.debug(playlistView.currentIndex);
        Component.onCompleted: currentIndex = -1
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
            enabled: playlistModel.count > 0
            opacity: enabled ? 1.0 : 0.5
            onClicked: {
                toolBarLayout.closing()
                currentPlaylistModel.clear()
                addAll()
                playerPage.playaudio(0, true, 0)
                pageStack.push(playerPage)
            }
        }

        ToolIcon {
            id: addToPlaylist
            iconId: "toolbar-add"
            enabled: playlistModel.count > 0
            opacity: enabled ? 1.0 : 0.5
            onClicked: {
                toolBarLayout.closing()
                addAll()
                pageStack.pop()
            }
        }
    }
}
