import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.XmlListModel 2.0
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

    MessageDialog {
        id: remove_sure
        property string name: ""
        property string url: ""
        property var image2: null
        text: qsTr("您确定要删除:")+name+qsTr(" 吗?\n在这里删除将会彻底删除离线包的所有文件!")
        standardButtons: StandardButton.No | StandardButton.Yes
        onYes: {
            image2.visible = true
            main_widget.obj_list_insert(url,image2)
            main_widget.remove_data(url);
        }
    }

    MessageDialog {
        id: download_readme_dialog
        property string name: ""
        property string url: ""
        property string readme: ""
        property bool open_url: false
        property var image2: null
        text: qsTr("您将要下载:")+name+qsTr(" \n下载说明:\n")+readme
        standardButtons: StandardButton.No | StandardButton.Yes
        onYes: {
            if(!open_url) image2.visible = true
            main_widget.obj_list_insert(url,image2)
            open_url ? main_widget.openUrl(url) : main_widget.download_data(url);
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
        z: 1

        Text {
            id: text8
            text: qsTr("下载离线包")
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
                text: qsTr("大小")
                anchors.top: parent.top
                anchors.topMargin: 5*Math.min(rectangle2.a_max/1280,a_pd/12)
                width: 180*rectangle2.width/720
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
            }
        }
    }

    XmlListModel {
        id: online_xml
        source: "https://zjzdy.oschina.io/oss/online3.xml"
        query: "//pkg[@type='pkg']"

        XmlRole {
            name: "open_url"
            query: "open_url/string()='true'"
        }
        XmlRole {
            name: "download"
            query: "download/string()"
        }
        XmlRole {
            name: "download_readme"
            query: "download_readme/string()"
        }
        XmlRole {
            name: "category"
            query: "category/string()"
        }
        XmlRole {
            name: "name"
            query: "name/string()"
        }
        XmlRole {
            name: "count"
            query: "count/string()"
        }
        XmlRole {
            name: "name_code"
            query: "name_code/string()"
        }
        XmlRole {
            name: "update_code"
            query: "update_code/string()"
        }
        XmlRole {
            name: "version"
            query: "version/number()"
        }
        XmlRole {
            name: "zip_size"
            query: "zip_size/string()"
        }
        XmlRole {
            name: "pkg_size"
            query: "pkg_size/string()"
        }
        XmlRole {
            name: "publisher"
            query: "publisher/string()"
        }
        XmlRole {
            name: "md5"
            query: "md5/string()"
        }
        XmlRole {
            name: "type"
            query: "type/string()"
        }
        XmlRole {
            name: "source"
            query: "source/string()"
        }
        XmlRole {
            name: "time"
            query: "time/string()"
        }
        XmlRole {
            name: "PluginType"
            query: "PluginType/string()"
        }
    }

    Item {
        visible: listView1.count < 1
        anchors.top: rectangle3.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        z: 1
        AnimatedImage {
            id: wait_img2
            anchors.centerIn: parent
            //height: rectangle2.a_min/2
            width: rectangle2.a_min/2
            source: "qrc:/image/icon_wait3.gif"
            visible: parent.visible
            fillMode: Image.PreserveAspectFit
        }

        Text {
            visible: parent.visible
            text: qsTr("正在获取离线包列表")
            anchors.top: wait_img2.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 45*Math.min(rectangle2.a_max/1280,a_pd/12)
        }
    }

    ListView {
        id: listView1
        anchors.top: rectangle1.bottom
        anchors.right: parent.right
        anchors.bottom: more_tip.top
        anchors.left: parent.left
        anchors.topMargin: 0
        model: online_xml
        z: 0

        delegate: Item {
            //z: -1
            width: rectangle2.width
            height: Math.max(name_t.height,zip_size_t.height)+25*Math.min(rectangle2.a_max/1280,a_pd/12)
            Rectangle {
                anchors.bottom: parent.bottom
                color: "#c0baba"
                width: parent.width
                height: 4*Math.min(rectangle2.a_max/1280,a_pd/12)
            }

            Text {
                id: name_t
                anchors.left: parent.left
                anchors.top: parent.top
                //anchors.bottom: parent.bottom
                text: name
                width: 450*rectangle2.width/720
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
                //anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 45*Math.min(rectangle2.a_max/1280,a_pd/12)
            }

            Text {
                id: zip_size_t
                anchors.left: name_t.right
                anchors.top: parent.top
                //anchors.bottom: parent.bottom
                text: zip_size
                width: 150*rectangle2.width/720
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
                //anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 45*Math.min(rectangle2.a_max/1280,a_pd/12)
            }
            MouseArea {
                anchors.left: name_t.left
                anchors.right: zip_size_t.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                onClicked: {
                    name_only.text = name
                    type_only.text = type
                    name_code_only.text = name_code
                    path_only.text = download
                    //more_info.visible = true
                    more_info_dialog.open()
                    rectangle2.focus = true
                }
            }
            Item {
                anchors.left: zip_size_t.right
                anchors.right: parent.right
                height: 80*Math.min(rectangle2.a_max/1280,a_pd/12)
                anchors.verticalCenter: parent.verticalCenter

                AnimatedImage {
                    id: image2
                    z: 1
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.topMargin: 15*Math.min(rectangle2.a_max/1280,a_pd/12)
                    anchors.bottomMargin: 15*Math.min(rectangle2.a_max/1280,a_pd/12)
                    width: (text2.contentWidth > parent.width-height) ? 0: height
                    source: "qrc:/image/icon_wait2.gif"
                    visible: false
                    fillMode: Image.PreserveAspectFit
                    onVisibleChanged: {
                        xz_text.text = ""
                        xz_text.text = (main_widget.is_exist(download,1)||main_widget.is_exist(name_code,1)) ? qsTr("删除") : qsTr("下载")
                        progress = ""
                    }
                    property string progress: ""
                }

                /*
                ProgressBar {
                    id: progress
                    from: 0
                    to: 100
                    height: parent.height
                    visible: image2.visible
                    value: Number(image2.progress)
                    anchors.fill: parent
                    anchors.topMargin: 15*Math.min(rectangle2.a_max/1280,a_pd/12)
                    anchors.bottomMargin: 15*Math.min(rectangle2.a_max/1280,a_pd/12)
                    contentItem: Item {
                        implicitWidth: background.implicitWidth
                        implicitHeight: background.implicitHeight

                        Rectangle {
                            width: progress.visualPosition * background.width
                            height: progress.height
                            radius: 2
                            color: "#17a81a"
                            Text {
                                visible: progress.visible
                                text: image2.progress
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                //font.pixelSize: 45*rectangle2.a_sqrt
                            }
                        }
                    }
                }
                */

                Text {
                    id: text2
                    visible: image2.visible
                    text: image2.progress
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: image2.right
                    anchors.right: parent.right
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 45*rectangle2.a_sqrt
                }

                Button {
                    id: xz
                    visible: !image2.visible
                    enabled: visible
                    anchors.fill: parent
                    anchors.margins: 5*Math.min(rectangle2.a_max/1280,a_pd/12)
                    /*
                    radius: 15*Math.min(rectangle2.a_max/1280,a_pd/12)
                    color: "white"
                    border.color: "black"
                    border.width: 5*Math.min(rectangle2.a_max/1280,a_pd/12)
                    */
                    contentItem: Text {
                        id: xz_text
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 45*rectangle2.a_sqrt
                        text: (main_widget.is_exist(download,1)||main_widget.is_exist(name_code,1)) ? qsTr("删除") : qsTr("下载")
                    }
                    onClicked: {
                        if(main_widget.is_exist(download,1)||main_widget.is_exist(name_code,1))
                        {
                            remove_sure.url = download
                            remove_sure.name = name
                            remove_sure.image2 = image2
                            remove_sure.open()
                        }
                        else
                        {
                            if(download_readme == null||download_readme == "")
                            {
                                if(!open_url) image2.visible = true
                                main_widget.obj_list_insert(download,image2)
                                open_url ? main_widget.openUrl(download) : main_widget.download_data(download)
                            }
                            else
                            {
                                //console.log(url_type,download_readme)
                                download_readme_dialog.url = download
                                download_readme_dialog.name = name
                                download_readme_dialog.readme = download_readme
                                download_readme_dialog.open_url = open_url
                                download_readme_dialog.image2 = image2
                                download_readme_dialog.open()
                            }
                        }
                    }
                }
            }
        }
    }

    Text {
        id: more_tip
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("更多离线请访问主页: \n http://zjzdy.oschina.io/oss")
        font.pixelSize: 40*Math.min(rectangle2.a_max/1280,a_pd/12)
        elide: Text.ElideLeft
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.AlignHCenter
        z: 3
        MouseArea {
            anchors.fill: parent
            onClicked: main_widget.openUrl("http://zjzdy.oschina.io/oss")
        }
    }

    Rectangle {
        anchors.fill: more_tip
        color: "white"
        z: 1

    }

    Dialog {
        id: more_info_dialog
        title: qsTr("离线包详细信息")
        visible: false
        contentItem: Rectangle {
            z: 2
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
                height: 70*Math.min(rectangle2.a_max/1280,a_pd/12)
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
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

            Text {
                id: name2
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
                anchors.top: name2.bottom
                anchors.topMargin: 0
                font.pixelSize: 35*rectangle2.a_sqrt
                wrapMode: Text.Wrap
            }

            Text {
                id: type
                text: qsTr("离线包类型:")
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.right: parent.right
                anchors.top: name_only.bottom
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
                id: name_code_t
                text: qsTr("离线包标识码:")
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.right: parent.right
                anchors.top: type_only.bottom
                anchors.topMargin: 20*Math.min(rectangle2.a_max/1280,a_pd/12)
                font.pixelSize: 35*rectangle2.a_sqrt
            }

            Text {
                id: name_code_only
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.right: parent.right
                anchors.top: name_code_t.bottom
                anchors.topMargin: 0
                font.pixelSize: 35*rectangle2.a_sqrt
                wrapMode: Text.Wrap
            }

            Text {
                id: path
                text: qsTr("离线包下载地址:")
                textFormat: Text.PlainText
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.right: parent.right
                anchors.top: name_code_only.bottom
                anchors.topMargin: 20*Math.min(rectangle2.a_max/1280,a_pd/12)
                font.pixelSize: 35*rectangle2.a_sqrt
            }

            Text {
                id: path_only
                anchors.left: parent.left
                anchors.leftMargin: 5*rectangle2.a_min/720
                anchors.right: parent.right
                anchors.top: path.bottom
                anchors.topMargin: 0
                font.pixelSize: 35*rectangle2.a_sqrt
                wrapMode: Text.Wrap
            }

            Text {
                id: type_info
                text: qsTr("类型说明:\nST:试题包\nGSW:古诗文\nDevDoc:开发文档,开发者文档\nUserDoc:使用文档,用户文档\nZL:资料\nOther:其他")
                textFormat: Text.PlainText
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 5*rectangle2.a_min/720+(rectangle2.height > rectangle2.width ? 0 : 270*rectangle2.width/720)
                anchors.top: rectangle2.height > rectangle2.width ? path_only.bottom : parent.top
                anchors.topMargin: 20*Math.min(rectangle2.a_max/1280,a_pd/12)
                font.pixelSize: 35*rectangle2.a_sqrt
                wrapMode: Text.Wrap
            }
        }
    }
}
