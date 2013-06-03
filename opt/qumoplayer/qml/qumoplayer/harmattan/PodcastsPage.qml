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
    title: qsTr('Podcasts')
    model: podcastsModel

    Common.PodcastsModel {
        id: podcastsModel
    }

    Component {
        id: podcastsDelegate
        AbstractTwoLinesDelegate {
            width: ListView.view.width
            rightMargin: operationArea.width

            icon: podcastsModel.getCoverArt(model.coverArt, 300)
            title: model.title
            detail: model.artist

            OperationArea {
                id: operationArea
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right

                added: currentPlaylistModel.ids.indexOf(model.id) > -1
                onAdd: {
                    var podcast = podcastsModel.get(model.index)
                    currentPlaylistModel.append(podcastsModel.get(model.index))
                }
                onRemove: {
                    for (var i = 0; i < currentPlaylistModel.count; i++) {
                        if (currentPlaylistModel.get(i).id === model.id) {
                            currentPlaylistModel.remove(i)
                            break
                        }
                    }
                }
            }
        }
    }

    Component {
        id: podcastsSectionDelegate
        AbstractSectionDelegate {
            width: podcastsView.width
            title: section
            capitalization: Font.Capitalize
        }
    }

    AbstractListView {
        id: podcastsView
        anchors.fill: parent
        anchors.bottomMargin: root.footerWithAdHeight

        model: podcastsModel
        delegate: podcastsDelegate
        clip: true
        loading: root.loading

        section.property: "album"
        section.criteria: ViewSection.FullString
        section.delegate: podcastsSectionDelegate
    }
}
