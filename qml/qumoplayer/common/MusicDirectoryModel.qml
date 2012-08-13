import QtQuick 1.1
import './js/subsonic.js' as Subsonic

AbstractMusicDirectoryModel {
    id: root
    query: "/subsonic-response/directory/child"

    property string _id

    function loadImpl(callback) {
        Subsonic.getMusicDirectory(root._id, callback)
    }
}
