import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import "../common" as Common
import "../common/js/subsonic.js" as Subsonic
import "./Components/"

AbstractLoadablePage {
    id: root
    model: musicDirectoryModel

    property string _id: "aaa"

    function loadData(callback) {
        Subsonic.getMusicDirectory(_id, callback)
    }

    Common.MusicDirectoryModel {
        id: musicDirectoryModel
        query: "/subsonic-response/directory/child"
    }

    Component {
        id: musicDirectoryDelegate
        AbstractTwoLinesDelegate {
            id: musicDirectoryDelItem
            width: ListView.view.width

            icon: Subsonic.getCoverArtUrl(model.coverArt, 300)
            title: model.title
            detail: model.artist

            onClicked: {
                console.debug("Current Index is: ".concat(index));
                if(index !== musicDirectoryView.currentIndex) {
                    musicDirectoryView.currentIndex = index;
                    console.debug("Listview's currentindex is ".concat(musicDirectoryView.currentIndex));
                } else {
                    musicDirectoryOperationItem.visible = !musicDirectoryOperationItem.visible;
                    console.debug("Listview's currentindex is ".concat(musicDirectoryView.currentIndex));
                }
                if( model.isDir === "true" ){
                    //Subsonic.getMusicDirectory(musicid, function(ret) { musicdirmodel.xml = ret; })
                    pageStack.push(musicDirectoryPage, { _id: model.id, title: model.title });
                    musicDirectoryView.currentIndex = -1;
                } else {
                    //playsong2.songid = musicid; songdialogtext2.text = musictitle; songdialogimg2.source = musicdiralbumimg.source; songdialog2.open();
                }
            }
            onPressAndHold: {
                if( model.isDir === "false" ){ musicDirectoryView.currentIndex = index; musicdirmenu.open(); }
            }
            Item {
                id: musicDirectoryOperationItem
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
                                if ( model.isDir === "false") {
                                    currentPlaylistModel.append(musicDirectoryModel.get(model.index))
                                    musicDirectoryOperationItem.visible = false;
                                } /*else {
                                    var model = Qt.createComponent("../Common/MusicDirModel.qml" );
                                    Subsonic.getMusicDirectory(musicid, function(ret) { model.xml = ret });
                                    Qumo.addAllSongToPlaylist(model, currentplaylistmodel);
                                    musicdiroperationitem.visible = false;
                                }*/
                            }
                        }
                    }
                }
            }
            states: State {
                when: musicDirectoryDelItem.ListView.isCurrentItem
                PropertyChanges {
                    target: musicDirectoryOperationItem
                    visible: true
                }
            }
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
