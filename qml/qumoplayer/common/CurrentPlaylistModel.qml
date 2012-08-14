import QtQuick 1.1

ListModel {
    id: root

    property variant ids: []

    property Connections __connections: Connections {
        target: root
        onCountChanged: {
            var ids = new Array()
            for (var i = 0; i < root.count; i++) {
                ids.push(root.get(i).id)
            }
            root.ids = ids
        }
    }
}
