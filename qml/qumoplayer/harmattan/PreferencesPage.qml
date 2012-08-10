import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "./Components/"

AbstractPage {
    id: root
    title: qsTr('Preferences')

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: root.headerHeight
        anchors.bottomMargin: root.footerHeight
        clip: true

        contentWidth: container.width
        contentHeight: container.height

        Column {
            id: container
            width: flickable.width

            AbstractOneLineDelegate {
                width: parent.width
                title: qsTr('About')
                icon: handleIconSource('toolbar-application')
                enabled: true
                onClicked: pageStack.push(aboutPage)
            }
        }
    }

    toolBarLayout: AbstractToolBarLayout {
        id: toolBarLayout
        ToolBarSpacer { columns: 3 }
    }
}

