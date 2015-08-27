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
        main_widget.show_more()
    }
    Keys.onEscapePressed: {
        main_widget.show_more()
    }

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
            text: qsTr("关于")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 45*rectangle2.height/1280
        }

        Image {
            id: image1
            width: height
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.width/720
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle2.height/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle2.height/1280
            source: "qrc:/image/icon_back.png"

            MouseArea {
                id: mouseArea1
                anchors.topMargin: -20*rectangle2.height/1280
                anchors.bottomMargin: -20*rectangle2.height/1280
                anchors.leftMargin: -10*rectangle2.width/720
                anchors.rightMargin: -10*rectangle2.width/720
                anchors.fill: parent
                onClicked: {
                    main_widget.show_more()
                }
            }
        }
    }

    Text {
        id: text1
        text: qsTr("离线小搜")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.top: rectangle3.bottom
        anchors.topMargin: 100
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        font.pixelSize: 120*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
    }

    Text {
        id: text2
        text: qsTr("版本号: v1.1.15.8.31")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.top: text1.bottom
        anchors.topMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        font.pixelSize: 40*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
    }

    Text {
        id: text3
        text: qsTr("声明:所有离线包版权归其所有者所有,与本软件及软件开发人员无关.\n本软件采用GPL协议发布,希望所有人都能一起来改进本软件.\n项目地址: http://git.oschina.net/zjzdy/Offline-small-search \n软件主要开发者:\nzjzdy(zjzengdongyang@163.com)\n本程序用到的库:\nQt:qt.io(GPL)\nCppJieba:(LGPL)\nLucene++:(LGPL)\nzimlib:(GPL)")
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignLeft
        anchors.top: text2.bottom
        anchors.topMargin: 100
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        font.pixelSize: 35*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
    }
}

