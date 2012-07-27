import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: root

    property alias title: header.title

    property int headerHeight: header.y + header.height
    property int footerHeight: footer.height * footerOpacity
    property alias toolBarLayout: footer.tools
    property alias footerOpacity: footer.opacity

    property alias loadable: header.loadable
    property alias loading: header.loading

    function load() {}

    Header {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        onLoad: root.load()
    }

    ToolBar {
        id: footer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        z: 100
        states: [
            State {
                name: 'hidden'
                when: opacity == 0
                PropertyChanges {
                    target: footer
                    visible: false
                    height: 0
                }
            }
        ]
        transitions: [
            Transition {
                NumberAnimation { properties: 'height' }
            }
        ]
    }
}
