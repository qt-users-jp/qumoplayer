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
    Component { id: ad; Ad { parent: adArea } }

    Loader { id: adLoader }

    Item {
        id: adArea
        width: 350
        height: currentVersion.trusted ? 0 : 70
        opacity: currentVersion.trusted ? 0 : 1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: mainPage.footerHeight
        anchors.horizontalCenter: parent.horizontalCenter
    }

    CurrentVersion {
        id: currentVersion
        version: globalSettings.readData('System/Version')
        onVersionChanged: globalSettings.saveData('System/Version', version)
        onTrustedChanged: {
            if(!trusted) {
                acceptAdDialog.open()
            }
        }
    }

    QueryDialog {
        id: acceptAdDialog
        icon: persistentHandleIconSource('bootloader-warning')
        titleText: qsTr('Attention!!')
        message: qsTr('QumoPlayer free version uses in-app advertising system by <a style="%1;text-decoration:none;", href="http://inner-active.com">Inner-Active</a> and it sends the **IMEI** of your device to them. If you won\'t permit this, exit and please consider to use commercial version from Ovi Store.').arg('color: darkorange')
        acceptButtonText: qsTr('Accept')
        rejectButtonText: qsTr('Exit')
        onRejected: Qt.quit()
        onAccepted: adLoader.sourceComponent = ad
        onLinkActivated: Qt.openUrlExternally(link)
    }

    Binding { target: theme; property: 'inverted'; value: true }
}
