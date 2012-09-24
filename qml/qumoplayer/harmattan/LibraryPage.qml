import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "../common" as Common
import "./Components/"

AbstractTabLoadablePage {
    id: root
    title: qsTr('Music Library')
    model: libraryModel

    Common.LibraryModel {
        id: libraryModel
    }

    Component {
        id: libraryDelegate
        AbstractOneLineDelegate {
            width: ListView.view.width

            icon: handleIconSource("toolbar-directory")
            title: model.name

            onClicked: {
                pageStack.push(musicDirectoryPage, { _id: model.id, title: model.name} );
            }
        }
    }

    Component {
        id: librarySectionDelegate
        Rectangle {
            width: parent.width
            //width: parent.width/4
            height: 40
            //color: header.color
            gradient: Gradient {
                id: grad
                GradientStop { position: 0.1; color: "black" }
                GradientStop { position: 1.0; color: "darkorange" }
            }
            Text {
                anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 15 }
                text: section
                font.pointSize: 20
                color: "white"
                font.capitalization: Font.Capitalize
            }
        }
    }

    AbstractListView {
        id: libraryView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: searchButton.top
        model: libraryModel
        delegate: libraryDelegate
        clip: true
        loading: root.loading
    }

    TextField {
        id: searchField
        anchors { left: parent.left; right: searchButton.left; verticalCenter: searchButton.verticalCenter }
        readOnly: false
        placeholderText: qsTr('Search')
        platformSipAttributes: SipAttributes {
            actionKeyLabel: 'Search'
            actionKeyEnabled: searchField.text.length > 0
        }
        platformStyle: TextFieldStyle { paddingRight: clearButton.width }
        Image {
            id: clearButton
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: persistentHandleIconSource("input-clear")
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    inputContext.reset();
                    searchField.text = '';
                }
            }
        }
        Keys.onReturnPressed: searchButton.search()
    }

    ToolIcon {
        id: searchButton
        anchors { bottom: parent.bottom; right: parent.right; bottomMargin: root.footerWithAdHeight }
        enabled: searchField.text.length > 0
        platformIconId: "toolbar-search"
        onClicked: search()
        function search() {
            searchButton.forceActiveFocus()
            pageStack.push(searchPage, {'title': searchField.text})
        }
    }
}
