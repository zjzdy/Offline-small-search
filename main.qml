import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2

Rectangle {
    id: rectangle2
    width: 720
    height: 1280
    //color: "#4681bb"
    color: custom1.bgc
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
        z: 1
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

    Image {
        id: custom_button
        width: 60*rectangle2.width/720
        height: 60*rectangle2.height/1280
        z: 1
        source: "qrc:/image/icon_settings_normal.png"
        anchors.top: parent.top
        anchors.topMargin: 20*rectangle2.height/1280
        anchors.right: parent.right
        anchors.rightMargin: 20*rectangle2.width/720
        opacity: 0.98

        MouseArea {
            anchors.fill: parent
            onClicked: main_widget.show_custom()
        }
    }

    Text {
        id: main_name
        height: 90*rectangle2.height/1280
        color: "#f3e9eded"
        text: qsTr("离线小搜")
        z: 1
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: 230*rectangle2.height/1280
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 90*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
    }

    Image {
        id: bgimage
        z: 0
        anchors.fill: parent
        //source: "qrc:/image/background.png"
        source: custom1.bgi
    }

    Rectangle {
        id: search_all_button
        height: 90*rectangle2.height/1280
        anchors.right: parent.right
        anchors.rightMargin: 20*rectangle2.width/720
        anchors.left: parent.left
        anchors.leftMargin: 20*rectangle2.width/720
        anchors.top: parent.top
        anchors.topMargin: 355*rectangle2.height/1280
        border.width: 0
        color: "#f0f0f0"
        radius: 40*rectangle2.height/1280
        z: 1
        opacity: 0.95

        MouseArea {
            anchors.fill: parent
            onClicked: 
            {
                main_widget.search_type_clear()
                main_widget.search_type_add("ALL")
                main_widget.show_search();
            }
        }

        Image {
            id: image1
            width: 50*rectangle2.width/720
            anchors.left: parent.left
            anchors.leftMargin: 20*rectangle2.width/720
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle2.height/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle2.height/1280
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
            anchors.leftMargin: 5*rectangle2.width/720
            font.pixelSize: 45*rectangle2.height/1280
        }
    }

}

