import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import QtMultimediaKit 1.1
import "../common/js/subsonic.js" as Subsonic
import "../common" as Common
import "./Components/"

AbstractPage {
    id: root

    property bool working: false

    title: qsTr("Now Playing")

    Flipable {
        id: flipable
        front: playerFace
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
            SequentialAnimation {
                NumberAnimation { target: flipable; property: "scale"; to: 0.75; duration: 250; easing.type: Easing.InOutQuad }
                NumberAnimation { target: flipable; property: "scale"; to: 1.0; duration: 250; easing.type: Easing.InOutQuad }
            }
            NumberAnimation { target: rotation; property: "angle"; duration: 500; easing.type: Easing.InOutQuad }
        }

        Grid {
            id: playerFace
            anchors.centerIn: parent
            columns: 1

            move: Transition {
                NumberAnimation {
                    properties: "x,y"
                    easing.type: Easing.OutBounce
                }
            }

            states: [
                State {
                    name: 'landscape'
                    when: !rootWindow.inPortrait
                    PropertyChanges {
                        target: playerFace
                        columns: 2
                    }
                    PropertyChanges {
                        target: upper
                        width: 300
                        height: 300
                    }
                    PropertyChanges {
                        target: lower
                        width: 400
                        height: 300
                    }
                }
            ]

            Item {
                id: upper
                width: 480
                height: 400
                Image {
                    id: playerimg
                    anchors.centerIn: parent
                    width: 300
                    height: 300
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
            }

            Item {
                id: lower
                width: 480
                height: 250
                Column {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 400
                    spacing: 10
                    Text {
                        id: songtitletext
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        color: "white"
                        font.pointSize: 25
                    }
                    Text {
                        id: artisttext
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        color: "white"
                        font.pointSize: 15
                    }

                    ProgressBar {
                        id: pgbar
                        width: parent.width * 0.75
                        anchors.horizontalCenter: parent.horizontalCenter
                        minimumValue: 0
//                        maximumValue: currentPlaylistView.currentIndex < currentPlaylistModel.count - 1 ? 0 : currentPlaylistModel.get(currentPlaylistView.currentIndex).duration * 1000
                        value: player.position
                    }

                    Rectangle {
                        id: listcontrolrect
                        color: "black"
                        height: 60; width: 200
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
                        anchors.horizontalCenter: parent.horizontalCenter

                        Row {
                            id: mediacontrolrow
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top

                            ToolIcon {
                                iconId: "toolbar-mediacontrol-previous"
                                onClicked: { if (currentPlaylistView.currentIndex !== 0 ) { currentPlaylistView.decrementCurrentIndex(); playaudio(currentPlaylistView.currentIndex, true, 0); } }
                            }

                            ToolIcon {
                                id: playicon
                                iconId: "toolbar-mediacontrol-pause"
                                onClicked: {
                                    if(player.paused || !player.playing) {
                                        console.debug("current position is ".concat(player.position))
                                        console.debug(Math.floor(player.position / 1000))
                                        Subsonic.ping(playaudio(currentPlaylistView.currentIndex, true, Math.floor(player.position / 1000)))
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
                                onClicked: { if (currentPlaylistView.currentIndex !== currentPlaylistView.count -1) { currentPlaylistView.incrementCurrentIndex(); playaudio(currentPlaylistView.currentIndex, true, 0); } }
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
                console.debug(currentPlaylistView.currentIndex)
                console.debug("Audio Status: Loaded");
                if (currentPlaylistView.currentIndex !== currentPlaylistModel.count -1) {
                    currentPlaylistView.incrementCurrentIndex()
                    playaudio(currentPlaylistView.currentIndex, true, 0);
                } else if(repeated) {
                    currentPlaylistView.currentIndex = 0;
                    playaudio(currentPlaylistView.currentIndex, true, 0);
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
        currentPlaylistView.currentIndex = index
        if (index > 0)
            player.source = Subsonic.getStreamSongUrl(currentPlaylistModel.get(currentPlaylistView.currentIndex).id, "128", "mp3", offset)
        if (play) { player.play(); }
    }

    StateGroup {
        states: [
            State {
                when: currentPlaylistView.currentIndex > -1
                PropertyChanges {
                    target: playerimg
                    source: Subsonic.getCoverArt(currentPlaylistModel.get(currentPlaylistView.currentIndex).coverArt, 300)
                }
                PropertyChanges {
                    target: songtitletext
                    text: currentPlaylistModel.get(currentPlaylistView.currentIndex).title
                }
                PropertyChanges {
                    target: artisttext
                    text: currentPlaylistModel.get(currentPlaylistView.currentIndex).artist
                }
                PropertyChanges {
                    target: pgbar
                    maximumValue: currentPlaylistModel.get(currentPlaylistView.currentIndex).duration * 1000
                }
            }
        ]
    }

    function incrindex() {
        currentPlaylistView.incrementCurrentIndex();
    }

    toolBarLayout: AbstractToolBarLayout {
        id: prefbarlayout

        MouseArea {
            width: 80
            height: 64
            onClicked: flipable.flipped = !flipable.flipped

            Flipable {
                id: flipablemini
                front: currentlistimg
                back: currentsongimg
                width: 50; height: 50
                anchors.centerIn: parent
//                anchors.verticalCenter: parent.verticalCenter
//                anchors.horizontalCenter: parent.horizontalCenter

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
                    onClicked: flipable.flipped = !flipable.flipped
                }
            }
        }

        ToolIcon {
            iconId: "toolbar-edit"
            enabled: flipable.flipped
            opacity: enabled ? 1.0 : 0.5
            onClicked: {
                toolBarLayout.closing()
                savelistdialog.open()
            }
        }

        ToolIcon {
            iconId: "toolbar-add"
            enabled: flipable.flipped
            opacity: enabled ? 1.0 : 0.5
            rotation: 45
            onClicked: {
                toolBarLayout.closing()
                playaudio(-1, false, 0)
                currentPlaylistModel.clear()
                pageStack.pop()
            }
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
            if(currentPlaylistModel.count !== 0 && currentPlaylistView.currentIndex < 0) {
                playaudio(0, false, 0);
                break;
            }
        }
        }
    }
}
