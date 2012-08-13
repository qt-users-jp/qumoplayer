import QtQuick 1.1
import './js/subsonic.js' as Subsonic

AbstractMusicDirectoryModel {
    id: root
    query: "/subsonic-response/playlist/entry"

    property string _id

    function loadImpl(callback) {
        Subsonic.getPlayList(root._id, callback)
    }
}
