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
import "./Components/"

AbstractPage {
    id: root
    title: qsTr('About QumoPlayer')

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: root.headerHeight
        anchors.bottomMargin: root.footerWithAdHeight
        clip: true

        contentWidth: container.width
        contentHeight: container.height

        Column {
            id: container
            width: flickable.width

            Item {
                width: 180
                height: width
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    anchors.centerIn: parent
                    height: 128
                    width: height
                    smooth: true
                    source: '../image/qumoplayer.png'
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr('<a style="%1;text-decoration:none;", href="http://dev.qtquick.me/projects/qumoplayer/">QumoPlayer for N9 v%2</a>').arg('color: darkorange').arg(currentVersion.version)
                color: 'white'
                font.family: "Nokia Pure Text"
                font.pointSize: 24
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Item {
                width: container.width
                height: 15
            }

            AbstractSectionDelegate {
                anchors { left: parent.left; right: parent.right }
                title: qsTr('Development Team')
            }

            AbstractTwoLinesDelegate {
                linkActivation: true
                width: parent.width
                title: qsTr('Takahiro Hashimoto (<a style="%1;text-decoration:none;" href="https://twitter.com/kenya888" >@kenya888</a>)').arg('color: darkorange')
                enabled: true
                icon: 'http://api.twitter.com/1/users/profile_image?screen_name=kenya888&size=bigger'
                detail: qsTr('Author, Developer')
            }

            AbstractTwoLinesDelegate {
                linkActivation: true
                width: parent.width
                title: qsTr('Tasuku Suzuki (<a style="%1;text-decoration:none;" href="https://twitter.com/task_jp" >@task_jp</a>)').arg('color: darkorange')
                enabled: true
                icon: 'http://api.twitter.com/1/users/profile_image?screen_name=task_jp&size=bigger'
                detail: qsTr('Developer, Technical Advisor')
            }

            AbstractSectionDelegate {
                anchors { left: parent.left; right: parent.right }
                title: qsTr('Design Team')
            }

            AbstractTwoLinesDelegate {
                linkActivation: true
                width: parent.width
                title: qsTr('hirao (<a style="%1;text-decoration:none;" href="https://twitter.com/hirao_00" >@hirao_00</a>)').arg('color: darkorange')
                enabled: true
                icon: 'http://api.twitter.com/1/users/profile_image?screen_name=hirao_00&size=bigger'
                detail: qsTr('Icon Designer')
            }

            AbstractSectionDelegate {
                anchors { left: parent.left; right: parent.right }
                title: qsTr('Thanks to')
            }

            AbstractTwoLinesDelegate {
                linkActivation: true
                width: parent.width
                title: qsTr('<a style="%1;text-decoration:none;" href="http://www.subsonic.org" >Subsonic</a>').arg('color: darkorange')
                enabled: true
                icon: '../image/subsonic.png'
                detail: qsTr('The nice media streamer')
            }
        }
    }

    toolBarLayout: AbstractToolBarLayout {
        id: toolBarLayout
        ToolBarSpacer { columns: 3 }
    }
}

