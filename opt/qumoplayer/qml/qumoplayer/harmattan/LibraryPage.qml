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
import "../common" as Common
import "./Components/"

AbstractTabLoadablePage {
    id: root
    title: qsTr('Music Library')
    model: libraryModel

    Common.LibraryModel {
        id: libraryModel
    }

    Component {
        id: libraryDelegate
        AbstractOneLineDelegate {
            width: ListView.view.width

            icon: handleIconSource("toolbar-directory")
            title: model.name

            onClicked: {
                pageStack.push(musicDirectoryPage, { _id: model.id, title: model.name} );
            }
        }
    }

    Component {
        id: librarySectionDelegate
        Rectangle {
            width: parent.width
            //width: parent.width/4
            height: 40
            //color: header.color
            gradient: Gradient {
                id: grad
                GradientStop { position: 0.1; color: "black" }
                GradientStop { position: 1.0; color: "darkorange" }
            }
            Text {
                anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 15 }
                text: section
                font.pointSize: 20
                color: "white"
                font.capitalization: Font.Capitalize
            }
        }
    }

    AbstractListView {
        id: libraryView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: searchButton.top
        model: libraryModel
        delegate: libraryDelegate
        clip: true
        loading: root.loading
    }

    TextField {
        id: searchField
        anchors { left: parent.left; right: searchButton.left; verticalCenter: searchButton.verticalCenter }
        readOnly: false
        placeholderText: qsTr('Search')
        platformSipAttributes: SipAttributes {
            actionKeyLabel: 'Search'
            actionKeyEnabled: searchField.text.length > 0
        }
        platformStyle: TextFieldStyle { paddingRight: clearButton.width }
        Image {
            id: clearButton
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: persistentHandleIconSource("input-clear")
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    inputContext.reset();
                    searchField.text = '';
                }
            }
        }
        Keys.onReturnPressed: searchButton.search()
    }

    ToolIcon {
        id: searchButton
        anchors { bottom: parent.bottom; right: parent.right; bottomMargin: root.footerWithAdHeight }
        enabled: searchField.text.length > 0
        platformIconId: "toolbar-search"
        onClicked: search()
        function search() {
            searchButton.forceActiveFocus()
            pageStack.push(searchPage, {'title': searchField.text})
        }
    }
}
