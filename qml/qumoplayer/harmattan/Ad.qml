import QtQuick 1.1
import "../inneractive"

Item {
    id: root
    width: 350
    height: visible ? 70 : 0
    anchors.horizontalCenter: parent.horizontalCenter

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
