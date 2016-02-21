import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2

Rectangle {
    id: rectangle2
    width: 720
    height: 1280
    color: "#f6f6f6"
    property real a_max: Math.max(width,height)
    property real a_min: Math.min(width,height)
    property real a_pd: 0
    property real a_sqrt: Math.min(Math.sqrt(a_max/1280*a_min/720),a_pd/12)

    MessageDialog {
        id: exit_messageDialog
        title: qsTr("退出")
        text: qsTr("您真的要退出吗?")
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: main_widget.close_app()
    }

    Rectangle {
        id: rectangle1
        width: rectangle2.width
        height: 105*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#f0f0f0"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        MouseArea {
            id: button1
            anchors.rightMargin: rectangle2.width/4*3
            anchors.fill: parent
            onClicked: main_widget.show_main()

            Text {
                id: text1
                text: qsTr("一键搜索")
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 30*rectangle2.a_sqrt
            }
        }

        MouseArea {
            id: button2
            anchors.leftMargin: rectangle2.width/4*1
            anchors.rightMargin: rectangle2.width/4*2
            anchors.fill: parent
            onClicked: main_widget.show_more_search()

            Text {
                id: text2
                text: qsTr("更多搜索")
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 30*rectangle2.a_sqrt
            }
        }

        MouseArea {
            id: button3
            anchors.leftMargin: rectangle2.width/4*2
            anchors.rightMargin: rectangle2.width/4*1
            anchors.fill: parent
            onClicked: main_widget.show_history()

            Text {
                id: text3
                text: qsTr("历史记录")
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 30*rectangle2.a_sqrt
            }
        }

        MouseArea {
            id: button4
            anchors.leftMargin: rectangle2.width/4*3
            anchors.fill: parent
            onClicked: main_widget.show_more()

            Text {
                id: text4
                text: qsTr("更多")
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 30*rectangle2.a_sqrt
            }
        }
    }

    Item {
        id: column1
        anchors.bottom: rectangle1.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottomMargin: 0

        Rectangle {
            id: rectangle3
            height: 100*Math.min(rectangle2.a_max/1280,a_pd/12)
            color: "#f0f0f0"
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0

            Text {
                id: text8
                text: qsTr("更多搜索")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 45*Math.min(rectangle2.a_max/1280,a_pd/12)
            }
        }
        GridView {
            id: gridView1
            anchors.top: rectangle3.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.topMargin: 0
            model: more_search_list
            z: -1
            cellWidth: 240*Math.min(rectangle2.a_min/720,a_pd/12)
            cellHeight: 250*Math.min(rectangle2.a_max/1280,a_pd/12)

            delegate: Item {
                width: 240*Math.min(rectangle2.a_min/720,a_pd/12)
                height: 240*Math.min(rectangle2.a_max/1280,a_pd/12)
                Column {
                    z: -2
                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: 20*Math.min(rectangle2.a_min/720,a_pd/12)
                        height: 200*Math.min(rectangle2.a_max/1280,a_pd/12)
                        width: height
                        border.width: 0
                        radius: height/2
                        Text {
                            text: model.modelData.name.charAt(0)
                            anchors.centerIn: parent
                            font.pixelSize: 100*Math.min(rectangle2.a_max/1280,a_pd/12)
                        }
                        color: main_widget.rand_lightcolor(model.modelData.name)
                    }
                    Text {
                        id: mm
                        text: model.modelData.name
                        width: 200*Math.min(rectangle2.a_max/1280,a_pd/12)
                        height: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
                        font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
                        horizontalAlignment: Text.AlignHCenter
                        maximumLineCount: 1
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        anchors.left: parent.left
                        property real margin: (width-contentWidth)/2
                        anchors.leftMargin: (margin > 0) ? margin : 0
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        main_widget.search_type_clear()
                        main_widget.search_type_add(model.modelData.name_code)
                        main_widget.set_top_bar_height(100*Math.min(rectangle2.a_max/1280,a_pd/12))
                        console.log("have home ",main_widget.have_home())
                        main_widget.have_home() ? main_widget.show_pkg_home() : main_widget.show_search();
                    }
                }
            }
        }
    }
}
