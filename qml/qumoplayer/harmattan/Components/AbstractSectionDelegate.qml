import QtQuick 1.1

Rectangle {
    id: root
    width: 400
    height: 35
    color: 'darkorange'

    property alias title: title.text
    property alias capitalization: title.font.capitalization

    MouseArea {
        anchors.fill: parent
        onPressAndHold: {
            title.doScroll()
        }
    }

    AutoScrollText {
        id: title
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 10; right: parent.right }
        font.pointSize: 16
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
