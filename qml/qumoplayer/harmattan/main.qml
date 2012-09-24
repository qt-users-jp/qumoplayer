// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import me.qtquick.qumoplayer 1.0 as QumoPlayer
import "../common" as Common
import "./Components/"
import "../common/js/subsonic.js" as Subsonic

PageStackWindow {
    id: rootWindow
    initialPage: mainPage
    showStatusBar: rootWindow.inPortrait

    Settings {
        id: globalSettings
    }

    Timer {
        id: testTimer
        interval: 10000
        repeat: false
        onTriggered: {
            console.debug('Test end')
            if (!test.manual)
                test.end(0)
        }
    }

    QumoPlayer.Test {
        id: test
        onStart: {
            console.debug('Test start')
            testTimer.start()
        }
    }

    function handleIconSource(iconId) {
        var prefix = "icon-m-"
        // check if id starts with prefix and use it as is
        // otherwise append prefix and use the inverted version if required
        if (iconId.indexOf(prefix) !== 0)
            iconId =  prefix.concat(iconId).concat(theme.inverted ? "-white" : "");
        return "image://theme/" + iconId;
    }

    function persistentHandleIconSource(iconId) {
        var prefix = "icon-m-"
        if (iconId.indexOf(prefix) !== 0)
            iconId =  prefix.concat(iconId);
        return "image://theme/" + iconId;
    }

    Common.ServerListModel {
        id: serverListModel
        Component.onCompleted: {
            serverListModel.currentIndex = globalSettings.readData('Server/CurrentIndex', -1)
        }
    }

    Connections {
        target: serverListModel
        onCurrentIndexChanged: {
            Subsonic.currentServer = serverListModel.get(serverListModel.currentIndex)
            globalSettings.saveData('Server/CurrentIndex', serverListModel.currentIndex)
        }
    }

    Common.CurrentPlaylistModel { id: currentPlaylistModel }

    MainPage { id: mainPage }
    PlayerPage { id: playerPage }
    Component { id: musicDirectoryPage; MusicDirectoryPage {} }
    Component { id: serverSettingsPage; ServerSettingsPage {} }
    Component { id: playlistPage; PlaylistPage {} }
    Component { id: searchPage; SearchPage {} }
    Component { id: serverListPage; ServerListPage {} }
    Component { id: preferencesPage; PreferencesPage {} }
    Component { id: aboutPage; AboutPage {} }

    Ad {
        id: ad
        anchors.bottom: parent.bottom
        anchors.bottomMargin: mainPage.footerHeight
    }

    Binding { target: theme; property: 'inverted'; value: true }
}
