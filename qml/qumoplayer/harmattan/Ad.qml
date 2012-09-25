import QtQuick 1.1
import "../inneractive"

Item {
    id: root
    width: 350
    height: currentVersion.trusted ? 0 : 70
    opacity: currentVersion.trusted ? 0 : 1
    anchors.horizontalCenter: parent.horizontalCenter

    Connections {
        target: currentVersion
        onTrustedChanged: {
            if(currentVersion.trusted) {
                root.destroy()
            }
        }
    }

    AdItem {
        id: adItem
        parameters: AdParameters {
            applicationId: "personal_QumoPlayer_Nokia"
        }
        showText: false
        scaleAd: true
        anchors.fill: parent
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        reloadInterval: 60
        retryOnError: true
    }

    states: [
        State {
            name: "onPlayer"
            when: pageStack.currentPage === playerPage
            PropertyChanges {
                target: root
                opacity: 0
            }
        }
    ]
    transitions: [
        Transition {
            NumberAnimation { property: 'opacity'; duration: 500; alwaysRunToEnd: true }
        }
    ]
}
