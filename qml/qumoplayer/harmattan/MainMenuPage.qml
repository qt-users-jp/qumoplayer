import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "../common" as Common
import "./Components/"

AbstractTabPage {
    id: root
    title: qsTr('QumoPlayer')

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.bottomMargin: root.footerWithAdHeight
        clip: true

        contentWidth: container.width
        contentHeight: container.height

        Column {
            id: container
            width: flickable.width

            AbstractTwoLinesDelegate {
                id: currentServer
                width: parent.width

                title: qsTr("Select Server")

                states: [
                    State {
                        when: serverListModel.currentIndex > -1
                        PropertyChanges {
                            target: currentServer
                            icon: "../image/" + serverListModel.get(serverListModel.currentIndex).type + ".png"
                            title: serverListModel.get(serverListModel.currentIndex).name
                            detail: serverListModel.get(serverListModel.currentIndex).url
                        }
                    }
                ]
                onClicked: {
                    pageStack.push(serverListPage)
                }

                Common.Ping {
                    id: ping
                }

                Connections {
                    target: serverListModel
                    onCurrentIndexChanged: {
                        if (serverListModel.currentIndex > -1)
                            delayedPing.start()
                    }
                }

                Timer {
                    id: delayedPing
                    interval: 10
                    repeat: false
                    running: false
                    onTriggered: ping.ping()
                }

                MouseArea {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    width: height

                    onClicked: ping.ping()

                    Image {
                        anchors.centerIn: parent
                        visible: !ping.running
                        opacity: ping.pong ? 1.0 : 0.5
                        source: handleIconSource("toolbar-frequent-used")
                    }

                    BusyIndicator {
                        anchors.centerIn: parent
                        platformStyle: BusyIndicatorStyle { size: "small" }
                        visible: ping.running
                        running: ping.running
                    }
                }
            }

            AbstractOneLineDelegate {
                width: parent.width
                title: qsTr("Recently added")
                enabled: false
            }

            AbstractOneLineDelegate {
                width: parent.width
                title: qsTr("Random")
                enabled: false
            }

            AbstractOneLineDelegate {
                width: parent.width
                title: qsTr("Top rated")
                enabled: false
            }

            AbstractOneLineDelegate {
                width: parent.width
                title: qsTr("Recently played")
                enabled: false
            }

            AbstractOneLineDelegate {
                width: parent.width
                title: qsTr("Most played")
                enabled: false
            }

            AbstractOneLineDelegate {
                width: parent.width
                icon: handleIconSource("toolbar-settings")
                title: qsTr("Preferences")
                enabled: true
                onClicked: pageStack.push(preferencesPage)
            }
        }
    }
}
