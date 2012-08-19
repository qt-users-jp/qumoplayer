import QtQuick 1.1
import './js/subsonic.js' as Subsonic

AbstractMusicDirectoryModel {
    id: root
    query: "/subsonic-response/podcasts/channel/episode[@status = 'completed']"

    function loadImpl(callback) {
        Subsonic.getPodcasts(callback)
    }
}
