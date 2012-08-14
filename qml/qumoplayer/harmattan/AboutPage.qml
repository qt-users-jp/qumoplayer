import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "./Components/"

AbstractPage {
    id: root
    title: qsTr('About QumoPlayer')

    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.topMargin: root.headerHeight
        anchors.bottomMargin: root.footerHeight
        clip: true

        contentWidth: container.width
        contentHeight: container.height

        Column {
            id: container
            width: flickable.width
            anchors.top: parent.top

            Column {
                width: parent.width
                height: 240
                spacing: 50

                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 30
                    height: 128
                    width: height
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    source: '../image/qumoplayer.png'
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr('<a style="%1;text-decoration:none;", href="http://dev.qtquick.me/projects/qumoplayer/">QumoPlayer </a>').arg('color: darkorange').concat('v0.0.1');
                    color: 'white'
                    font.family: "Nokia Pure Text"
                    font.pointSize: 24
                    onLinkActivated: Qt.openUrlExternally(link)
                }

            }

            AbstractSectionDelegate {
                anchors { left: parent.left; right: parent.right }
                title: qsTr('Development Team')
            }

            AbstractTwoLinesDelegate {
                linkActivation: true
                width: parent.width
                title: qsTr('Takahiro Hashimoto (<a style="%1;text-decoration:none;" href="https://twitter.com/kenya888" >@kenya888</a>)').arg('color: darkorange')
                enabled: true
                icon: 'http://api.twitter.com/1/users/profile_image?screen_name=kenya888&size=bigger'
                detail: qsTr('Author, Developer')
            }

            AbstractTwoLinesDelegate {
                linkActivation: true
                width: parent.width
                title: qsTr('Tasuku Suzuki (<a style="%1;text-decoration:none;" href="https://twitter.com/task_jp" >@task_jp</a>)').arg('color: darkorange')
                enabled: true
                icon: 'http://api.twitter.com/1/users/profile_image?screen_name=task_jp&size=bigger'
                detail: qsTr('Developer, Technical Advisor.')
            }

            AbstractSectionDelegate {
                anchors { left: parent.left; right: parent.right }
                title: qsTr('Design Team')
            }

            AbstractTwoLinesDelegate {
                linkActivation: true
                width: parent.width
                title: qsTr('hirao (<a style="%1;text-decoration:none;" href="https://twitter.com/hirao_00" >@hirao_00</a>)').arg('color: darkorange')
                enabled: true
                icon: 'http://api.twitter.com/1/users/profile_image?screen_name=hirao_00&size=bigger'
                detail: qsTr('Icon Designer.')
            }

            AbstractSectionDelegate {
                anchors { left: parent.left; right: parent.right }
                title: qsTr('Thanks to')
            }

            AbstractTwoLinesDelegate {
                linkActivation: true
                width: parent.width
                title: qsTr('<a style="%1;text-decoration:none;" href="http://www.subsonic.org" >Subsonic</a>').arg('color: darkorange')
                enabled: true
                icon: '../image/subsonic.png'
                detail: qsTr('The nice media streamer')
            }
        }
    }

    toolBarLayout: AbstractToolBarLayout {
        id: toolBarLayout
        ToolBarSpacer { columns: 3 }
    }
}

