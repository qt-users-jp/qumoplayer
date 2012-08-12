import QtQuick 1.1
import com.nokia.meego 1.0
import "../common" as Common
import "./Components/"

AbstractTabLoadablePage {
    id: root
    title: qsTr('Playlists')
    model: playlistsModel

    Common.PlaylistsModel {
        id: playlistsModel
    }

    Component {
        id: playlistsDelegate
        AbstractOneLineDelegate {
            width: ListView.view.width

            icon: persistentHandleIconSource("content-playlist-inverse")
            title: model.name

            onClicked: {
                pageStack.push(playlistPage, { plid: model.id, title: name } );
            }
        }
    }

    AbstractListView {
        id: playlistsView
        anchors.fill: parent
        anchors.bottomMargin: root.footerHeight

        model: playlistsModel
        delegate: playlistsDelegate
        clip: true
        loading: root.loading
    }
}
