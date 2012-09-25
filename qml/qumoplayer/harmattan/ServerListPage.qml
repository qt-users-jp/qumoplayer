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
