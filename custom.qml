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

    DefaultFileDialog {
        id: choose_bf_dir2
        folder: "file:///sdcard"
        title: qsTr("选择要保存备份数据的目录")
        selectMultiple: false
        selectExisting: true
        selectFolder: true
        sidebarVisible: false
        onAccepted: {
            main_widget.write_data_file(choose_bf_dir2.folder+"/oss/")
            if(main_widget.is_exist(choose_bf_dir2.folder+"/oss/ossbf",2)) bf_finish.open()
            else bf_fail.open()
        }
        onVisibleChanged: {
            if(!visible)
            {
                rectangle2.parent.parent.forceActiveFocus()
            }
        }
    }

    FileDialog {
        id: choose_bf_dir
        title: qsTr("选择要保存备份数据的目录")
        selectMultiple: false
        selectExisting: true
        selectFolder: true
        sidebarVisible: false
        onAccepted: {
            main_widget.write_data_file(choose_bf_dir.folder+"/oss/")
            if(main_widget.is_exist(choose_bf_dir.folder+"/oss/ossbf",2)) bf_finish.open()
            else bf_fail.open()
        }
    }

    MessageDialog {
        id: bf_finish
        title: qsTr("备份数据完成")
        text: qsTr("备份数据完成")
        standardButtons: StandardButton.Ok
    }

    MessageDialog {
        id: hf_finish
        title: qsTr("恢复数据完成")
        text: qsTr("恢复数据完成")
        standardButtons: StandardButton.Ok
    }

    MessageDialog {
        id: bf_fail
        title: qsTr("备份数据失败")
        text: qsTr("备份数据失败")
        standardButtons: StandardButton.Ok
    }

    MessageDialog {
        id: hf_fail
        title: qsTr("恢复数据失败")
        text: qsTr("恢复数据失败")
        standardButtons: StandardButton.Ok
    }

    DefaultFileDialog {
        id: choose_hf_dir2
        folder: "file:///sdcard"
        title: qsTr("选择保存备份数据的目录")
        selectMultiple: false
        selectExisting: true
        selectFolder: true
        sidebarVisible: false
        onAccepted: {
            if(main_widget.is_exist(choose_hf_dir2.folder+"/oss/ossbf",2))
            {
                main_widget.read_data_file(choose_hf_dir2.folder+"/oss/")
                main_widget.write_data_file()
                main_widget.init_data()
                hf_finish.open()
            }
            else hf_fail.open()
        }
        onVisibleChanged: {
            if(!visible)
            {
                rectangle2.parent.parent.forceActiveFocus()
            }
        }
    }

    FileDialog {
        id: choose_hf_dir
        title: qsTr("选择保存备份数据的目录")
        selectMultiple: false
        selectExisting: true
        selectFolder: true
        sidebarVisible: false
        onAccepted: {
            if(main_widget.is_exist(choose_hf_dir.folder+"/oss/ossbf",2))
            {
                main_widget.read_data_file(choose_hf_dir.folder+"/oss/")
                main_widget.write_data_file()
                main_widget.init_data()
                hf_finish.open()
            }
            else hf_fail.open()
        }
    }

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
            text: qsTr("设置")
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
        onVisibleChanged: {
            if(!visible)
            {
                rectangle2.parent.parent.forceActiveFocus()
            }
        }
    }

    DefaultFileDialog {
        id: choose_bgi2
        folder: "file:///mnt"
        nameFilters: [ "Image files (*.jpg *.png *.gif *.jpeg *.tiff *.bmp)", "All files (*)" ]
        title: qsTr("选择背景图片")
        selectMultiple: false
        selectExisting: true
        selectFolder: false
        sidebarVisible: false
        onAccepted: {
            custom1.bgi = choose_bgi2.fileUrl
        }
        onVisibleChanged: {
            if(!visible)
            {
                rectangle2.parent.parent.forceActiveFocus()
            }
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
        height: 90*Math.min(rectangle2.a_max/1280,a_pd/12)
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
            height: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            text: qsTr("设置背景颜色")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.a_min/720
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
        }

        MouseArea {
            id: mouseArea10
            anchors.fill: parent
            onClicked: colorDialog.visible = true
        }
    }

    Rectangle {
        id: rectangle7
        height: 3*Math.min(rectangle2.a_max/1280,a_pd/12)
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
            text: qsTr("设置背景图片")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.a_min/720
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
        }

        MouseArea {
            id: mouseArea2
            anchors.fill: parent
            onClicked: (Qt.platform.os == "android") ? choose_bgi2.open() : choose_bgi.open()
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
            id: text7
            height: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            text: qsTr("最多保存历史记录")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.a_min/720
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
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
            editable: true
            font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            //suffix: qsTr("条")
            textFromValue: function(value) {
                return Number(value).toString()+qsTr("条")
            }

            valueFromText: function(text) {
                return Number.fromString(String(text).replace(qsTr("条"),""))
            }

            from: 0
            to: 1000
            onValueChanged: {
                if(custom1.max_history != value)
                    custom1.max_history = value
            }
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
            id: text9
            height: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            text: qsTr("备份设置以及程序数据")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.a_min/720
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                (Qt.platform.os == "android") ? choose_bf_dir2.open() : choose_bf_dir.open()
            }
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
            id: text10
            height: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            text: qsTr("恢复设置以及程序数据")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.a_min/720
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                (Qt.platform.os == "android") ? choose_hf_dir2.open() : choose_hf_dir.open()
            }
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
