import QtQuick 1.1
import com.nokia.meego 1.0

Rectangle {
    id: root
    width: 100
    height: 70

    property bool loadable: false
    property bool loading: false
    signal load()

    gradient: Gradient {
        id: grad
        GradientStop { position: 0.0; color: "darkorange" }
//        GradientStop { position: 0.33; color: "lightgray" }
//        GradientStop { position: 0.67; color: "lightgray" }
        GradientStop { position: 1.0; color: "darkorange" }
    }

    property alias title: title.text

    Text {
        id: title
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.right: load.left
        anchors.rightMargin: 15
        font.pointSize: 25
        font.family: "Nokia Pure Text"
        font.bold: true
        color: "white"
        elide: Text.ElideRight
    }

    ToolIcon {
        id: load
        anchors { right: parent.right; verticalCenter: parent.verticalCenter }
        iconId: "icon-m-toolbar-refresh-selected"
        onClicked: root.load()
        visible: opacity > 0
        opacity: 0
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: load
        platformStyle: BusyIndicatorStyle { size: "medium" }
        visible: opacity > 0
        opacity: 0
        running: visible
    }

    StateGroup {
        states: [
            State {
                name: "loading"
                when: root.loading
                PropertyChanges {
                    target: busyIndicator
                    opacity: 1
                }
            },
            State {
                name: "loadable"
                when: root.loadable
                PropertyChanges {
                    target: load
                    opacity: 1
                }
            }
        ]
    }
}
