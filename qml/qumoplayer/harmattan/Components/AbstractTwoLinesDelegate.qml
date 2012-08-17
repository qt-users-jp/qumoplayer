import QtQuick 1.1

AbstractDelegate {
    id: root

    property alias title: title.text
    property alias detail: detail.text
    property bool linkActivation: false

    Column {
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: root.height; right: parent.right; rightMargin: root.rightMargin }
        AutoScrollText {
            id: title
            width: parent.width
            font.pointSize: detail.text.length === 0 ? 25 : 18
            font.family: "Nokia Pure Text"
            color: "white"
            elide: Text.ElideRight
            onLinkActivated: {
                if(root.linkActivation) { Qt.openUrlExternally(link) }
            }
        }

        Text {
            id: detail
            width: parent.width
            font.pointSize: 14
            font.family: "Nokia Pure Text"
            color: "lightgrey"
            elide: Text.ElideRight
            onLinkActivated: {
                if(root.linkActivation) { Qt.openUrlExternally(link) }
            }
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
