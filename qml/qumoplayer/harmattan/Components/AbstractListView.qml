import QtQuick 1.1

ListView {
    id: root
    property bool loading: false

    StateGroup {
        states: [
            State {
                name: "loading"
                when: root.loading
                PropertyChanges {
                    target: root
                    enabled: false
                    opacity: 0.25
                }
            }
        ]

        transitions: [
            Transition {
                NumberAnimation { property: 'opacity'; alwaysRunToEnd: true }
            }
        ]
    }

}
