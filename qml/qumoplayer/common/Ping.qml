import QtQuick 1.1
import './js/subsonic.js' as Script

StateGroup {
    id: root
    property bool pong: false
    property bool running: false

    function ping() {
        if (root.running) return
        root.running = true
        model.xml = ''
        var url = Script.serverUrl().concat("ping.view").concat(Script.generateParameters())
        Script.createXMLHttpRequest('GET', url, function (ret) { model.xml = ret } );
    }


    property XmlListModel __model: XmlListModel {
        id: model
        query: "/subsonic-response"
        namespaceDeclarations: "declare default element namespace 'http://subsonic.org/restapi';"

        XmlRole { name: "reply"; query: "@status/string()" }

        onStatusChanged: {
            if (!root.running) return
            switch (status) {
            case XmlListModel.Ready: {
                root.pong = (model.get(0).reply === "ok")
                root.running = false
                break }
            case XmlListModel.Error: {
                root.pong = false
                root.running = false
                break }
            }
        }
    }
}
