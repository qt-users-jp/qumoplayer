import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import "../common" as Common
import "../common/js/subsonic.js" as Subsonic
import "./Components/"

AbstractLoadablePage {
    id: root
    model: playlistModel
    property string plid: "aaa"

    function loadData(callback) {
        Subsonic.getOnePlayList(plid, callback)
    }

    Common.MusicDirectoryModel {
        id: playlistModel
        query: "/subsonic-response/playlist/entry"
    }

    Component {
        id: playlistDelegate
        AbstractTwoLinesDelegate {
            id: playlistDelgateItem
            width: ListView.view.width

            icon: Subsonic.getCoverArtUrl(model.coverArt, 300)

            title: model.title
            detail: model.artist

            //onClicked: { playsong.songid = musicid; songdialogtext.text = musictitle; songdialogimg.source = plsongalbumimg.source; songdialog.open(); }
            onClicked: {
                if(index !== playlistView.currentIndex) {
                    playlistView.currentIndex = index;
                } else {
                    playlistOperationItem.visible = !playlistOperationItem.visible
                }
            }
            onPressAndHold: { playlistView.currentIndex = index; onplmenu.open(); }

            Item {
                id: playlistOperationItem
                height: parent.height
                width: parent.width
                visible: false
                Rectangle {
                    anchors { right: parent.right}
                    height: parent.height; width: 150
                    color: "darkorange"
                    opacity: 0.6
                    radius: 10
                    Row {
                        anchors.fill: parent
                        ToolIcon {
                            iconId: "toolbar-add"
                            onClicked: {
                                currentPlaylistModel.append(playlistModel.get(model.index))
                                playlistDelgateItem.ListView.currentIndex = -1
                            }
                        }
                    }
                }
            }
            states: State {
                when: playlistDelgateItem.ListView.isCurrentItem
                PropertyChanges {
                    target: playlistOperationItem
                    visible: true
                }
            }
        }
    }

    AbstractListView {
        id: playlistView
        anchors.fill: parent
        anchors.topMargin: root.headerHeight
        anchors.bottomMargin: root.footerHeight
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
        }
        ToolIcon {
            id: playNow
            iconId: "toolbar-mediacontrol-play"
            enabled: playlistModel.count > 0
            opacity: enabled ? 1.0 : 0.5
            onClicked: {
                toolBarLayout.closing()
                currentPlaylistModel.clear()
                for(var i = 0; i < playlistModel.count; i++ ) {
                    currentPlaylistModel.append(playlistModel.get(i))
                }
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
                for(var i = 0; i < playlistModel.count; i++ ) {
                    currentPlaylistModel.append(playlistModel.get(i))
                }
                pageStack.pop()
            }
        }
    }
}
