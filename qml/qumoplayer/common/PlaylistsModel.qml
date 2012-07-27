import QtQuick 1.1

XmlListModel {
    query: "/subsonic-response/playlists/playlist"
    namespaceDeclarations: "declare default element namespace 'http://subsonic.org/restapi';"

    XmlRole { name: "id"; query: "@id/string()" }
    XmlRole { name: "name"; query: "@name/string()" }
}
