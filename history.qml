import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
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
/*
    Rectangle {
        id: rectangle1
        //y: 1175*rectangle2.a_max/1280
        width: rectangle2.width
        height: 105*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#f0f0f0"
        z: 1
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
*/
    Rectangle {
        id: rectangle3
        height: 100*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#f0f0f0"
        z: 1
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0


        Text {
            id: text8
            text: qsTr("历史记录")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 45*Math.min(rectangle2.a_max/1280,a_pd/12)
        }

        Image {
            id: image2
            width: height
            anchors.right: parent.right
            anchors.rightMargin: 20*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            source: "qrc:/image/icon_remove_normal.png"

            MouseArea {
                id: mouseArea2
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.fill: parent
                onClicked: remove_all.open()
            }
        }
    }

    MessageDialog {
        id: remove_all
        title: qsTr("删除")
        text: qsTr("是否清空历史记录?")
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: main_widget.remove_all_history()
    }

    ListView {
        id: listView1
        anchors.top: rectangle3.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom//rectangle1.top
        anchors.left: parent.left
        anchors.topMargin: 0
        model: history_list

        delegate: Item {
            width: rectangle2.width
            height: 220*Math.min(rectangle2.a_max/1280,a_pd/12)
            Rectangle{
                anchors.fill: parent
                anchors.bottomMargin: 3*Math.min(rectangle2.a_max/1280,a_pd/12)
                Text {
                    text: model.modelData.str
                    anchors.fill: parent
                    anchors.bottomMargin: parent.height - 185*Math.min(rectangle2.a_max/1280,a_pd/12)
                    anchors.leftMargin: 15*rectangle2.a_sqrt
                    anchors.rightMargin: 15*rectangle2.a_sqrt
                    verticalAlignment: Text.AlignTop
                    horizontalAlignment: Text.AlignLeft
                    maximumLineCount: (height-font.pixelSize)/(linespaceCheck.contentHeight-font.pixelSize)+1
                    elide: Text.ElideLeft
                    wrapMode: Text.Wrap
                    font.pixelSize: 35*rectangle2.a_sqrt
                    Text {
                        visible: false
                        text: "\n"
                        id: linespaceCheck
                        font.pixelSize: 35*rectangle2.a_sqrt
                    }
                }

                Text {
                    text: model.modelData.search_type[0]+" : "+model.modelData.time
                    verticalAlignment: Text.AlignTop
                    horizontalAlignment: Text.AlignLeft
                    anchors.fill: parent
                    anchors.topMargin: 180*Math.min(rectangle2.a_max/1280,a_pd/12)
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    maximumLineCount: 1
                    elide: Text.ElideLeft
                    wrapMode: Text.Wrap
                    font.pixelSize: 30*rectangle2.a_sqrt
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        main_widget.search_type_clear()
                        main_widget.search_type_add(model.modelData.search_type)
                        main_widget.set_top_bar_height(100*Math.min(rectangle2.a_max/1280,a_pd/12))
                        main_widget.show_search_result(model.modelData.str)
                    }
                }
            }
            Rectangle {
                height: 3*Math.min(rectangle2.a_max/1280,a_pd/12)
                color: "#bbbbbb"
                border.width: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
            }
        }

    }
}

