import QtQuick 1.1
import com.nokia.meego 1.0

AbstractPage {
    id: root

    property XmlListModel model

    loadable: root.status === PageStatus.Active
    loading: root.model.loading || delayedLoad.running

    function load() {delayedLoad.start()}

    Connections {
        target: serverListModel
        onCurrentIndexChanged: delayedLoad.start()
    }

    Timer {
        id: delayedLoad
        repeat: false
        interval: 10
        onTriggered: root.model.load()
    }

    onModelChanged: delayedLoad.start()
}

