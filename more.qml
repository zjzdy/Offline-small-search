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
                text: qsTr("更多")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 45*rectangle2.height/1280
            }
        }

        Rectangle {
            id: rectangle4
            height: 200*rectangle2.height/1280
            color: "#00000000"
            border.width: 1
            border.color: "#00000000"
            anchors.top: rectangle3.bottom
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        Rectangle {
            id: rectangle5
            height: 4*rectangle2.height/1280
            color: "#bbbbbb"
            border.width: 0
            border.color: "#00000000"
            anchors.top: rectangle4.bottom
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        Rectangle {
            id: rectangle6
            height: 90*rectangle2.height/1280
            color: "#ffffff"
            border.width: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: rectangle5.bottom
            anchors.topMargin: 0

            Text {
                id: text5
                height: 40*rectangle2.height/1280
                text: qsTr("设置")
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: 100*rectangle2.width/720
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 40*rectangle2.height/1280
            }

            Image {
                id: image1
                anchors.right: text5.left
                anchors.rightMargin: 10*rectangle2.width/720
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.top: parent.top
                anchors.topMargin: 5
                source: "qrc:/image/icon_settings_normal.png"
            }
            
            MouseArea {
                id: mouseArea1
                anchors.fill: parent
                onClicked: main_widget.show_custom()
            }
        }

        Rectangle {
            id: rectangle7
            height: 4*rectangle2.height/1280
            color: "#bbbbbb"
            border.width: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: rectangle6.bottom
            anchors.topMargin: 0
        }

        Rectangle {
            id: rectangle8
            height: 90*rectangle2.height/1280
            color: "#ffffff"
            border.width: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: rectangle7.bottom
            anchors.topMargin: 0

            Text {
                id: text6
                height: 40*rectangle2.height/1280
                text: qsTr("离线包管理")
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: 100*rectangle2.width/720
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 40*rectangle2.height/1280
            }

            Image {
                id: image2
                anchors.right: text6.left
                anchors.rightMargin: 10*rectangle2.width/720
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.top: parent.top
                anchors.topMargin: 5
                source: "qrc:/image/icon_pkg_normal.png"
            }
            
            MouseArea {
                id: mouseArea2
                anchors.fill: parent
                onClicked: main_widget.show_pkg()
            }
        }

        Rectangle {
            id: rectangle9
            height: 4*rectangle2.height/1280
            color: "#bbbbbb"
            border.width: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: rectangle8.bottom
            anchors.topMargin: 0
        }
        Rectangle {
            id: rectangle10
            height: 90*rectangle2.height/1280
            color: "#ffffff"
            border.width: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: rectangle9.bottom
            anchors.topMargin: 0

            Text {
                id: text7
                height: 40*rectangle2.height/1280
                text: qsTr("关于")
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: 100*rectangle2.width/720
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 40*rectangle2.height/1280
            }

            Image {
                id: image3
                anchors.right: text7.left
                anchors.rightMargin: 10*rectangle2.width/720
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.top: parent.top
                anchors.topMargin: 5
                source: "qrc:/image/icon_info_normal.png"
            }
            
            MouseArea {
                id: mouseArea3
                anchors.fill: parent
                onClicked: main_widget.show_about()
            }
        }

        Rectangle {
            id: rectangle11
            height: 4*rectangle2.height/1280
            color: "#bbbbbb"
            border.width: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: rectangle10.bottom
            anchors.topMargin: 0
        }
    }
}

