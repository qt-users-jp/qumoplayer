import QtQuick 1.1

QtObject {
    id: root
    property string version
    property bool trusted: false

    property Timer timer: Timer {
        running: true
        interval: 200
        repeat: false
        onTriggered: {
            checkVersion()
            checkSource()
        }
    }

    function checkVersion() {
        var request = new XMLHttpRequest();

        request.onreadystatechange = function() {
                    switch (request.readyState) {
                    case XMLHttpRequest.HEADERS_RECEIVED:
                        break;
                    case XMLHttpRequest.LOADING:
                        break;
                    case XMLHttpRequest.DONE: {
                        var qumoplayer = false
                        var lines = request.responseText.split('\n')
                        for (var i = 0; i < lines.length; i++) {
                            var line = lines[i]
                            if (qumoplayer) {
                                if (line.substring(0, 9) == 'Version: ') {
                                    root.version = line.substring(9)
                                    break
                                }
                            } else {
                                if (line == 'Package: qumoplayer') {
                                    qumoplayer = true
                                }
                            }
                        }
                    }
                    break
                    case XMLHttpRequest.ERROR:
                        break;
                    }
                }

        request.open('GET', 'file:///var/lib/dpkg/status');
        request.send();
    }

    function checkSource() {
        var request = new XMLHttpRequest();

        request.onreadystatechange = function() {
                    switch (request.readyState) {
                    case XMLHttpRequest.HEADERS_RECEIVED:
                        break;
                    case XMLHttpRequest.LOADING:
                        break;
                    case XMLHttpRequest.DONE: {
                        var lines = request.responseText.split('\n')
                        for (var i = 0; i < lines.length; i++) {
                            var fields = lines[i].split(/ /)
                            if (fields[12] === 'qumoplayer') {
                                root.trusted = (fields[1] === '19')
                                break
                            }
                        }
                    }
                    break
                    case XMLHttpRequest.ERROR:
                        break;
                    }
                }

        request.open('GET', 'file:///var/lib/aegis/refhashlist');
        request.send();
    }
}
