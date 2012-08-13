import QtQuick 1.1
import './js/subsonic.js' as Subsonic

AbstractMusicDirectoryModel {
    id: root
    query: "/subsonic-response/searchResult2/*"

    property string q

    function loadImpl(callback) {
        Subsonic.search2(root.q, callback)
    }
}
