import QtQuick 1.1
import com.nokia.meego 1.0

Rectangle {
    id: root
    width: 480
    height: 72
    color: 'darkorange'

    property bool loadable: false
    property bool loading: false
    signal load()

    property alias title: title.text

    AutoScrollText {
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
        platformStyle: BusyIndicatorStyle { id: busyIndicatorStyle }
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

    StateGroup {
        states: [
            State {
                name: 'landscape'
                when: !rootWindow.inPortrait
                PropertyChanges { target: root; height: 48 }
                PropertyChanges { target: title; font.pointSize: 16 }
                PropertyChanges { target: busyIndicatorStyle; size: 'small' }
                PropertyChanges { target: load; scale: 0.75; anchors.rightMargin: -15 }
            }
        ]
    }
}
