// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import './Components/'

AbstractPage {
    id: root
    title: tabGroup.currentTab.title

    loadable: tabGroup.currentTab.loadable
    loading: tabGroup.currentTab.loading
    function load() { tabGroup.currentTab.load() }

    TabGroup {
        id: tabGroup
        anchors.fill: parent
        anchors.topMargin: headerHeight
        currentTab: serverListModel.currentIndex < 0 ? mainMenuPage : playlistsPage

        LibraryPage { id: libraryPage; pageStack: root.pageStack }
        PlaylistsPage { id: playlistsPage; pageStack: root.pageStack }
        PodcastsPage { id: podcastsPage; pageStack: root.pageStack }
        MainMenuPage { id: mainMenuPage; pageStack: root.pageStack }
    }

    toolBarLayout: ToolBarLayout {
        ButtonRow {
            platformStyle: TabButtonStyle { }
            TabButton {
                iconSource: handleIconSource("toolbar-content-audio".concat(enabled ? '' : '-dimmed'))
                tab: libraryPage
                enabled: serverListModel.currentIndex > -1
            }
            TabButton {
                iconSource: handleIconSource("toolbar-list".concat(enabled ? '' : '-dimmed'))
                tab: playlistsPage
                enabled: serverListModel.currentIndex > -1
            }
            TabButton {
                iconSource: handleIconSource("toolbar-headphones")
                enabled: currentPlaylistModel.count > 0
                opacity: enabled ? 1.0 : 0.5
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push(playerPage)
                    }
                }
            }
            TabButton {
                iconSource: handleIconSource("toolbar-share".concat(enabled ? '' : '-dimmed'))
                tab: podcastsPage
                enabled: serverListModel.currentIndex > -1
            }
            TabButton {
                iconSource: handleIconSource("toolbar-view-menu")
                tab: mainMenuPage
                checked: true
            }
        }
    }
}
