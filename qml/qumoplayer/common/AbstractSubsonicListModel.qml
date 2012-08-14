import QtQuick 1.1
import './js/subsonic.js' as Subsonic

XmlListModel {
    id: root
    namespaceDeclarations: "declare default element namespace 'http://subsonic.org/restapi';"

    property bool loading: root.__loadingFromServer || root.status === XmlListModel.Loading
    property bool __loadingFromServer: false

    function load() {
        root.__loadingFromServer = true
        loadImpl(__loaded)
    }

    function __loaded(ret) {
        root.xml = ret
        root.__loadingFromServer = false
    }

    function loadImpl(callback) {callback('<error message="not implemented in subclass" />')}

    function getCoverArt(coverArt, size) {
        return Subsonic.getCoverArt(coverArt, size)
    }
}
