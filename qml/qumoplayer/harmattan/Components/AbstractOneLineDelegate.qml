import QtQuick 1.1

AbstractDelegate {
    id: root

    property alias title: title.text

    Text {
        id: title
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: root.height; right: parent.right }
        font.pointSize: 25
        font.family: "Nokia Pure Text"
        color: "white"
        elide: Text.ElideRight
    }

    StateGroup {
        states: [
            State {
                when: !root.enabled
                PropertyChanges {
                    target: title
                    opacity: 0.5
                }
            }
        ]
    }
}
