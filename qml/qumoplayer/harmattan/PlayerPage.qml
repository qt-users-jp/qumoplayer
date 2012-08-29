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
    property alias playingimg: currentsongimg.source
    property alias playing: player.playing

    title: qsTr("Now Playing")

    property variant indicesShuffled: []

    Connections {
        target: currentPlaylistView
        onCurrentIndexChanged: {
            checkSongIndex()
        }
    }

    Connections {
        target: player
        onRepeatedChanged: {
            checkSongIndex()
        }
        onShuffledChanged: {
            checkSongIndex()
        }
    }

    function checkSongIndex() {
        if (!player.repeated) {
            var first
            var last

            if (player.shuffled) {
                first = root.indicesShuffled[0]
                last = root.indicesShuffled[root.indicesShuffled.length - 1]
            } else {
                first = 0
                last = currentPlaylistView.count -1
            }

            switch(currentPlaylistView.currentIndex) {
            case first: {
                player.atFirst = true
                player.atLast = false
                break
            }
            case last: {
                player.atFirst = false
                player.atLast = true
                break
            }
            default: {
                player.atFirst = false
                player.atLast = false
                break
            }
            }
        } else {
            player.atFirst = false
            player.atLast = false
        }
    }

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
                        spacing: 25
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
                height: 360
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
                    spacing: 5
                    AutoScrollText {
                        id: songTitle
                        width: parent.width
                        height: 50
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        color: "white"
                        font.pointSize: 25
                        MouseArea {
                            anchors.fill: parent
                            onPressAndHold: songTitle.doScroll()
                        }
                    }
                    AutoScrollText {
                        id: artist
                        width: parent.width
                        height: 25
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        color: "white"
                        font.pointSize: 15
                        MouseArea {
                            anchors.fill: parent
                            onPressAndHold: artist.doScroll()
                        }
                    }

                    Row {
                        id: timeRow
                        anchors { bottom: progressBar.top; horizontalCenter: parent.horizontalCenter }
                        width: parent.width * 0.85

                        Text {
                            id: position
                            width: parent.width / 2
                            horizontalAlignment: Text.AlignLeft
                            text: convertTime(0)
                            color: "white"
                            font.pointSize: 13

                            states: [
                                State {
                                    when: player.tictac
                                    PropertyChanges {
                                        target: position
                                        text: convertTime(player.secondsPosition)
                                    }
                                    PropertyChanges {
                                        target: player
                                        tictac: false
                                    }
                                }
                            ]
                        }

                        Text {
                            id: duration
                            width: parent.width / 2
                            horizontalAlignment: Text.AlignRight
                            text: convertTime(0)
                            color: "white"
                            font.pointSize: 13
                        }

                    }

                    ProgressBar {
                        id: progressBar
                        width: timeRow.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        minimumValue: 0
                        value: player.position
                    }

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        ToolIcon {
                            iconSource: persistentHandleIconSource(player.repeated ? 'toolbar-repeat-white-selected' : 'toolbar-repeat-white')
                            onClicked: player.repeated = !player.repeated
                        }
                        ToolIcon {
                            iconSource: persistentHandleIconSource(player.shuffled ? 'toolbar-shuffle-white-selected' : 'toolbar-shuffle-white')
                            onClicked: player.shuffled = !player.shuffled
                        }
                        ToolIcon {
                            iconId: player.muted ? 'toolbar-volume-off' : 'toolbar-volume'
                            onClicked: player.muted = !player.muted
                        }
                    }
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter

                        ToolIcon {
                            id: playPreviousSong
                            iconId: "toolbar-mediacontrol-previous"
                            enabled: !player.atFirst
                            opacity: enabled ? 1.0 : 0.5
                            onClicked: player.playPrevious()
                        }

                        ToolIcon {
                            id: playAndPauge
                            iconId: "toolbar-mediacontrol-play"
                            onClicked: {
                                if (state == 'playing') {
                                    player.pause();
                                } else {
                                    console.debug("current position is ".concat(player.position))
                                    Subsonic.ping(playaudio(currentPlaylistView.currentIndex, true, Math.floor(player.secondsPosition)))
                                }
                            }

                            states: [
                                State {
                                    name: 'playing'
                                    PropertyChanges { target: playAndPauge; iconId: "toolbar-mediacontrol-pause" }
                                    when: player.playing && !player.paused
                                }
                            ]
                        }
                        ToolIcon {
                            id: playNextSong
                            iconId: "toolbar-mediacontrol-next"
                            enabled: !player.atLast
                            opacity: enabled ? 1.0 : 0.5
                            onClicked: player.playNext()
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
            highlight: Rectangle {
                width: currentPlaylistView.width
                height: 10
                color: 'darkorange'
                opacity: 0.5
            }

            clip: true
        }

        Component {
            id: currentPlaylistDelegate
            AbstractTwoLinesDelegate {
                id: delegate
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
                                if (currentPlaylistView.currentIndex === model.index) {
                                    playaudio(-1, false, 0)
                                }
                                currentPlaylistModel.remove(i)
                                break
                            }
                        }
                        if (currentPlaylistView.count == 0 ) {
                            pageStack.pop()
                        }
                    }
                }

                ListView.onRemove: SequentialAnimation {
                    PropertyAction { target: delegate; property: "ListView.delayRemove"; value: true }
                    PropertyAction { target: delegate; property: "clip"; value: true }
                    NumberAnimation { target: delegate; property: "opacity"; to: 0.25; duration: 200; easing.type: Easing.InOutQuad }
                    NumberAnimation {
                        target: delegate
                        property: "height"
                        to: 0
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                    PropertyAction { target: delegate; property: "clip"; value: false }
                    PropertyAction { target: delegate; property: "ListView.delayRemove"; value: false }
                }
            }
        }
    }

    InfoBanner {
        id: infoBanner
        iconSource: handleIconSource("bootloader-warning")
        topMargin: 80
        text: "Error: " + player.errorString
        timerEnabled: false
        //timerShowTime: 3000
    }

    Connections {
        target: currentPlaylistModel
        onCountChanged: player.shuffle()
    }

    Connections {
        target: player
        onSecondsPositionChanged: { player.tictac = true }
    }

    Audio {
        id: player
        property bool shuffled: false
        property bool repeated: false
        property bool atFirst: true
        property bool atLast: false

        property int secondsPosition: Math.floor(player.position / 1000)
        property bool tictac: false

        function playNext() {
            if (player.shuffled) {
                var index = root.indicesShuffled.indexOf(currentPlaylistView.currentIndex)
                if (index !== root.indicesShuffled.length - 1) {
                    currentPlaylistView.currentIndex = root.indicesShuffled[index + 1]
                    playaudio(currentPlaylistView.currentIndex, true, 0);
                } else if (player.repeated) {
                    currentPlaylistView.currentIndex = root.indicesShuffled[0]
                    playaudio(currentPlaylistView.currentIndex, true, 0);
                } else {
                    player.pause()
                }
            } else {
                if (currentPlaylistView.currentIndex !== currentPlaylistModel.count -1) {
                    currentPlaylistView.incrementCurrentIndex()
                    playaudio(currentPlaylistView.currentIndex, true, 0);
                } else if(player.repeated) {
                    currentPlaylistView.currentIndex = 0;
                    playaudio(currentPlaylistView.currentIndex, true, 0);
                } else {
                    player.pause()
                }
            }
        }

        function playPrevious() {
            if (player.shuffled) {
                var index = root.indicesShuffled.indexOf(currentPlaylistView.currentIndex)
                if (index !== 0) {
                    currentPlaylistView.currentIndex = root.indicesShuffled[index - 1]
                    playaudio(currentPlaylistView.currentIndex, true, 0)
                } else if (player.repeated) {
                    currentPlaylistView.currentIndex = root.indicesShuffled[currentPlaylistModel.count - 1]
                    playaudio(currentPlaylistView.currentIndex, true, 0)
                }
            } else {
                if (currentPlaylistView.currentIndex !== 0) {
                    currentPlaylistView.decrementCurrentIndex()
                    playaudio(currentPlaylistView.currentIndex, true, 0)
                } else if (player.repeated) {
                    currentPlaylistView.currentIndex = currentPlaylistModel.count - 1
                    playaudio(currentPlaylistView.currentIndex, true, 0)
                }
            }
        }

        function shuffle() {
            if (player.shuffled) {
                var indicesShuffled = new Array()
                for (var i = 0; i < currentPlaylistModel.count; i++) {
                    indicesShuffled.push(i)
                }
                indicesShuffled.sort(function(a, b) { return Math.random() * 2 - 1 })
                root.indicesShuffled = indicesShuffled
            }
        }

        onShuffledChanged: player.shuffle()

        onStatusChanged: {
            switch(status) {
            case Audio.EndOfMedia:
                player.playNext()
                break;
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
                infoBanner.show();
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
        if (index > -1) {
            var song = currentPlaylistModel.get(currentPlaylistView.currentIndex)
            if (typeof song.streamId !== 'undefined' && song.streamId.length > 0) {
                player.source = Subsonic.getStreamSongUrl(song.streamId, "128", "mp3", offset)
            } else {
                player.source = Subsonic.getStreamSongUrl(song.id, "128", "mp3", offset)
            }
        }
        if (play) { player.play() } else { player.stop() }
    }

    function convertTime(sec) {
        var minutes = Math.floor(sec / 60)
        var seconds = Math.floor(sec - minutes * 60 )
        return (minutes < 10 ? '0'.concat(minutes) : minutes).concat(':').concat(seconds < 10 ? '0'.concat(seconds) : seconds)
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
                    target: currentsongimg
                    source: Subsonic.getCoverArt(currentPlaylistModel.get(currentPlaylistView.currentIndex).coverArt, 50)
                }
                PropertyChanges {
                    target: songTitle
                    text: currentPlaylistModel.get(currentPlaylistView.currentIndex).title
                }
                PropertyChanges {
                    target: artist
                    text: currentPlaylistModel.get(currentPlaylistView.currentIndex).artist
                }
                PropertyChanges {
                    target: progressBar
                    maximumValue: currentPlaylistModel.get(currentPlaylistView.currentIndex).duration * 1000
                }
                PropertyChanges {
                    target: duration
                    text: convertTime(currentPlaylistModel.get(currentPlaylistView.currentIndex).duration)
                }
            }
        ]
    }

    toolBarLayout: AbstractToolBarLayout {
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
                savePlaylistDialog.open()
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
        id: savePlaylistDialog
        visualParent: pageStack
        title: Item { width: parent.width; height: 30; anchors.horizontalCenter: parent.horizontalCenter; Text { id: titletext; anchors.fill: parent; text: "Save Playlist"; font.pointSize: 20; color: "white" } Rectangle { height: 1; width: parent.width; color: "darkorange"; anchors.top: titletext.bottom} }
        content: Item { width: parent.width; height: 100; anchors.horizontalCenter: parent.horizontalCenter; Text { id: listnametext; font.pointSize: 16; color: "white"; text: "Playlist name:"; } TextField { id: listname; anchors { top:listnametext.bottom; topMargin: 5; left: parent.left; right: parent.right } } }
        buttons: Row { spacing: 10; anchors.horizontalCenter: parent.horizontalCenter; Button { width: 120; text: "save"; onClicked: savePlaylistDialog.accept();} Button { width: 120; text: "cancel"; onClicked: savePlaylistDialog.reject(); } }
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
