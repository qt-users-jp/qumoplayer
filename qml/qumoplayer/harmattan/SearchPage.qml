import QtQuick 1.1
import com.nokia.meego 1.0
import "../common" as Common
import "../common/js/subsonic.js" as Subsonic
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

            onClicked: {
                if(model.type !== "song") {
                    searchView.currentIndex = -1;
                    pageStack.push(musicDirectoryPage, { _id: model.id, title: model.title } );
                    stackOnTop(pageStack);
                } else {
                    if(index !== searchView.currentIndex) {
                        searchView.currentIndex = index;
                    } else {
                        searchoperationitem.visible = !searchoperationitem.visible
                    }
                }
            }

            Item {
                id: searchoperationitem
                height: parent.height
                width: parent.width
                visible: false
                Rectangle {
                    id: searchoperationrect
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
                                currentPlaylistModel.append(searchModel.get(model.index))
                                searchoperationitem.visible = false;
                            }
                        }
                    }
                }
            }
            states: State {
                when: searchDelItem.ListView.isCurrentItem
                PropertyChanges {
                    target: searchoperationitem
                    visible: true
                }
            }

            Component.onCompleted: {
                if(model.type === "artist" ) {
                    searchDelItem.icon = handleIconSource("toolbar-contact");
                    searchDelItem.title = model.name;
                } else {
                    searchDelItem.icon = Subsonic.getCoverArtUrl(model.coverArt, searchDelItem.height);
                    searchDelItem.title = model.title;
                }
            }
        }
    }

    Component {
        id: searchSectionDelegate
        Rectangle {
            width: searchView.width
            height: 40
            gradient: Gradient {
                id: grad
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 1.0; color: "darkorange" }
            }
            Text {
                anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 15 }
                text: section
                font.pointSize: 20
                color: "white"
                font.capitalization: Font.Capitalize
            }
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
        section.property: "model.type"
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
