/* Copyright (c) 2012 QumoPlayer Project.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the QumoPlayer nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL QUMOPLAYER BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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
