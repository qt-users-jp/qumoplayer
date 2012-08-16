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
