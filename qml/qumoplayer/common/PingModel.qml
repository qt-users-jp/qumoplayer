// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

XmlListModel {
    query: "/subsonic-response"
    namespaceDeclarations: "declare default element namespace 'http://subsonic.org/restapi';"

    XmlRole { name: "reply"; query: "@status/string()" }
}
