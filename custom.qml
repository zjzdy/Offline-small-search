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
        main_widget.show_main()
    }
    Keys.onEscapePressed: {
        main_widget.show_main()
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
            text: qsTr("设置")
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
                    main_widget.show_main()
                }
            }
        }
    }

    ScrollView {
        id: textArea1
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        anchors.top: rectangle3.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 0
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    }
}
