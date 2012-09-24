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
