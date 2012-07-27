import QtQuick 1.1
import com.nokia.meego 1.0

AbstractPage {
    id: root

    property XmlListModel model

    loadable: root.status === PageStatus.Active
    loading: root.__loading || root.model.status === XmlListModel.Loading
    property bool __loading: false

    function load() {
        root.__loading = true
        loadData(function(ret) { root.model.xml = ret; root.__loading = false })
    }
    function loadData(callback) {callback("")}

    onStatusChanged: {
        if ( status === PageStatus.Active && root.model.xml === "" ) {
            root.load()
        }
    }
}

