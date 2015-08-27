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

    Column {
        id: column1
        anchors.bottom: rectangle1.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottomMargin: 0

        Rectangle {
            id: rectangle3
            height: 120*rectangle2.height/1280
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
        }

        Text {
            id: text5
            text: qsTr("敬请期待")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 150*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
        }
    }
}

