import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "../common/js/subsonic.js" as SubSonic
import "../common" as Common
import "./Components/"

AbstractTabPage {
    id: root
    title: qsTr('Qumo Player')

    Flickable {
        id: flickable
        anchors.fill: parent
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

                Common.PingModel {
                    id: pingModel
                    onStatusChanged: {
                        if (!pingArea.running) return
                        switch (status) {
                        case XmlListModel.Ready: {
                            pingArea.serverAvailable = (pingModel.get(0).reply === "ok")
                            pingArea.running = false
                            break }
                        case XmlListModel.Error: {
                            pingArea.serverAvailable = false
                            pingArea.running = false
                            break }
                        }
                    }
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
                    onTriggered: pingArea.ping()
                }

                MouseArea {
                    id: pingArea
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    width: height

                    property bool running: false
                    property bool serverAvailable: false

                    onClicked: ping()

                    function ping() {
                        if (pingArea.running) return
                        pingArea.running = true
                        pingModel.xml = ''
                        SubSonic.ping(function(ret) { pingModel.xml = ret })
                    }

                    Image {
                        anchors.centerIn: parent
                        visible: !pingArea.running
                        opacity: pingArea.serverAvailable ? 1.0 : 0.5
                        source: handleIconSource("toolbar-frequent-used")
                    }

                    BusyIndicator {
                        anchors.centerIn: parent
                        platformStyle: BusyIndicatorStyle { size: "small" }
                        visible: running
                        running: pingArea.running
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
                title: qsTr("Preferences")
                enabled: false
            }
        }
    }
}
