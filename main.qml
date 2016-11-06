import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

Rectangle {
    id: rectangle2
    width: 720
    height: 1280
    color: custom1.bgc
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

    MessageDialog {
        id: no_pkg_messageDialog
        title: qsTr("请添加离线包")
        text: qsTr("您还没添加离线包呢! 请到\"更多\"界面的下载离线包下载并添加或访问主页获取更多离线包: http://zjzdy.github.io/oss \n是否现在打开 下载离线包 界面?")
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: main_widget.show_online_download()
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
    Image {
        id: custom_button
        width: 60*rectangle2.a_min/720
        height: width
        z: 1
        source: "qrc:/image/icon_settings_normal.png"
        anchors.top: parent.top
        anchors.topMargin: 20*Math.min(rectangle2.a_max/1280,a_pd/12)
        anchors.right: parent.right
        anchors.rightMargin: anchors.topMargin
        opacity: 0.98

        MouseArea {
            anchors.fill: parent
            anchors.margins: -20*rectangle2.a_min/720
            onClicked: main_widget.show_custom()
        }
    }

    Text {
        id: main_name
        height: 90*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#f3e9eded"
        text: qsTr("离线小搜")
        z: 1
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: 230*rectangle2.height/1280
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 90*rectangle2.a_sqrt
    }

    Image {
        id: bgimage
        z: 0
        anchors.fill: parent
        source: custom1.bgi
    }

    Rectangle {
        id: search_all_button
        height: 90*Math.min(rectangle2.a_max/1280,a_pd/12)
        anchors.right: parent.right
        anchors.rightMargin: 20*rectangle2.width/720
        anchors.left: parent.left
        anchors.leftMargin: 20*rectangle2.width/720
        anchors.top: parent.top
        anchors.topMargin: 255*rectangle2.height/1280+80*Math.min(rectangle2.a_max/1280,a_pd/12)
        border.width: 0
        color: "#f0f0f0"
        radius: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
        z: 1
        opacity: 0.95

        MouseArea {
            anchors.fill: parent
            onClicked: {
                main_widget.search_type_clear()
                main_widget.search_type_add("ALL")
                main_widget.set_top_bar_height(100*Math.min(rectangle2.a_max/1280,a_pd/12))
                if(main_widget.more_search_count() < 1)
                    no_pkg_messageDialog.open();
                else
                    main_widget.show_search();
            }
        }

        MouseArea {
            anchors.fill: image2
            enabled: image2.visible
            visible: image2.visible
            anchors.rightMargin: -20*rectangle2.a_min/720
            anchors.leftMargin: -20*rectangle2.a_min/720
            onClicked: {
                main_widget.search_type_clear()
                main_widget.search_type_add("ALL")
                main_widget.set_top_bar_height(100*Math.min(rectangle2.a_max/1280,a_pd/12))
                if(main_widget.more_search_count() < 1)
                    no_pkg_messageDialog.open();
                else {
                    main_widget.search_type_clear()
                    main_widget.search_type_add("ALL")
                    main_widget.startCamera();
                }
            }
        }

        Image {
            id: image1
            width: height
            anchors.left: parent.left
            anchors.leftMargin: 20*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            source: "qrc:/image/icon_search.png"
        }

        Text {
            id: text5
            color: "#c2c9cf"
            text: qsTr("一键搜索")
            styleColor: "#c2c9cf"
            horizontalAlignment: Text.AlignLeft
            style: Text.Normal
            verticalAlignment: Text.AlignVCenter
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: image1.right
            anchors.leftMargin: 5*rectangle2.a_min/720
            font.pixelSize: 45*Math.min(rectangle2.a_max/1280,a_pd/12)
        }

        Image {
            id: image2
            visible: main_widget.is_exist("ocr/zh_cn.zip",1)
            width: height
            anchors.right: parent.right
            anchors.rightMargin: 20*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            source: "qrc:/image/icon_camera.png"
        }

    }

}

