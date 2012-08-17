import QtQuick 1.1

Item {
    id: root
    width: text.implicitWidth
    height: text.implicitHeight
    clip: true

    property alias horizontalAlignment: text.horizontalAlignment
    property alias verticalAlignment: text.verticalAlignment
    property alias elide: text.elide
    property alias font: text.font
    property alias color: text.color
    property alias text: text.text

    signal linkActivated(string link)

    Timer {
        id: delayedTimer
        repeat: false
        interval: 2500
        onTriggered: animation.start()
    }

    Text {
        id: text
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        onTextChanged: {
            delayedTimer.stop()
            animation.stop()
            if (root.width < implicitWidth)
                delayedTimer.start()
        }
        onLinkActivated: root.linkActivated(link)
    }

    SequentialAnimation {
        id: animation
        NumberAnimation {
            target: text
            property: "x"
            from: 0
            to: root.width - text.implicitWidth
            duration: Math.max((text.implicitWidth - root.width) * 50, 0)
            loops: (text.implicitWidth > root.width ? 1 : 0)
        }
        PauseAnimation { duration: 2500 }
    }

    StateGroup {
        states: [
            State {
                when: animation.running || delayedTimer.running
                AnchorChanges {
                    target: text
                    anchors.left: undefined
                    anchors.right: undefined
                    anchors.top: undefined
                    anchors.bottom: undefined
                }
                PropertyChanges {
                    target: text
                    elide: Text.ElideNone
                    horizontalAlignment: Text.AlignLeft
                }
            }

        ]
    }
}
