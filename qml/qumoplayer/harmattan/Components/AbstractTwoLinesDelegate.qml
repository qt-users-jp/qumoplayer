import QtQuick 1.1

AbstractDelegate {
    id: root

    property alias title: title.text
    property alias detail: detail.text

    Column {
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: root.height; right: parent.right }
        Text {
            id: title
            font.pointSize: detail.text.length === 0 ? 25 : 18
            font.family: "Nokia Pure Text"
            color: "white"
            elide: Text.ElideRight
        }

        Text {
            id: detail
            font.pointSize: 14
            font.family: "Nokia Pure Text"
            color: "lightgrey"
            elide: Text.ElideRight
        }
    }

    StateGroup {
        states: [
            State {
                when: !root.enabled
                PropertyChanges {
                    target: title
                    opacity: 0.5
                }
                PropertyChanges {
                    target: detail
                    opacity: 0.5
                }
            }
        ]
    }
}
