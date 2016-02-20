import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
import QtQuick.XmlListModel 2.0

Rectangle {
    id: rectangle2
    width: 720
    height: 1280
    color: "#f6f6f6"
    property real a_max: Math.max(width,height)
    property real a_min: Math.min(width,height)
    z: 0

    Rectangle {
        id: rectangle3
        height: 120*rectangle2.a_max/1280
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
                }
            }
        }
    }

    Rectangle {
        z: 1
        id: rectangle1
        width: rectangle2.width
        height: 60*rectangle2.a_max/1280
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
                anchors.topMargin: 5*rectangle2.a_max/1280
                horizontalAlignment: Text.AlignLeft
                width: 450*rectangle2.width/720
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 40*rectangle2.a_min/720
            }

            Text {
                text: qsTr("大小")
                anchors.top: parent.top
                anchors.topMargin: 5*rectangle2.a_max/1280
                width: 180*rectangle2.width/720
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 40*rectangle2.a_min/720
            }
        }
    }

    XmlListModel {
        id: online_xml
        source: "http://offliness.file.alimmdn.com/xml/online.xml"
        query: "//pkg[@type='pkg']"

        XmlRole {
            name: "download"
            query: "download/string()"
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
    }

    ListView {
        id: listView1
        anchors.top: rectangle1.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 0
        model: online_xml
        z: 0

        delegate: Item {
            z: -1
            width: rectangle2.width
            height: 80*rectangle2.a_max/1280
            Text {
                id: name_t
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                text: name
                width: 450*rectangle2.width/720
                verticalAlignment: Text.AlignVCenter
                //anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 45*rectangle2.a_max/1280
            }

            Text {
                id: zip_size_t
                anchors.left: name_t.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                text: zip_size
                width: 150*rectangle2.width/720
                verticalAlignment: Text.AlignVCenter
                //anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 45*rectangle2.a_max/1280
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
                    more_info.visible = true
                    rectangle2.focus = true
                }
            }
            Item {
                anchors.left: zip_size_t.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                AnimatedImage {
                    id: image2
                    z: 1
                    anchors.fill: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:/image/icon_wait2.gif"
                    visible: false
                    fillMode: Image.PreserveAspectFit
                    onVisibleChanged: {
                        xz_text.text = main_widget.is_exist(download,1) ? qsTr("删除") : qsTr("下载")
						progress = ""
                    }
					property string progress: ""
					
					Text {
						visible: image2.visible
						text: image2.progress
						anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
					}
                }

                Rectangle {
                    id: xz
                    visible: !image2.visible
                    enabled: visible
                    anchors.fill: parent
                    //anchors.leftMargin: 45*rectangle2.a_min/720
                    //anchors.rightMargin: 45*rectangle2.a_min/720
                    //anchors.topMargin: 15*rectangle2.a_max/1280
                    //anchors.bottomMargin: 15*rectangle2.a_max/1280
                    radius: 15*rectangle2.a_max/1280
                    color: "white"
                    border.color: "black"
                    border.width: 5*rectangle2.a_max/1280
                    Text {
                        id: xz_text
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: main_widget.is_exist(download,1) ? qsTr("删除") : qsTr("下载")
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            image2.visible = true
                            main_widget.obj_list_insert(download,image2)
                            //image2.parent = listView1
                            //image2.objectName = main_widget.get_url_objname(download)
                            //console.log(listView1.children[0].children[3].children[0].objectName)
                            //console.log(listView1.children[0].children[2].children[0].objectName)
                            main_widget.is_exist(download,1) ? main_widget.remove_data(download) : main_widget.download_data(download)
                            //main_widget.download_data(download)
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        z: 2
        id: more_info
        visible: false
        x: 90*rectangle2.width/720
        y: 130*rectangle2.height/1280
        implicitWidth: 540*rectangle2.width/720
        implicitHeight: 1060*rectangle2.height/1280
        color: "#f6f6f6"
        radius: 10*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
        border.color: "#c1c1be"
        border.width: 5*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
        Keys.onBackPressed: {
            more_info.visible = false
            rectangle2.focus = true
        }
        Keys.onEscapePressed: {
            more_info.visible = false
            rectangle2.focus = true
        }
        Button {
            id: button1
            //width: 270*rectangle2.a_min/720
            height: 70*rectangle2.a_max/1280
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
                font.pixelSize: 55*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
            }
            onClicked: {
                more_info.visible = false
                rectangle2.focus = true
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
            font.pixelSize: 35*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
        }

        Text {
            id: name_only
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.a_min/720
            anchors.right: parent.right
            anchors.top: name.bottom
            anchors.topMargin: 0
            font.pixelSize: 35*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
            wrapMode: Text.Wrap
        }

        Text {
            id: type
            text: qsTr("离线包类型:")
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.a_min/720
            anchors.right: parent.right
            anchors.top: name_only.bottom
            anchors.topMargin: 20*rectangle2.a_max/1280
            font.pixelSize: 35*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
        }

        Text {
            id: type_only
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.a_min/720
            anchors.right: parent.right
            anchors.top: type.bottom
            anchors.topMargin: 0
            font.pixelSize: 35*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
            wrapMode: Text.Wrap
        }

        Text {
            id: name_code
            text: qsTr("离线包标识码:")
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.a_min/720
            anchors.right: parent.right
            anchors.top: type_only.bottom
            anchors.topMargin: 20*rectangle2.a_max/1280
            font.pixelSize: 35*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
        }

        Text {
            id: name_code_only
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.a_min/720
            anchors.right: parent.right
            anchors.top: name_code.bottom
            anchors.topMargin: 0
            font.pixelSize: 35*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
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
            anchors.topMargin: 20*rectangle2.a_max/1280
            font.pixelSize: 35*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
        }

        Text {
            id: path_only
            anchors.left: parent.left
            anchors.leftMargin: 5*rectangle2.a_min/720
            anchors.right: parent.right
            anchors.top: path.bottom
            anchors.topMargin: 0
            font.pixelSize: 35*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
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
            anchors.topMargin: 20*rectangle2.a_max/1280
            font.pixelSize: 35*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
            wrapMode: Text.Wrap
        }
    }
}
