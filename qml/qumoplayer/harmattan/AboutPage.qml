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

            AbstractTwoLinesDelegate {
                linkActivation: true
                width: parent.width
                title: qsTr('<a style="%1;", href="http://dev.qtquick.me/projects/qumoplayer/">QumoPlayer for N9</a>').arg('color: darkorange')
                enabled: true
                icon: '../image/qumoplayer.png'
                detail: 'Subsonic Client for Nokia N9'
            }

            AbstractTwoLinesDelegate {
                linkActivation: true
                width: parent.width
                title: qsTr('Takahiro Hashimoto (<a style="%1;" href="https://twitter.com/kenya888" >@kenya888</a>)').arg('color: darkorange')
                enabled: true
                icon: 'http://api.twitter.com/1/users/profile_image?screen_name=kenya888&size=bigger'
                detail: qsTr('Author.')
            }

            AbstractTwoLinesDelegate {
                linkActivation: true
                width: parent.width
                title: qsTr('Tasuku Suzuki (<a style="%1;" href="https://twitter.com/task_jp" >@task_jp</a>)').arg('color: darkorange')
                enabled: true
                icon: 'http://api.twitter.com/1/users/profile_image?screen_name=task_jp&size=bigger'
                detail: qsTr('Developer, Technical Advisor.')
            }

            AbstractTwoLinesDelegate {
                linkActivation: true
                width: parent.width
                title: qsTr('hirao (<a style="%1;" href="https://twitter.com/hirao_00" >@hirao_00</a>)').arg('color: darkorange')
                enabled: true
                icon: 'http://api.twitter.com/1/users/profile_image?screen_name=hirao_00&size=bigger'
                detail: qsTr('Icon Desginer.')
            }
        }
    }

    toolBarLayout: AbstractToolBarLayout {
        id: toolBarLayout
        ToolBarSpacer { columns: 3 }
    }
}

