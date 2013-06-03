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

// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import './Components/'

AbstractPage {
    id: root
    title: tabGroup.currentTab.title

    loadable: tabGroup.currentTab.loadable
    loading: tabGroup.currentTab.loading
    function load() { tabGroup.currentTab.load() }

    TabGroup {
        id: tabGroup
        anchors.fill: parent
        anchors.topMargin: headerHeight
        currentTab: serverListModel.currentIndex < 0 ? mainMenuPage : playlistsPage

        LibraryPage { id: libraryPage; pageStack: root.pageStack }
        PlaylistsPage { id: playlistsPage; pageStack: root.pageStack }
        PodcastsPage { id: podcastsPage; pageStack: root.pageStack }
        MainMenuPage { id: mainMenuPage; pageStack: root.pageStack }
    }

    toolBarLayout: ToolBarLayout {
        ButtonRow {
            platformStyle: TabButtonStyle { }
            TabButton {
                iconSource: handleIconSource("toolbar-content-audio".concat(enabled ? '' : '-dimmed'))
                tab: libraryPage
                enabled: serverListModel.currentIndex > -1
            }
            TabButton {
                iconSource: handleIconSource("toolbar-list".concat(enabled ? '' : '-dimmed'))
                tab: playlistsPage
                enabled: serverListModel.currentIndex > -1
            }

            TabButton {
                id: nowPlaying
                anchors.verticalCenter: parent.verticalCenter
                iconSource: handleIconSource("toolbar-headphones")
                enabled: currentPlaylistModel.count > 0
                opacity: enabled ? 1.0 : 0.5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push(playerPage)
                    }
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

            TabButton {
                iconSource: handleIconSource("toolbar-share".concat(enabled ? '' : '-dimmed'))
                tab: podcastsPage
                enabled: serverListModel.currentIndex > -1
            }
            TabButton {
                iconSource: handleIconSource("toolbar-view-menu")
                tab: mainMenuPage
                checked: true
            }
        }
    }
}
