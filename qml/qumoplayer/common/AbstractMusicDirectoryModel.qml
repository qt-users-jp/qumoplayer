import QtQuick 1.1

AbstractSubsonicListModel {
    id: root

    XmlRole { name: "id"; query: "@id/string()" }
    XmlRole { name: "parent"; query: "@parent/string()" }
    XmlRole { name: "title"; query: "@title/string()" }
    XmlRole { name: "isDir"; query: "@isDir/string()" }
    XmlRole { name: "album"; query: "@album/string()" }
    XmlRole { name: "artist"; query: "@artist/string()" }
    XmlRole { name: "track"; query: "@track/string()" }
    XmlRole { name: "year"; query: "@year/string()" }
    XmlRole { name: "genre"; query: "@genre/string()" }
    XmlRole { name: "coverArt"; query: "@coverArt/string()" }
    XmlRole { name: "size"; query: "@size/string()" }
    XmlRole { name: "contentType"; query: "@contentType/string()" }
    XmlRole { name: "suffix"; query: "@suffix/string()" }
    XmlRole { name: "path"; query: "@path/string()" }
    XmlRole { name: "duration"; query: "@duration/string()" }
    XmlRole { name: "bitRate"; query: "@bitRate/string()" }

    //for Search function
    XmlRole { name: "name"; query: "@name/string()" }
    XmlRole { name: "type"; query: "name()" }

    //for Podcasts
    XmlRole { name: "streamId"; query: "@streamId/string()" }
    XmlRole { name: "publishDate"; query: "@publishDate/string()" }
}
