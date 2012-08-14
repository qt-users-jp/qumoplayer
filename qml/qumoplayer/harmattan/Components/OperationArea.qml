import QtQuick 1.1
import com.nokia.meego 1.0

Row {
    id: root
    property bool added: false

    signal add
    signal remove

    ToolIcon {
        id: add
        anchors.verticalCenter: parent.verticalCenter
        iconId: "toolbar-add"
        onClicked: root.added ? root.remove() : root.add()

        states: [
            State {
                when: root.added
                PropertyChanges {
                    target: add
                    rotation: 45
                }
            }
        ]

        transitions: [
            Transition {
                NumberAnimation { properties: 'rotation' }
            }
        ]
    }
}
