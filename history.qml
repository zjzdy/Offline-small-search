import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2

Rectangle {
    id: rectangle2
    width: 720
    height: 1280
    color: "#f6f6f6"
    focus: true
    Keys.onBackPressed: {
        exit_messageDialog.visible = true
    }
    Keys.onEscapePressed: {
        exit_messageDialog.visible = true
    }

    MessageDialog {
        id: exit_messageDialog
        title: qsTr("退出")
        text: qsTr("您真的要退出吗?")
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: main_widget.close_app()
    }

    Rectangle {
        id: rectangle1
        y: 1175*rectangle2.height/1280
        width: 720*rectangle2.width/720
        height: 105*rectangle2.height/1280
        color: "#f0f0f0"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        Row {
            id: row1
            width: 720*rectangle2.width/720
            height: 105*rectangle2.height/1280

            MouseArea {
                id: button1
                anchors.rightMargin: 540*rectangle2.width/720
                anchors.fill: parent
                onClicked: main_widget.show_main()

                Text {
                    id: text1
                    text: qsTr("一键搜索")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 30*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
                }
            }

            MouseArea {
                id: button2
                anchors.leftMargin: 180*rectangle2.width/720
                anchors.rightMargin: 360*rectangle2.width/720
                anchors.fill: parent
                onClicked: main_widget.show_more_search()

                Text {
                    id: text2
                    text: qsTr("更多搜索")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 30*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
                }
            }

            MouseArea {
                id: button3
                anchors.leftMargin: 360*rectangle2.width/720
                anchors.rightMargin: 180*rectangle2.width/720
                anchors.fill: parent
                onClicked: main_widget.show_history()

                Text {
                    id: text3
                    text: qsTr("历史记录")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 30*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
                }
            }

            MouseArea {
                id: button4
                anchors.leftMargin: 540*rectangle2.width/720
                anchors.fill: parent
                onClicked: main_widget.show_more()

                Text {
                    id: text4
                    text: qsTr("更多")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 30*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
                }
            }
        }
    }

    Rectangle {
        id: rectangle3
        height: 120
        color: "#f0f0f0"
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
            font.pixelSize: 45*rectangle2.height/1280
        }

        Image {
            id: image2
            width: height
            anchors.right: parent.right
            anchors.rightMargin: 20*rectangle2.width/720
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle2.height/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle2.height/1280
            source: "qrc:/image/icon_remove_normal.png"

            MouseArea {
                id: mouseArea2
                anchors.rightMargin: -10*rectangle2.width/720
                anchors.leftMargin: -10*rectangle2.width/720
                anchors.bottomMargin: -20*rectangle2.height/1280
                anchors.topMargin: -20*rectangle2.height/1280
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
        anchors.bottom: rectangle1.top
        anchors.left: parent.left
        anchors.topMargin: 0
        model: history_list

        delegate: Item {
            width: 720*rectangle2.width/720
            height: 220*rectangle2.height/1280
            Rectangle{
                anchors.fill: parent
                anchors.bottomMargin: 3*rectangle2.height/1280
                Text {
                    text: model.modelData.str
                    anchors.fill: parent
                    anchors.bottomMargin: 30*rectangle2.height/1280
                    anchors.leftMargin: 20*rectangle2.width/720
                    anchors.rightMargin: 20*rectangle2.width/720
                    verticalAlignment: Text.AlignTop
                    horizontalAlignment: Text.AlignLeft
                    anchors.verticalCenter: parent.verticalCenter
                    //truncated: true
                    maximumLineCount: 4
                    elide: Text.ElideLeft
                    wrapMode: Text.Wrap
                    font.pixelSize: 35*rectangle2.height/1280
                }

                Text {
                    text: model.modelData.time
                    verticalAlignment: Text.AlignTop
                    horizontalAlignment: Text.AlignLeft
                    anchors.fill: parent
                    anchors.topMargin: 180*rectangle2.height/1280
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    maximumLineCount: 1
                    elide: Text.ElideLeft
                    wrapMode: Text.Wrap
                    font.pixelSize: 30*rectangle2.height/1280
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: main_widget.show_search_result(model.modelData.str)
                }
            }
            Rectangle {
                height: 3*rectangle2.height/1280
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

