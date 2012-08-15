import QtQuick 1.1
import com.nokia.meego 1.0
import "../common" as Common
import './Components/'

AbstractLoadablePage {
    id: root
    model: searchModel

    Common.SearchModel {
        id: searchModel
        q: root.title
    }

    onTitleChanged: {
        root.load()
    }

    Component {
        id: searchDelegate
        AbstractTwoLinesDelegate {
            id: searchDelItem
            width: ListView.view.width

            title: model.type

            onClicked: {
                if (model.type !== "song") {
                    pageStack.push(musicDirectoryPage, { _id: model.id, title: model.title } );
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
                    currentPlaylistModel.append(searchModel.get(model.index))
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
                    when: model.type === 'song'
                    PropertyChanges {
                        target: operationArea
                        visible: true
                    }
                    PropertyChanges {
                        target: searchDelItem
                        rightMargin: operationArea.width
                        icon: searchModel.getCoverArt(model.coverArt, searchDelItem.height);
                        title: model.title
                        detail: model.artist
                    }
                },
                State {
                    when: model.type === 'album'
                    PropertyChanges {
                        target: searchDelItem
                        icon: searchModel.getCoverArt(model.coverArt, searchDelItem.height);
                        title: model.title
                        detail: model.artist
                    }
                },
                State {
                    when: model.type === 'artist'
                    PropertyChanges {
                        target: searchDelItem
                        icon: handleIconSource("toolbar-contact")
                        title: model.name
                        detail: ' '
                    }
                }
            ]
        }
    }

    Component {
        id: searchSectionDelegate
        AbstractSectionDelegate {
            width: searchView.width
            title: section
        }
    }

    AbstractListView {
        id: searchView
        anchors.fill: parent
        anchors.topMargin: root.headerHeight
        anchors.bottomMargin: root.footerHeight

        model: searchModel
        delegate: searchDelegate
        clip: true
        loading: root.loading
        section.property: "type"
        section.criteria: ViewSection.FullString
        section.delegate: searchSectionDelegate
        Component.onCompleted: currentIndex = -1;
    }

    toolBarLayout: AbstractToolBarLayout { id: toolBarLayout
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
            enabled: searchModel.count > 0
            opacity: enabled ? 1.0 : 0.5
            onClicked: {
                toolBarLayout.closing()
                currentPlaylistModel.clear()
                for(var i = 0; i < searchModel.count; i++ ) {
                    currentPlaylistModel.append(searchModel.get(i))
                }
                playerPage.playaudio(0, true, 0)
                pageStack.push(playerPage)
            }
        }

        ToolIcon {
            id: addToPlaylist
            iconId: "toolbar-add"
            enabled: searchModel.count > 0
            opacity: enabled ? 1.0 : 0.5
            onClicked: {
                toolBarLayout.closing()
                for(var i = 0; i < searchModel.count; i++ ) {
                    currentPlaylistModel.append(searchModel.get(i))
                }
                pageStack.pop()
            }
        }
    }
}
