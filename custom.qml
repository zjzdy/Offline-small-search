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
    property real a_max: Math.max(width,height)
    property real a_min: Math.min(width,height)

    Rectangle {
        id: rectangle3
        height: 100*rectangle2.a_max/1280
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
            font.pixelSize: 45*rectangle2.a_max/1280
        }

        Image {
            id: image1
            width: height
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle2.a_max/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle2.a_max/1280
            source: "qrc:/image/icon_back.png"

            MouseArea {
                id: mouseArea1
                anchors.topMargin: -20*rectangle2.a_max/1280
                anchors.bottomMargin: -20*rectangle2.a_max/1280
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.fill: parent
                onClicked: {
                    main_widget.show_back()
                    custom1.write_custom()
                }
            }
        }
    }

    ColorDialog {
        id: colorDialog
        color: custom1.bgc
        title: qsTr("选择背景颜色")
        onAccepted: {
            custom1.bgc = colorDialog.currentColor
        }
    }

    FileDialog {
        id: choose_bgi
        nameFilters: [ "Image files (*.jpg *.png *.gif *.jpeg *.tiff *.bmp)", "All files (*)" ]
        title: qsTr("选择背景图片")
        selectMultiple: false
        selectExisting: true
        selectFolder: false
        sidebarVisible: false
        onAccepted: {
            custom1.bgi = choose_bgi.fileUrl
        }
        onRejected: rectangle2.focus = true
    }

    Rectangle {
        id: rectangle6
        height: 90*rectangle2.a_max/1280
        color: "#ffffff"
        border.width: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: rectangle3.bottom
        anchors.topMargin: 0

        Text {
            id: text5
            height: 40*rectangle2.a_max/1280
            text: qsTr("设置背景颜色")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.a_min/720
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40*rectangle2.a_max/1280
        }

        MouseArea {
            id: mouseArea10
            anchors.fill: parent
            onClicked: colorDialog.visible = true
        }
    }

    Rectangle {
        id: rectangle7
        height: 4*rectangle2.a_max/1280
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
        height: 90*rectangle2.a_max/1280
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
            height: 40*rectangle2.a_max/1280
            text: qsTr("设置背景图片")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.a_min/720
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40*rectangle2.a_max/1280
        }

        MouseArea {
            id: mouseArea2
            anchors.fill: parent
            onClicked: choose_bgi.visible = true
        }
    }

    Rectangle {
        id: rectangle9
        height: 4*rectangle2.a_max/1280
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
        height: 90*rectangle2.a_max/1280
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
            height: 40*rectangle2.a_max/1280
            text: qsTr("最多保存历史记录")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.a_min/720
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40*rectangle2.a_max/1280
        }

        SpinBox {
            id: history_spinbox
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: text7.right
            anchors.leftMargin: 200*rectangle2.a_min/720
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            value: custom1.max_history
            suffix: "条"
            minimumValue: 0
            maximumValue: 1000
            onEditingFinished: custom1.max_history = value
        }
    }

    Rectangle {
        id: rectangle11
        height: 4*rectangle2.a_max/1280
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
