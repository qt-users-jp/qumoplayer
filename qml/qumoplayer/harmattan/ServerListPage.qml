import QtQuick 1.1
import com.nokia.meego 1.0
import './Components'

AbstractPage {
    id: root
    title: qsTr('Select server')

    AbstractListView {
        id: view
        anchors.fill: parent
        anchors.topMargin: root.headerHeight
        anchors.bottomMargin: root.footerWithAdHeight

        model: serverListModel
        delegate: AbstractTwoLinesDelegate {
            width: ListView.view.width
            icon: "../image/" + model.type + ".png"
            title: model.name
            detail: model.url

            onClicked: {
                serverListModel.currentIndex = model.index
                pageStack.pop()
            }

            MouseArea {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                width: height

                onClicked: {
                    pageStack.push(serverSettingsPage, {server: serverListModel.get(model.index)})
                }

                Image {
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    source: handleIconSource('toolbar-edit')
                }
            }
        }

        clip: true
    }

    toolBarLayout: AbstractToolBarLayout {
        id: toolBarLayout
        ToolBarSpacer { columns: 2 }

        ToolIcon {
            id: add
            iconId: "toolbar-add"
            onClicked: {
                toolBarLayout.closing()
                pageStack.push(serverSettingsPage)
            }
        }
    }
}
