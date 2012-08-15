import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import QtMultimediaKit 1.1
import "../common/js/subsonic.js" as Subsonic
import "../common" as Common
import "./Components/"

AbstractPage {
    id: root

    property int currentindex: 0
    property bool working: false

    title: qsTr("Now Playing")

    Flipable {
        id: flipable
        front: flipplayer
        back: currentPlaylistView
        anchors.fill: parent
        anchors.topMargin: root.headerHeight
        anchors.bottomMargin: root.footerHeight
        z: -1

        property bool flipped: false

        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis.x: 0; axis.y: 1; axis.z:0;
            angle: 0
        }

        states: State {
            name: "back"
            PropertyChanges { target: rotation; angle: 180 }
            when: flipable.flipped
        }

        transitions: Transition {
            NumberAnimation { target: rotation; property: "angle"; duration: 400; easing.type: Easing.InOutQuad }
        }

        Item {
            id: flipplayer
            anchors.fill: parent

            Item {
                anchors.top: parent.top
                //anchors.topMargin: playerheader.height
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                //anchors.fill: parent
                //color: "black"
                Item {
                    id: imgitem
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top : parent.top
                    anchors.topMargin: 50
                    width: 300
                    height: 300
                    Image {
                        id: playerimg
                        //source: Subsonic.getCoverArt(currentplaylistmodel.get(currentindex).coverartid, 300);
                        anchors.fill: parent
                        sourceSize.width: 300
                        sourceSize.height: 300
                    }
                }

                Column {
                    id: songinfocolumn
                    anchors.top: imgitem.bottom
                    anchors.topMargin: 30
                    anchors.horizontalCenter:  parent.horizontalCenter
                    Text {
                        id: songtitletext
                        anchors.horizontalCenter: parent.horizontalCenter
                        //text: currentplaylistmodel.get(currentindex).songtitle
                        color: "white"
                        font.pointSize: 25
                    }
                    Text {
                        id: artisttext
                        anchors.horizontalCenter: parent.horizontalCenter
                        //text: currentplaylistmodel.get(currentindex).artist
                        color: "white"
                        font.pointSize: 15
                    }
                }

                ProgressBar {
                    anchors.top: songinfocolumn.bottom
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: pgbar
                    width: 350
                    //maximumValue: player.duration
                    maximumValue: root.currentindex < currentPlaylistModel.count - 1 ? 0 : currentPlaylistModel.get(root.currentindex).duration * 1000
                    minimumValue: 0
                    value: player.position
                    visible: true
                }

                Item {
                    id: controlrect
                    anchors.top: pgbar.bottom
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        id: listcontrolrect
                        color: "black"
                        height: 60; width: 200
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter

                        Row {
                            id: listcontrolrow
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            ToolIcon {
                                id: repeatbtn
                                iconId: "toolbar-repeat"
                                onClicked: player.repeated = !player.repeated
                                states: [
                                    State {
                                        name: "repeated"
                                        PropertyChanges { target: repeatbtn; iconSource: persistentHandleIconSource("toolbar-repeat-white-selected") }
                                        when: player.repeated
                                    }
                                ]
                            }
                            ToolIcon {
                                id: shufflebtn
                                iconId: "toolbar-shuffle"
                                onClicked: player.shuffled = !player.shuffled
                                states: [
                                    State {
                                        name: "shuffled"
                                        PropertyChanges { target: shufflebtn; iconSource: persistentHandleIconSource("toolbar-shuffle-white-selected") }
                                        when: player.shuffled
                                    }
                                ]
                            }
                            ToolIcon {
                                id: mutebtn
                                iconId: "toolbar-volume"
                                onClicked: player.muted = !player.muted
                                states: [
                                    State {
                                        name: "mute"
                                        PropertyChanges { target: mutebtn; iconId: "toolbar-volume-off" }
                                        when: player.muted
                                    }
                                ]
                            }
                        }
                    }

                    Rectangle {
                        id: mediacontrolrect
                        color: "black"
                        height: 60; width: 200
                        anchors.top: listcontrolrect.bottom
                        anchors.horizontalCenter: parent.horizontalCenter

                        Row {
                            id: mediacontrolrow
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top

                            ToolIcon {
                                iconId: "toolbar-mediacontrol-previous"
                                onClicked: { if (currentindex !== 0 ) { currentindex = currentindex - 1; playaudio(currentindex, true, 0); } }
                            }

                            ToolIcon {
                                id: playicon
                                iconId: "toolbar-mediacontrol-pause"
                                onClicked: {
                                    if(player.paused || !player.playing) {
                                        console.debug("current position is ".concat(player.position))
                                        console.debug(Math.floor(player.position / 1000))
                                        Subsonic.ping(playaudio(currentindex, true, Math.floor(player.position / 1000)))
                                        //player.play();
                                    } else {
                                        player.pause();
                                        console.debug("current position is ".concat(player.position))
                                    }
                                }

                                states: [ State {
                                        name: "playbtn"
                                        PropertyChanges { target: playicon; iconId: "toolbar-mediacontrol-play" }
                                        when: player.paused || !player.playing
                                    }
                                ]
                            }
                            ToolIcon {
                                iconId: "toolbar-mediacontrol-next"
                                onClicked: { if (currentindex !== currentPlaylistView.count -1) { currentindex = currentindex + 1; playaudio(currentindex, true, 0); } }
                            }
                        }
                    }
                }
            }
        }

        AbstractListView {
            id: currentPlaylistView
            anchors.fill: parent
            model: currentPlaylistModel
            delegate: currentPlaylistDelegate
            clip: true
            currentIndex: -1
        }
        Component {
            id: currentPlaylistDelegate
            AbstractTwoLinesDelegate {
                width: ListView.view.width
                icon: Subsonic.getCoverArt(model.coverArt, 300)
                rightMargin: operationArea.width

                title: model.title
                detail: model.artist

                onClicked: {
                    playaudio(model.index, true, 0)
                    flipable.flipped = !flipable.flipped
                }

                OperationArea {
                    id: operationArea
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right

                    added: currentPlaylistModel.ids.indexOf(model.id) > -1
                    onAdd: {
                        currentPlaylistModel.append(musicDirectoryModel.get(model.index))
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
    }

    InfoBanner {
        id: playerinfobanner
        iconSource: handleIconSource("bootloader-warning")
        topMargin: 80
        text: "Error: " + player.errorString
        timerEnabled: false
        //timerShowTime: 3000
    }


    Audio {
        id: player
        property bool shuffled: false
        property bool repeated: false
        onStatusChanged: {
            switch(status) {
            case Audio.EndOfMedia: {
                console.debug(currentindex)
                console.debug("Audio Status: Loaded");
                if ( currentindex !== currentPlaylistModel.count -1 ) {
                    currentindex = currentindex + 1;
                    playaudio(currentindex, true, 0);
                } else if(repeated) {
                    currentindex = 0;
                    playaudio(currentindex, true, 0);
                } else {
                    player.pause()
                }
                    break;
            }
            /*case Audio.Buffering | Audio.Stalled | Audio.Loading: {
                working = true;
                break;
            }*/
            case Audio.NoMedia: {
                console.debug("Audio Status: No Media");
                break;
            }
            case Audio.Loading: {
                console.debug("Audio Status: Loading");
                break;
            }
            case Audio.Loaded: {
                console.debug("Audio Status: Loaded");
                break;
            }
            case Audio.Buffering: {
                console.debug("Audio Status: Buffering");
                break;
            }
            case Audio.Stalled: {
                console.debug("Audio Status: Stalled");
                break;
            }
            case Audio.Buffered: {
                console.debug("Audio Status: Stalled");
                break;
            }
            case Audio.InvalidMedia: {
                console.debug("Audio Status: InvalidMedia");
                playerinfobanner.show();
                player.stop();
                break;
            }
            case Audio.UnknownStatus: {
                console.debug("Audio Status: Stalled");
                break;
            }
            default: {
                working = false;
                break;
            }
            }
        }
        Component.onCompleted: pause();
    }

    function playaudio(index, play, offset) {
        //player.pause();
        currentindex = index;
        playerimg.source = Subsonic.getCoverArt(currentPlaylistModel.get(currentindex).coverArt, 300);
        console.debug(playerimg.source);
        player.source = Subsonic.getStreamSongUrl(currentPlaylistModel.get(currentindex).id, "128", "mp3", offset);
        console.debug(player.source);
        songtitletext.text = currentPlaylistModel.get(currentindex).title;
        artisttext.text = currentPlaylistModel.get(currentindex).artist;
        pgbar.maximumValue = currentPlaylistModel.get(currentindex).duration * 1000;
        console.debug(songtitletext.text + artisttext.text + pgbar.maximumValue );
        if (play) { player.play(); }
    }

    function removeFromPlaylist(string) {
        if(string === "all") {
            currentPlaylistView.currentIndex = -1;
            currentPlaylistModel.clear();
            playaudio(-1, false, 0);
        } else {
            currentPlaylistModel.remove(currentPlaylistView.currentIndex);
            if(currentindex === currentPlaylistView.currentIndex) {
                currentindex = currentPlaylistView.currentIndex;
                currentPlaylistView.currentIndex = -1;
                playaudio(currentindex, false, 0);
            }
        }
    }

    function incrindex() {
        currentPlaylistView.incrementCurrentIndex();
    }

    toolBarLayout: AbstractToolBarLayout {
        id: prefbarlayout

        Flipable {
            id: flipablemini
            front: currentlistimg
            back: currentsongimg
            width: 50; height: 50
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            transform: Rotation {
                id: rotationmini
                origin.x: flipablemini.width/2
                origin.y: flipablemini.height/2
                axis.x: 0; axis.y: 1; axis.z:0;
                angle: 0
            }

            states: State {
                name: "backmini"
                PropertyChanges { target: rotationmini; angle: 180 }
                when: flipable.flipped
            }

            transitions: Transition {
                NumberAnimation { target: rotationmini; property: "angle"; duration: 400; easing.type: Easing.InOutQuad }
            }

            Image {
                id: currentsongimg
                anchors.centerIn: parent
                source: playerimg.source
                sourceSize.width: parent.width; sourceSize.height: parent.height
            }
            ToolIcon {
                id: currentlistimg
                anchors.centerIn: parent
                iconId: "toolbar-list"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: { flipable.flipped = !flipable.flipped;}
            }
        }

        ToolBarSpacer {}
        ToolIcon {
            iconId: "toolbar-view-menu"
            onClicked: (cplmenu2.status === DialogStatus.Closed) ? cplmenu2.open() : cplmenu2.close();
        }
    }

    Menu {
        id: cplmenu2
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: "Save Current Playlist";
                onClicked: savelistdialog.open();
            }
            MenuItem { text: "Clear playlist"; onClicked: removeFromPlaylist("all"); }

            //onClicked: playaudio(currentplaylistview.currentIndex, true) }
            //MenuItem { text: "Remove"; onClicked: removeFromPlaylist(); }
            //MenuItem { text: "Clear playlist"; onClicked: removeFromPlaylist("all"); }
        }
    }

    Dialog {
        id: savelistdialog
        visualParent: pageStack
        title: Item { width: parent.width; height: 30; anchors.horizontalCenter: parent.horizontalCenter; Text { id: titletext; anchors.fill: parent; text: "Save Playlist"; font.pointSize: 20; color: "white" } Rectangle { height: 1; width: parent.width; color: "darkorange"; anchors.top: titletext.bottom} }
        content: Item { width: parent.width; height: 100; anchors.horizontalCenter: parent.horizontalCenter; Text { id: listnametext; font.pointSize: 16; color: "white"; text: "Playlist name:"; } TextField { id: listname; anchors { top:listnametext.bottom; topMargin: 5; left: parent.left; right: parent.right } } }
        buttons: Row { spacing: 10; anchors.horizontalCenter: parent.horizontalCenter; Button { width: 120; text: "save"; onClicked: savelistdialog.accept();} Button { width: 120; text: "cancel"; onClicked: savelistdialog.reject(); } }
        onAccepted: Subsonic.createPlayList(listname.text, currentPlaylistModel, function(ret){console.debug(ret)});
    }

    onStatusChanged: {
        switch(status) {
        case PageStatus.Activating: {
            flipable.flipped = false;
            break;
        }
        case PageStatus.Active: {
            if(currentPlaylistModel.count !== 0 && currentindex === 0) {
                playaudio(currentindex, false, 0);
                break;
            }
        }
        }
    }
}
