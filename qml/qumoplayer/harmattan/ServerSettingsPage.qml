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

// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "../common/js/subsonic.js" as Subsonic
import './Components/'

AbstractPage {
    id: root
    title: qsTr('Server Settings')

    property variant server: {}

    SelectionDialog {
        id: typeselectiondialog
        titleText: "Server Type"
        model: ListModel {
            id: typelistmodel
            ListElement { name: "subsonic"; img: "../image/subsonic.png" }
            //ListElement { name: "pogoplug"; img: "../image/pogoplug.png" }
        }
        delegate: Component {
            Item {
                width: parent.width; height: 60
                anchors { left: parent.left; horizontalCenter: parent.horizontalCenter; leftMargin: 10 }
                Item {
                    id: typeitem
                    width: 60; height: parent.height
                    anchors.left: parent.left
                    Image {
                        anchors.centerIn: parent
                        source: img
                        sourceSize.width: 40; sourceSize.height: 40
                    }
                }
                Label {
                    anchors { left: typeitem.right; leftMargin: 10}
                    width: parent.width - typeitem.width ; height: parent.height
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: name
                        color: "white"
                        font.pointSize: 20
                    }
                }
                MouseArea { anchors.fill: parent; onPressed: selectedIndex = index; onClicked: typeselectiondialog.accept(); }
            }
        }
        onAccepted: { console.debug(selectedIndex); type.text = typelistmodel.get(selectedIndex).name }
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: root.headerHeight
        anchors.bottomMargin: root.footerWithAdHeight
        clip: true

        contentWidth: width
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: 10
            Column {
                width: parent.width
                spacing: 5
                Text {
                    text: qsTr("Name")
                    font.pointSize: 20
                    color: "white"
                }
                TextField {
                    id: name
                    width: parent.width
                    text: root.server.name ? root.server.name : qsTr('Subsonic Demo')
                }
            }
            Column {
                width: parent.width
                spacing: 5
                Text {
                    text: qsTr("Server Type")
                    font.pointSize: 20
                    color: "white"
                }
                Button {
                    id: type
                    width: 240; height: 60
                    iconSource: "../image/" + type.text + ".png"
                    text: root.server.type ? root.server.type : 'subsonic'
                    onClicked: typeselectiondialog.open();
                }
            }
            Column {
                width: parent.width
                spacing: 5
                Text {
                    text: qsTr("Server URL")
                    font.pointSize: 20
                    color: "white"
                }
                TextField {
                    id: url
                    width: parent.width
                    text: root.server.url ? root.server.url : 'http://subsonic.org/demo/'
                }
            }
            Column {
                width: parent.width
                spacing: 5
                Text {
                    text: qsTr("Username")
                    font.pointSize: 20
                    color: "white"
                }
                TextField {
                    id: username
                    width: parent.width
                    text: root.server.username ? root.server.username : 'guest3'
                }
            }
            Column {
                width: parent.width
                spacing: 5
                Text {
                    text: "Password"
                    font.pointSize: 20
                    color: "white"
                }
                TextField {
                    id: password
                    width: parent.width
                    text: root.server.password ? root.server.password : 'guest'
                    echoMode: TextInput.Password
                }
            }
        }
    }

    states: State {
        name: "new"
        when: !root.server.id
        PropertyChanges { target: root; title: qsTr('New Server') }
        PropertyChanges { target: addButton; iconId: "toolbar-add" }
        PropertyChanges { target: deleteButton; iconId: "toolbar-delete-dimmed"; enabled: false }
    }

    QueryDialog  {
        id: deleteConfirmDialog
        icon: handleIconSource("toolbar-delete")
        message: qsTr('Delete "%1"?').arg(root.server.url)
        acceptButtonText: qsTr("Delete")
        rejectButtonText: qsTr("Cancel")
        onAccepted: {
            serverListModel.deleteServer(root.server)
            pageStack.pop()
        }
    }

    toolBarLayout: AbstractToolBarLayout {
        ToolBarSpacer {}
        ToolIcon { id: deleteButton; iconId: "toolbar-delete"; onClicked: deleteConfirmDialog.open() }
        ToolIcon {
            id: addButton
            width: 80
            iconId: "toolbar-done"
            onClicked: {
                var server = root.server
                server.name = name.text
                server.type = type.text
                server.url = url.text
                server.username = username.text
                server.password = password.text
                console.debug(server.name, name.text)
                if (root.server.id) {
                    serverListModel.updateServer(server)
                } else {
                    serverListModel.addServer(server)
                }

                pageStack.pop()
            }
        }
    }
}
