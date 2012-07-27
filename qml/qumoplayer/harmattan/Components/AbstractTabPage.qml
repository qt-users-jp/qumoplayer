import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: root

    property string title
    property int footerHeight: 70

    property bool loadable: false
    property bool loading: false
    function load() {}
}
