import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Rectangle {
    id: rectangle2
    width: 720
    height: 1280
    color: "#f6f6f6"
    property real a_max: Math.max(width,height)
    property real a_min: Math.min(width,height)
    property real a_pd: 0
    property real a_sqrt: Math.min(Math.sqrt(a_max/1280*a_min/720),a_pd/12)

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
            text: qsTr("关于")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 45*Math.min(rectangle2.a_max/1280,a_pd/12)
        }

        Image {
            id: image1
            width: height
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            source: "qrc:/image/icon_back.png"

            MouseArea {
                id: mouseArea1
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.fill: parent
                onClicked: {
                    main_widget.show_back()
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
        anchors.topMargin: 100*rectangle2.height/1280
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        font.pixelSize: 120*rectangle2.a_sqrt
    }

    Text {
        id: text2
        text: qsTr("版本号: ")+main_widget.get_version()
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.top: text1.bottom
        anchors.topMargin: 50*rectangle2.height/1280
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        font.pixelSize: 40*rectangle2.a_sqrt
    }

    Button {
        id: check_update
        anchors.top: text2.bottom
        anchors.topMargin: 30*rectangle2.height/1280
        text: qsTr("检查更新")
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: main_widget.check_update()
    }

    Text {
        id: website_project
        anchors.left: check_update.right
        anchors.leftMargin: 45*rectangle2.width/720
        anchors.bottom: check_update.bottom
        text: qsTr("项目主页")
        font.underline: true
        verticalAlignment: Text.AlignBottom
        color: "#00c4ff"
        MouseArea {
            anchors.fill: parent
            anchors.margins: -30*rectangle2.width/720
            onClicked: main_widget.openUrl("http://git.oschina.net/zjzdy/Offline-small-search")
        }
    }

    Text {
        id: website_official
        anchors.right: check_update.left
        anchors.rightMargin: 60*rectangle2.width/720
        anchors.bottom: check_update.bottom
        text: qsTr("官网")
        font.underline: true
        verticalAlignment: Text.AlignBottom
        color: "#00c4ff"
        MouseArea {
            anchors.fill: parent
            anchors.margins: -30*rectangle2.width/720
            onClicked: main_widget.openUrl("http://zjzdy.oschina.io/oss")
        }
    }
    Flickable {
        id: flickable
        anchors.top: check_update.bottom
        anchors.topMargin: 85*Math.min(rectangle2.a_max/1280,a_pd/12)
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        TextArea.flickable: TextArea {
            anchors.fill: parent
            id: text3
            readOnly: true
            selectByKeyboard: false
            selectByMouse: false
            //backgroundVisible: false
            text: qsTr("声明:所有离线包版权归其所有者所有,与本软件及软件开发人员无关,本软件仅提供搜索功能.\n本软件采用GPL协议发布,希望所有人都能一起来改进本软件.\n项目地址: http://git.oschina.net/zjzdy/Offline-small-search \n如果有问题,建议或bug请\n1.到http://git.oschina.net/zjzdy/Offline-small-search/issues新建一个issues\n2.发送邮件到zjzengdongyang@163.com \n软件主要开发者:\nzjzdy(zjzengdongyang@163.com)\n感谢以下的项目,排名不分先后:\n    Qt: http://www.qt.io/\n    Zimlib: http://www.openzim.org/wiki/Zimlib\n    Xpian: http://xapian.org\n    OpenCV: http://www.opencv.org\n    Tesseract: https://github.com/tesseract-ocr/tesseract\n    OpenCC: https://github.com/BYVoid/OpenCC\n")
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 33*rectangle2.a_sqrt
        }
        //ScrollBar.vertical: ScrollBar { }
  }

}

