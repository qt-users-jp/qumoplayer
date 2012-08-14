import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import "../common" as Common
import "./Components/"

AbstractLoadablePage {
    id: root
    model: musicDirectoryModel

    property alias _id: musicDirectoryModel._id

    Common.MusicDirectoryModel {
        id: musicDirectoryModel
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
        anchors.bottomMargin: root.footerHeight

        model: musicDirectoryModel
        delegate: musicDirectoryDelegate
        clip: true
        loading: root.loading
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
            enabled: musicDirectoryModel.count > 0
            opacity: enabled ? 1.0 : 0.5
            onClicked: {
                toolBarLayout.closing()
                currentPlaylistModel.clear()
                for(var i = 0; i < musicDirectoryModel.count; i++ ) {
                    currentPlaylistModel.append(musicDirectoryModel.get(i))
                }
                playerPage.playaudio(0, true, 0)
                pageStack.push(playerPage)
            }
        }

        ToolIcon {
            id: addToPlaylist
            iconId: "toolbar-add"
            enabled: musicDirectoryModel.count > 0
            opacity: enabled ? 1.0 : 0.5
            onClicked: {
                toolBarLayout.closing()
                for(var i = 0; i < musicDirectoryModel.count; i++ ) {
                    currentPlaylistModel.append(musicDirectoryModel.get(i))
                }
                pageStack.pop()
            }
        }
    }
}
