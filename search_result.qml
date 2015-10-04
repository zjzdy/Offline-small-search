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
        main_widget.show_back()
    }
    Keys.onEscapePressed: {
        main_widget.show_back()
    }
    z: 0

    Rectangle {
        z: 1
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
            text: qsTr("搜索结果")
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
                    main_widget.show_back()
                }
            }
        }
    }

    ListView {
        id: listView1
        anchors.top: rectangle3.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 0
        model: search_result_obj
        z: 0

        delegate: Item {
            z: -1
            width: 720*rectangle2.width/720
            height: 200*rectangle2.height/1280
            Rectangle{
                anchors.fill: parent
                anchors.bottomMargin: 3*rectangle2.height/1280
                Text {
                    text: model.modelData.str
                    anchors.fill: parent
                    anchors.leftMargin: 30*rectangle2.width/720
                    anchors.rightMargin: 15*rectangle2.width/720
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    maximumLineCount: 4
                    elide: Text.ElideLeft
                    wrapMode: Text.Wrap
                    font.pixelSize: 35*rectangle2.height/1280
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: main_widget.show_result(model.modelData.url)
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

    AnimatedImage {
        id: image2
        z: 1
        objectName: "wait_image"
        width: 200*rectangle2.width/720
        height: 156*rectangle2.height/1280
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/image/icon_wait.gif"
        visible: false
    }
}
