import QtQuick 1.1
import com.nokia.meego 1.0

ToolBarLayout {
    id: root

    property bool topStack: false

    signal closing()

    ToolIcon {
        id: back
        iconId: "toolbar-back"
        onClicked: {
            root.closing()
            pageStack.pop()
        }
    }
    ToolIcon {
        id: home
        iconId: "toolbar-home"
        onClicked: {
            root.closing()
            pageStack.pop(mainPage)
        }
    }

    StateGroup {
        states: [
            State {
                name: "top"
                when: root.topStack
                PropertyChanges {
                    target: back
                    opacity: 0.5
                    enabled: false
                }
                PropertyChanges {
                    target: home
                    opacity: 0.5
                    enabled: false
                }
            }
        ]
    }
}
