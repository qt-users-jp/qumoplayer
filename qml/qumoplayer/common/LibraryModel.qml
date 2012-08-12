import QtQuick 1.1
import './js/subsonic.js' as Subsonic

AbstractSubsonicListModel {
    id: root
    query: "/subsonic-response/indexes/index/artist"

    XmlRole { name: "id"; query: "@id/string()" }
    XmlRole { name: "name"; query: "@name/string()" }

    function loadImpl(callback) {
        Subsonic.getIndexes(callback)
    }
}
