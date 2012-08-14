import QtQuick 1.1

MouseArea {
    id: root
    width: 400
    height: 70

    property alias icon: icon.source
    property int rightMargin: 0

    Image {
        id: icon
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 5
        width: height
        fillMode: Image.PreserveAspectFit
        smooth: true
    }

    Separator { anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom }
}
