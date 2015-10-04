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
        main_widget.offline_pkg_list_to_data_file()
        main_widget.init_search_from_offline_pkg_list()
    }
    Keys.onEscapePressed: {
        main_widget.show_back()
        main_widget.offline_pkg_list_to_data_file()
        main_widget.init_search_from_offline_pkg_list()
    }
    z: 0

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
        z: 1

        Text {
            id: text8
            text: qsTr("离线包管理")
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
                    main_widget.offline_pkg_list_to_data_file()
                    main_widget.init_search_from_offline_pkg_list()
                }
            }
        }

        Image {
            id: image2
            width: height
            anchors.right: parent.right
            anchors.rightMargin: 10*rectangle2.width/720
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle2.height/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle2.height/1280
            source: "qrc:/image/icon_add_normal.png"

            MouseArea {
                id: mouseArea2
                anchors.topMargin: -20*rectangle2.height/1280
                anchors.bottomMargin: -20*rectangle2.height/1280
                anchors.leftMargin: -10*rectangle2.width/720
                anchors.rightMargin: -10*rectangle2.width/720
                anchors.fill: parent
                onClicked: {
                    choose_dir.folder = "/mnt"
                    choose_dir.open()
                    //main_widget.add_offline_pkg(main_widget.get_dir_file_dialog(),true)
                }
            }
        }

        Image {
            id: image3
            width: height
            anchors.right: image2.left
            anchors.rightMargin: 20*rectangle2.width/720
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle2.height/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle2.height/1280
            source: "qrc:/image/icon_remove_normal.png"

            MouseArea {
                id: mouseArea3
                anchors.rightMargin: -10*rectangle2.width/720
                anchors.leftMargin: -10*rectangle2.width/720
                anchors.bottomMargin: -20*rectangle2.height/1280
                anchors.topMargin: -20*rectangle2.height/1280
                anchors.fill: parent
                onClicked: remove_all.open()
            }
        }
    }

    MessageDialog {
        id: remove_all
        title: qsTr("删除")
        text: qsTr("是否从删除列表中全部离线包?")
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: main_widget.remove_all_offline_pkg()
    }

    MessageDialog {
        id: remove_this
        title: qsTr("删除")
        text: qsTr("是否从删除列表中该离线包?")
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            more_info.visible = false
            main_widget.remove_offline_pkg(path_only.text)
        }
    }

    FileDialog {
        id: choose_dir
        title: qsTr("选择离线包的目录")
        selectMultiple: false
        selectExisting: true
        selectFolder: true
        sidebarVisible: false
        onAccepted: {
            main_widget.add_offline_pkg(choose_dir.folder,true)
        }
    }

    Rectangle {
        z: 1
        id: rectangle1
        width: 720*rectangle2.width/720
        height: 60*rectangle2.height/1280
        color: "#ffffff"
        anchors.top: rectangle3.bottom
        anchors.topMargin: 0
        border.width: 0
        Row {
            id: row2
            spacing: 10*rectangle2.width/720
            Text {
                text: qsTr("离线包名称")
                anchors.top: parent.top
                anchors.topMargin: 5*rectangle2.height/1280
                horizontalAlignment: Text.AlignLeft
                width: 450*rectangle2.width/720
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 40*rectangle2.width/720
            }

            Text {
                text: qsTr("启用")
                anchors.top: parent.top
                anchors.topMargin: 5*rectangle2.height/1280
                width: 70*rectangle2.width/720
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 40*rectangle2.width/720
            }

            Text {
                text: qsTr("离线包类型")
                anchors.top: parent.top
                anchors.topMargin: 5*rectangle2.height/1280
                width: 180*rectangle2.width/720
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 40*rectangle2.width/720
            }
        }
    }

    ListView {
        id: listView1
        anchors.top: rectangle1.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 0
        model: offline_pkg_list
        z: 0

        delegate: Item {
            z: -1
            width: 720*rectangle2.width/720
            height: 60*rectangle2.height/1280
                Row {
                    id: row1
                    spacing: 10*rectangle2.width/720
                    Text {
                        text: model.modelData.name
                        width: 450*rectangle2.width/720
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 40*rectangle2.height/1280
                    }

                    Image {
                        source: model.modelData.enable ? "qrc:/image/icon_switch_on.png" : "qrc:/image/icon_switch_off.png"
                        width: 70*rectangle2.width/720
                        height: 40*rectangle2.height/1280
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: main_widget.check_enable_pkg(model.modelData.path)
                        }
                    }

                    Text {
                        text: model.modelData.type
                        width: 180*rectangle2.width/720
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 40*rectangle2.height/1280
                        Button {
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.right: parent.right
                            anchors.rightMargin: 5*rectangle2.width/720
                            text: "●●●"
                            style: ButtonStyle {
                                background: Rectangle {
                                    border.width: 0
                                    color: "#00000000"
                                }
                            }
                            onClicked: {
                                name_only.text = model.modelData.name
                                type_only.text = model.modelData.type
                                count_only.text = model.modelData.count
                                name_code_only.text = model.modelData.name_code
                                path_only.text = model.modelData.path
                                switch2.source = model.modelData.enable ? "qrc:/image/icon_switch_on.png" : "qrc:/image/icon_switch_off.png"
                                more_info.visible = true
                            }
                        }
                    }
                }
            }

    }

    Rectangle {
        z: 2
        id: more_info
        visible:false
        x: 90*rectangle2.width/720
        y: 180*rectangle2.height/1280
        width: 540*rectangle2.width/720
        height: 960*rectangle2.height/1280
        color: "#f6f6f6"
        radius: 10*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
        border.color: "#c1c1be"
        border.width: 5*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
        Button {
            id: button1
            width: 270*rectangle2.width/720
            height: 70*rectangle2.height/1280
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0

            Text {
                id: text1
                text: qsTr("确定")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 55*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
            }
            onClicked: {
                more_info.visible = false
            }
        }

        Button {
            id: button2
            width: 270*rectangle2.width/720
            height: 70*rectangle2.height/1280
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            Text {
                id: text2
                text: qsTr("删除")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 55*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
            }
            onClicked: {
                remove_this.open()
            }
        }

        Text {
            id: name
            text: qsTr("离线包名称:")
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.width/720
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle2.width/720
            font.pixelSize: 35*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
        }

        Text {
            id: name_only
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.width/720
            anchors.right: parent.right
            anchors.top: name.bottom
            anchors.topMargin: 0
            font.pixelSize: 35*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
            wrapMode: Text.Wrap
        }


        Text {
            id: enable
            text: qsTr("启用: ")
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.width/720
            anchors.top: name_only.bottom
            anchors.topMargin: 20*rectangle2.height/1280
            font.pixelSize: 35*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
        }

        Image {
            objectName: "enable_pkg_img"
            id: switch2
            width: 130*rectangle2.width/720
            height: 70*rectangle2.height/1280
            anchors.verticalCenter: enable.verticalCenter
            anchors.left: enable.right
            anchors.leftMargin: 30*rectangle2.width/720
            MouseArea {
                anchors.fill: parent
                onClicked: main_widget.check_enable_pkg(path_only.text)
            }
        }

        Text {
            id: type
            text: qsTr("离线包类型:")
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.width/720
            anchors.right: parent.right
            anchors.top: enable.bottom
            anchors.topMargin: 20*rectangle2.height/1280
            font.pixelSize: 35*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
        }

        Text {
            id: type_only
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.width/720
            anchors.right: parent.right
            anchors.top: type.bottom
            anchors.topMargin: 0
            font.pixelSize: 35*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
            wrapMode: Text.Wrap
        }

        Text {
            id: count
            text: qsTr("离线包索引总数:")
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.width/720
            anchors.right: parent.right
            anchors.top: type_only.bottom
            anchors.topMargin: 20*rectangle2.height/1280
            font.pixelSize: 35*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
        }

        Text {
            id: count_only
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.width/720
            anchors.right: parent.right
            anchors.top: count.bottom
            anchors.topMargin: 0
            font.pixelSize: 35*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
            wrapMode: Text.Wrap
        }

        Text {
            id: name_code
            text: qsTr("离线包内部名称:")
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.width/720
            anchors.right: parent.right
            anchors.top: count_only.bottom
            anchors.topMargin: 20*rectangle2.height/1280
            font.pixelSize: 35*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
        }

        Text {
            id: name_code_only
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.width/720
            anchors.right: parent.right
            anchors.top: name_code.bottom
            anchors.topMargin: 0
            font.pixelSize: 35*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
            wrapMode: Text.Wrap
        }

        Text {
            id: path
            text: qsTr("离线包路径:")
            textFormat: Text.PlainText
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.width/720
            anchors.right: parent.right
            anchors.top: name_code_only.bottom
            anchors.topMargin: 20*rectangle2.height/1280
            font.pixelSize: 35*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
        }

        Text {
            id: path_only
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.width/720
            anchors.right: parent.right
            anchors.top: path.bottom
            anchors.topMargin: 0
            font.pixelSize: 35*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
            wrapMode: Text.Wrap
        }

        Text {
            id: type_info
            text: qsTr("类型说明:\nST:试题包")
            textFormat: Text.PlainText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 5*rectangle2.width/720
            anchors.top: path_only.bottom
            anchors.topMargin: 20*rectangle2.height/1280
            font.pixelSize: 35*Math.sqrt(rectangle2.height/1280*rectangle2.width/720)
            wrapMode: Text.Wrap
        }
    }
}
