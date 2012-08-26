import QtQuick 1.1
import com.nokia.meego 1.0
import "../common" as Common
import './Components/'

AbstractLoadablePage {
    id: root
    model: searchModel

    property bool allIsDir: true

    onTitleChanged: {
        root.load()
    }

    Common.SearchModel {
        id: searchModel
        q: root.title
        onCountChanged: timer.start()
    }

    Timer {
        id: timer
        repeat: false
        interval: 10
        onTriggered: {
            for (var i = 0; i < searchModel.count; i++) {
                if (searchModel.get(i).isDir !== 'true') {
                    root.allIsDir = false
                    return
                }
            }
            root.allIsDir = true
        }
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
            capitalization: Font.Capitalize
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

    function addAll() {
        for(var i = 0; i < searchModel.count; i++ ) {
            var item = searchModel.get(i)
            if (item.type === 'song') {
                currentPlaylistModel.append(item)
            }
        }
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
                addAll()
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
                addAll()
                pageStack.pop()
            }
        }
    }
}
