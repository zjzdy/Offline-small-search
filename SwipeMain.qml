import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0

Page {
    id: page
    width: 720
    height: 1280
    property real a_max: Math.max(width,height)
    //property real a_min: Math.min(width,height)
    property real a_pd: 0
    //property real a_sqrt: Math.min(Math.sqrt(a_max/1280*a_min/720),a_pd/12)

    SwipeView {
        id: swipeView
        objectName: "swipeView"
        anchors.fill: parent
        currentIndex: 0
        onCurrentIndexChanged: tabBar.currentIndex = currentIndex
        Main {
            a_pd: page.a_pd
            id: main
        }
        MoreSearch {
            a_pd: page.a_pd
            id: moreSearch
        }
        History {
            a_pd: page.a_pd
            id: history
        }
        More {
            a_pd: page.a_pd
            id: more
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        onCurrentIndexChanged: swipeView.currentIndex = currentIndex
        width: page.width
        height: 105*Math.min(page.a_max/1280,a_pd/12)
        background: Rectangle {
            color: "#f0f0f0"
        }
        spacing: 2
        MTabButton {
            height: parent.height
            text: qsTr("一键搜索")
        }
        MTabButton {
            height: parent.height
            text: qsTr("更多搜索")
        }
        MTabButton {
            height: parent.height
            text: qsTr("历史记录")
        }
        MTabButton {
            height: parent.height
            text: qsTr("更多")
        }
    }
}
