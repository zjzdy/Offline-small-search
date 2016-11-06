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
    z: 0

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
        z: 1

        Text {
            id: text8
            text: qsTr("离线包管理")
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
                    main_widget.offline_pkg_list_to_data_file()
                    main_widget.init_search_from_offline_pkg_list()
                }
            }
        }

        Image {
            id: image2
            width: height
            anchors.right: parent.right
            anchors.rightMargin: 10*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            source: "qrc:/image/icon_add_normal.png"

            MouseArea {
                id: mouseArea2
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.fill: parent
                onClicked: {
                    (Qt.platform.os == "android") ? choose_dir2.open() : choose_dir.open()
                }
            }
        }

        Image {
            id: image3
            width: height
            anchors.right: image2.left
            anchors.rightMargin: 20*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            source: "qrc:/image/icon_remove_normal.png"

            MouseArea {
                id: mouseArea3
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.leftMargin: -10*rectangle2.a_min/720
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
            more_info_dialog.close()
            main_widget.remove_offline_pkg(path_only.text)
        }
    }

    DefaultFileDialog {
        id: choose_dir2
        title: qsTr("选择离线包的pkg文件或插件包的oplu文件")
        selectMultiple: false
        selectExisting: true
        //selectFolder: true
        folder: "file:///sdcard"
        nameFilters: [ "离线包和插件包 (*.idx *.zim *.pkg *.oplu)" ,"离线包 (*.idx *.zim *.pkg)" ,"插件包 (*.oplu)" ,"All files (*)"]
        onFolderChanged: console.log(choose_dir2.folder)
        onAccepted: {
            if(choose_dir2.fileUrl.toString().search(/oplu$/i) > 0)
            {
                var opluState = main_widget.checkOplu(choose_dir2.fileUrl);
                if(opluState < 0)
                {
                    switch (opluState)
                    {
                    case -1:
                      pluginError.text = qsTr("插件包文件不存在或无法打开")
                      break;
                    case -2:
                      pluginError.text = qsTr("这不是一个插件包文件")
                      break;
                    case -3:
                      pluginError.text = qsTr("不支持该版本的插件")
                      break;
                    case -4:
                      pluginError.text = qsTr("当前离线小搜版本过低,请升级到最新版本")
                      break;
                    default:
                      pluginError.text = qsTr("检查插件包时发生未知错误")
                    }
                    pluginError.open()
                }
                else
                {
                    pluginWarn.fileUrl = choose_dir2.fileUrl;
                    switch (opluState)
                    {
                    case 0:
                      pluginWarn.text = qsTr("插件包签名效验失败,插件包可能被篡改、受到破坏或者插件包的签名不受信任.您将要安装的插件可能不安全,如果选择安装,则由您承担所有风险和后果(包括但不限于一切经济、道德和法律责任及其连带责任),请问是否确认安装?")
                      break;
                    case 1:
                      pluginWarn.text = qsTr("插件包数据MD5效验失败,且该插件包并未签名,插件包可能被篡改或者受到破坏.您将要安装的插件极可能不安全,如果选择安装,则由您承担所有风险和后果(包括但不限于一切经济、道德和法律责任及其连带责任),请问是否确认安装?")
                      break;
                    case 2:
                      pluginWarn.text = qsTr("插件包数据MD5效验通过,但该插件包未进行签名,插件包可能被篡改且来源未知.您将要安装的插件可能不安全,如果选择安装,则由您承担所有风险和后果(包括但不限于一切经济、道德和法律责任及其连带责任),请问是否确认安装?")
                      break;
                    case 5:
                      pluginWarn.text = qsTr("插件包签名效验成功,该插件经过一定检查,但仍不保证完全安全,如果选择安装,则由您承担所有风险和后果,请问是否确认安装?")
                      break;
                    default:
                      pluginWarn.text = qsTr("您将要安装的插件可能不安全,如果选择安装,则由您承担所有风险和后果,请问是否确认安装?")
                    }
                    pluginWarn.open()
                }
            }
            else
                main_widget.add_offline_pkg(choose_dir2.folder,true)
        }
        onVisibleChanged: {
            if(!visible)
            {
                rectangle2.parent.parent.forceActiveFocus()
            }
        }
    }

    FileDialog {
        id: choose_dir
        title: qsTr("选择离线包的pkg文件或插件包的oplu文件")
        selectMultiple: false
        selectExisting: true
        //selectFolder: true
        sidebarVisible: false
        nameFilters: [ "离线包和插件包 (*.idx *.zim *.pkg *.oplu)" ,"离线包 (*.idx *.zim *.pkg)" ,"插件包 (*.oplu)" ,"All files (*)"]
        onAccepted: {
            if(choose_dir.fileUrl.search(/oplu$/g) > 0)
            {
                var opluState = main_widget.checkOplu(choose_dir.fileUrl);
                if(opluState < 0)
                {
                    switch (opluState)
                    {
                    case -1:
                      pluginError.text = qsTr("插件包文件不存在或无法打开")
                      break;
                    case -2:
                      pluginError.text = qsTr("这不是一个插件包文件")
                      break;
                    case -3:
                      pluginError.text = qsTr("不支持该版本的插件")
                      break;
                    case -4:
                      pluginError.text = qsTr("当前离线小搜版本过低,请升级到最新版本")
                      break;
                    default:
                      pluginError.text = qsTr("检查插件包时发生未知错误")
                    }
                    pluginError.open()
                }
                else
                {
                    pluginWarn.fileUrl = choose_dir.fileUrl;
                    switch (opluState)
                    {
                    case 0:
                      pluginWarn.text = qsTr("插件包签名效验失败,插件包可能被篡改、受到破坏或者插件包的签名不受信任.您将要安装的插件可能不安全,如果选择安装,则由您承担所有风险和后果(包括但不限于一切经济、道德和法律责任及其连带责任),请问是否确认安装?")
                      break;
                    case 1:
                      pluginWarn.text = qsTr("插件包数据MD5效验失败,且该插件包并未签名,插件包可能被篡改或者受到破坏.您将要安装的插件极可能不安全,如果选择安装,则由您承担所有风险和后果(包括但不限于一切经济、道德和法律责任及其连带责任),请问是否确认安装?")
                      break;
                    case 2:
                      pluginWarn.text = qsTr("插件包数据MD5效验通过,但该插件包未进行签名,插件包可能被篡改且来源未知.您将要安装的插件可能不安全,如果选择安装,则由您承担所有风险和后果(包括但不限于一切经济、道德和法律责任及其连带责任),请问是否确认安装?")
                      break;
                    case 5:
                      pluginWarn.text = qsTr("插件包签名效验成功,该插件经过一定检查,但仍不保证完全安全,如果选择安装,则由您承担所有风险和后果,请问是否确认安装?")
                      break;
                    default:
                      pluginWarn.text = qsTr("您将要安装的插件可能不安全,如果选择安装,则由您承担所有风险和后果,请问是否确认安装?")
                    }
                    pluginWarn.open()
                }
            }
            else
                main_widget.add_offline_pkg(choose_dir.folder,true)
        }
    }

    MessageDialog {
        id: pluginError
        text: qsTr("您将要安装的插件发生错误")
        standardButtons: StandardButton.Ok
    }

    MessageDialog {
        id: pluginWarn
        property string fileUrl: ""
        text: qsTr("您将要安装的插件可能不安全,如果选择安装,则由您承担所有风险和后果,请问是否确认安装?")
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            pluginWarn.close()
            main_widget.installPlugins(pluginWarn.fileUrl)
        }
    }

    Rectangle {
        z: 1
        id: rectangle1
        width: rectangle2.width
        height: 60*Math.min(rectangle2.a_max/1280,a_pd/12)
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
                anchors.topMargin: 5*Math.min(rectangle2.a_max/1280,a_pd/12)
                horizontalAlignment: Text.AlignLeft
                width: 450*rectangle2.width/720
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            }

            Text {
                text: qsTr("启用")
                anchors.top: parent.top
                anchors.topMargin: 5*Math.min(rectangle2.a_max/1280,a_pd/12)
                width: 70*rectangle2.width/720
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            }

            Text {
                text: qsTr(" 更多信息")
                anchors.top: parent.top
                anchors.topMargin: 5*Math.min(rectangle2.a_max/1280,a_pd/12)
                width: 180*rectangle2.width/720
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            }
        }
    }

    ListView {
        id: listView1
        anchors.top: rectangle1.bottom
        anchors.right: parent.right
        anchors.bottom: auto_check_tip.top
        anchors.left: parent.left
        anchors.topMargin: 0
        model: offline_pkg_list
        z: 0

        delegate: Item {
            z: -1
            width: rectangle2.width
            height: 60*Math.min(rectangle2.a_max/1280,a_pd/12)
                Row {
                    id: row1
                    spacing: 10*rectangle2.width/720
                    Text {
                        text: model.modelData.name
                        width: 450*rectangle2.width/720
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
                    }

                    Image {
                        source: model.modelData.enable ? "qrc:/image/icon_switch_on.png" : "qrc:/image/icon_switch_off.png"
                        width: height*2
                        height: 35*Math.min(rectangle2.a_max/1280,a_pd/12)
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                rectangle2.focus = true
                                main_widget.check_enable_pkg(model.modelData.path)
                            }
                        }
                    }

                    Button {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 180*rectangle2.width/720
                        text: "●●●"
                        background: Rectangle {
                            color: "#00000000"
                        }

                        onClicked: {
                            name_only.text = model.modelData.name
                            type_only.text = model.modelData.type
                            count_only.text = model.modelData.count
                            name_code_only.text = model.modelData.name_code
                            path_only.text = model.modelData.path
                            switch2.source = model.modelData.enable ? "qrc:/image/icon_switch_on.png" : "qrc:/image/icon_switch_off.png"
                            //more_info.visible = true
                            more_info_dialog.open()
                            rectangle2.focus = true
                        }
                    }
                }
            }

    }

    Dialog {
        id: more_info_dialog
        title: qsTr("离线包详细信息")
        visible: false
        contentItem: Rectangle {
            id: more_info
            visible: more_info_dialog.visible
            implicitWidth: 540*rectangle2.width/720
            implicitHeight: 1100*rectangle2.height/1280
            parent: rectangle2
            onVisibleChanged: {
                if(!visible)
                {
                    rectangle2.parent.parent.forceActiveFocus()
                }
            }
            Keys.onBackPressed: {
                more_info_dialog.close()
                rectangle2.focus = true
            }
            Keys.onEscapePressed: {
                more_info_dialog.close()
                rectangle2.focus = true
            }

            Button {
                id: button1
                width: 270*rectangle2.width/720
                height: 70*Math.min(rectangle2.a_max/1280,a_pd/12)
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                z: 3

                Text {
                    id: text1
                    text: qsTr("确定")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 55*rectangle2.a_sqrt
                }
                onClicked: {
                    more_info_dialog.close()
                    rectangle2.focus = true
                }
            }

            Button {
                id: button2
                width: 270*rectangle2.width/720
                height: 70*Math.min(rectangle2.a_max/1280,a_pd/12)
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                z: 3

                Text {
                    id: text2
                    text: qsTr("删除")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 55*rectangle2.a_sqrt
                }
                onClicked: {
                    remove_this.open()
                }
            }

            Text {
                id: name
                text: qsTr("离线包名称:")
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 20*rectangle2.a_min/720
                font.pixelSize: 35*rectangle2.a_sqrt
            }

            Text {
                id: name_only
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.right: parent.right
                anchors.top: name.bottom
                anchors.topMargin: 0
                font.pixelSize: 35*rectangle2.a_sqrt
                wrapMode: Text.Wrap
            }


            Text {
                id: enable
                text: qsTr("启用: ")
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.top: name_only.bottom
                anchors.topMargin: 20*Math.min(rectangle2.a_max/1280,a_pd/12)
                font.pixelSize: 35*rectangle2.a_sqrt
            }

            Image {
                objectName: "enable_pkg_img"
                id: switch2
                width: height*2
                height: 70*Math.min(rectangle2.a_max/1280,a_pd/12)
                anchors.verticalCenter: enable.verticalCenter
                anchors.left: enable.right
                anchors.leftMargin: 30*rectangle2.a_min/720
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        rectangle2.focus = true
                        main_widget.check_enable_pkg(path_only.text)
                    }
                }
            }

            Text {
                id: type
                text: qsTr("离线包类型:")
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.right: parent.right
                anchors.top: enable.bottom
                anchors.topMargin: 20*Math.min(rectangle2.a_max/1280,a_pd/12)
                font.pixelSize: 35*rectangle2.a_sqrt
            }

            Text {
                id: type_only
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.right: parent.right
                anchors.top: type.bottom
                anchors.topMargin: 0
                font.pixelSize: 35*rectangle2.a_sqrt
                wrapMode: Text.Wrap
            }

            Text {
                id: count
                text: qsTr("离线包索引总数:")
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.right: parent.right
                anchors.top: type_only.bottom
                anchors.topMargin: 20*Math.min(rectangle2.a_max/1280,a_pd/12)
                font.pixelSize: 35*rectangle2.a_sqrt
            }

            Text {
                id: count_only
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.right: parent.right
                anchors.top: count.bottom
                anchors.topMargin: 0
                font.pixelSize: 35*rectangle2.a_sqrt
                wrapMode: Text.Wrap
            }

            Text {
                id: name_code
                text: qsTr("离线包标识码:")
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.right: parent.right
                anchors.top: count_only.bottom
                anchors.topMargin: 20*Math.min(rectangle2.a_max/1280,a_pd/12)
                font.pixelSize: 35*rectangle2.a_sqrt
            }

            Text {
                id: name_code_only
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.right: parent.right
                anchors.top: name_code.bottom
                anchors.topMargin: 0
                font.pixelSize: 35*rectangle2.a_sqrt
                wrapMode: Text.Wrap
            }

            Text {
                id: path
                text: qsTr("离线包路径:")
                textFormat: Text.PlainText
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720+(rectangle2.height > rectangle2.width ? 0 : 270*rectangle2.width/720)
                anchors.right: parent.right
                anchors.top: rectangle2.height > rectangle2.width ? name_code_only.bottom : parent.top
                anchors.topMargin: 20*Math.min(rectangle2.a_max/1280,a_pd/12)
                font.pixelSize: 35*rectangle2.a_sqrt
            }

            Text {
                id: path_only
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720+(rectangle2.height > rectangle2.width ? 0 : 270*rectangle2.width/720)
                anchors.right: parent.right
                anchors.top: path.bottom
                anchors.topMargin: 0
                font.pixelSize: 35*rectangle2.a_sqrt
                wrapMode: Text.Wrap
            }

            Text {
                id: type_info
                text: qsTr("类型说明:\nST:试题包\nGSW:古诗文\nMod:功能模块\nDevDoc:开发文档,开发者文档\nUserDoc:使用文档,用户文档\nZL:资料\nOther:其他")
                textFormat: Text.PlainText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5*rectangle2.a_min/720+(rectangle2.height > rectangle2.width ? 0 : 270*rectangle2.width/720)
                anchors.top: path_only.bottom
                anchors.topMargin: 20*Math.min(rectangle2.a_max/1280,a_pd/12)
                font.pixelSize: 35*rectangle2.a_sqrt
                wrapMode: Text.Wrap
            }
        }
    }

    Text {
        id: auto_check_tip
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("提示: 把离线包放在")+main_widget.get_data_dir()+qsTr("目录中可以自动扫描添加")
        font.pixelSize: 33*Math.min(rectangle2.a_max/1280,a_pd/12)
        elide: Text.ElideLeft
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.AlignHCenter
        MouseArea {
            anchors.fill: parent
            onClicked: main_widget.check_data_pkgs()
        }
    }
}
