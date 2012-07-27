import QtQuick 1.1

XmlListModel {
    query: "/subsonic-response/indexes/index/artist"
    namespaceDeclarations: "declare default element namespace 'http://subsonic.org/restapi';"

    XmlRole { name: "name"; query: "@name/string()" }
    XmlRole { name: "id"; query: "@id/string()" }
}
