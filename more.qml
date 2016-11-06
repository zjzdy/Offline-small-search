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
            font.pixelSize: 45*Math.min(rectangle2.a_max/1280,a_pd/12)
        }

        Item {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            width: exit_image.width+exit_text.width+20*rectangle2.a_min/720
            Image {
                id: exit_image
                width: height
                anchors.right: parent.right
                anchors.rightMargin: 10*rectangle2.a_min/720
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                source: "qrc:/image/icon_exit.png"
            }

            Text {
                id: exit_text
                text: qsTr("退出")
                verticalAlignment: Text.AlignVCenter
                //anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 35*Math.min(rectangle2.a_max/1280,a_pd/12)
                anchors.right: exit_image.left
                anchors.rightMargin: 10*rectangle2.a_min/720
                anchors.bottom: parent.bottom
                anchors.top: parent.top
            }

            MouseArea {
                id: exit_mouseArea
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.fill: parent
                onClicked: exit_messageDialog.open()
            }
        }
    }

    Rectangle {
        id: rectangle4
        height: rectangle2.height > rectangle2.width ? 200*rectangle2.height/1280 : 0
        color: "#00000000"
        border.width: 1
        border.color: "#00000000"
        anchors.top: rectangle3.bottom
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        Text {
            id: text
            text: qsTr("离线小搜")
            visible: (parent.height > 1) && (parent.visible == true)
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: image.right
            anchors.leftMargin: 0
            font.pixelSize: 130*rectangle2.a_sqrt
        }
        Image {
            id: image
            visible: (parent.height > 1) && (parent.visible == true)
            source: "qrc:/image/logo2.png"
            width: height
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 25*rectangle2.height/1280
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle2.height/1280
        }
    }

    Rectangle {
        id: rectangle5
        height: 4*Math.min(rectangle2.a_max/1280,a_pd/12)
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
        height: 90*Math.min(rectangle2.a_max/1280,a_pd/12)
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
            height: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            text: qsTr("设置")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 100*Math.min(rectangle2.a_max/1280,a_pd/12)
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
        }

        Image {
            id: image1
            anchors.right: text5.left
            anchors.rightMargin: 10*a_pd/12
            anchors.left: parent.left
            anchors.leftMargin: 10*a_pd/12
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5*a_pd/12
            anchors.top: parent.top
            anchors.topMargin: 5*a_pd/12
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
        height: 4*Math.min(rectangle2.a_max/1280,a_pd/12)
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
        height: 90*Math.min(rectangle2.a_max/1280,a_pd/12)
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
            height: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            text: qsTr("离线包管理")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 100*Math.min(rectangle2.a_max/1280,a_pd/12)
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
        }

        Image {
            id: image2
            anchors.right: text6.left
            anchors.rightMargin: 10*a_pd/12
            anchors.left: parent.left
            anchors.leftMargin: 10*a_pd/12
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5*a_pd/12
            anchors.top: parent.top
            anchors.topMargin: 5*a_pd/12
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
        height: 4*Math.min(rectangle2.a_max/1280,a_pd/12)
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
        height: 90*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#ffffff"
        border.width: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: rectangle9.bottom
        anchors.topMargin: 0

        Text {
            id: text9
            height: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            text: qsTr("收藏夹")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 100*Math.min(rectangle2.a_max/1280,a_pd/12)
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
        }

        Image {
            id: image3
            anchors.right: text9.left
            anchors.rightMargin: 10*a_pd/12
            anchors.left: parent.left
            anchors.leftMargin: 10*a_pd/12
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5*a_pd/12
            anchors.top: parent.top
            anchors.topMargin: 5*a_pd/12
            source: "qrc:/image/icon_marks.png"
        }

        MouseArea {
            id: mouseArea3
            anchors.fill: parent
            onClicked: main_widget.show_mark()
        }
    }

    Rectangle {
        id: rectangle11
        height: 4*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#bbbbbb"
        border.width: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: rectangle10.bottom
        anchors.topMargin: 0
    }

    Rectangle {
        id: rectangle12
        height: 90*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#ffffff"
        border.width: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: rectangle11.bottom
        anchors.topMargin: 0

        Text {
            id: text10
            height: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            text: qsTr("下载离线包")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 100*Math.min(rectangle2.a_max/1280,a_pd/12)
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
        }

        Image {
            id: image4
            anchors.right: text10.left
            anchors.rightMargin: 10*a_pd/12
            anchors.left: parent.left
            anchors.leftMargin: 10*a_pd/12
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5*a_pd/12
            anchors.top: parent.top
            anchors.topMargin: 5*a_pd/12
            source: "qrc:/image/icon_download.png"
        }

        MouseArea {
            id: mouseArea4
            anchors.fill: parent
            onClicked: main_widget.show_online_download()
        }
    }

    Rectangle {
        id: rectangle13
        height: 4*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#bbbbbb"
        border.width: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: rectangle12.bottom
        anchors.topMargin: 0
    }

    Rectangle {
        id: rectangle14
        height: 90*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#ffffff"
        border.width: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: rectangle13.bottom
        anchors.topMargin: 0

        Text {
            id: text7
            height: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            text: qsTr("关于")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 100*Math.min(rectangle2.a_max/1280,a_pd/12)
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
        }

        Image {
            id: image5
            anchors.right: text7.left
            anchors.rightMargin: 10*a_pd/12
            anchors.left: parent.left
            anchors.leftMargin: 10*a_pd/12
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5*a_pd/12
            anchors.top: parent.top
            anchors.topMargin: 5*a_pd/12
            source: "qrc:/image/icon_info_normal.png"
        }

        MouseArea {
            id: mouseArea5
            anchors.fill: parent
            onClicked: main_widget.show_about()
        }
    }

    Rectangle {
        id: rectangle15
        height: 4*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#bbbbbb"
        border.width: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: rectangle14.bottom
        anchors.topMargin: 0
    }
}

