import QtQuick 1.1

Item {
    width: (rootWindow.inPortrait ? 480 : 854 ) / 5 * columns
    height: 32

    property int columns: 1
}
