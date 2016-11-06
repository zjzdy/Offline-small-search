import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

Rectangle {
    id: rectangle2
    width: 720
    height: Screen.desktopAvailableHeight//1280
    property real a_max: Math.max(width,height)
    property real a_min: Math.min(width,height)
    property real a_pd: 0
    property real a_sqrt: Math.min(Math.sqrt(a_max/1280*a_min/720),a_pd/12)

    Rectangle {
        id: rectangle3
        objectName: "search_top_bar"
        implicitHeight: 100*Math.min(rectangle2.a_max/1280,a_pd/12)
        property real a_max: Math.max(width,height)
        property real a_min: Math.min(width,height)
        //height: 120*Math.min(rectangle2.a_max/1280,a_pd/12)
        color: "#f0f0f0"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Text {
            id: text8
            text: qsTr("搜索")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: image1.right
            anchors.right: image4.left
            font.pixelSize: 45*rectangle3.height/100//Math.min(rectangle2.a_max/1280,a_pd/12)
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
                    rectangle2.focus = true
                    main_widget.show_back()
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
            anchors.topMargin: 10*rectangle3.height/100
            anchors.bottomMargin: 10*rectangle3.height/100
            source: "qrc:/image/icon_search.png"

            MouseArea {
                id: mouseArea2
                anchors.topMargin: -10*rectangle3.height/100
                anchors.bottomMargin: -10*rectangle3.height/100
                anchors.leftMargin: -15*rectangle2.a_min/720
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.fill: parent
                onClicked: {
                    rectangle2.focus = true
                    main_widget.show_search_result(textEdit1.text)
                    main_widget.add_history(textEdit1.text,false,Qt.formatDateTime(new Date(), "yyyy/MM/dd MMM dddd hh:mm:ss"),main_widget.get_search_type())
                    main_widget.history_list_to_data_file()
                }
            }
        }

        Image {
            id: image3
            objectName: "camera_img"
            width: have_ocr ? height : 0
            anchors.right: image2.left
            anchors.rightMargin: have_ocr ? 30*rectangle2.a_min/720 : 0
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            source: "qrc:/image/icon_camera.png"
            property bool have_ocr: main_widget.is_exist("ocr/zh_cn.zip",1)
            //visible: main_widget.is_exist("ocr/zh_cn.zip",1)

            MouseArea {
                id: mouseArea3
                anchors.leftMargin: parent.have_ocr ? -15*rectangle2.a_min/720 : 0
                anchors.rightMargin: parent.have_ocr ? -15*rectangle2.a_min/720 : 0
                anchors.fill: parent
                onClicked: {
                    rectangle2.focus = true
                    main_widget.startCamera()
                }
            }
        }

        Image {
            id: image4
            objectName: "home_img"
            width: have_home ? height : 0
            anchors.right: image3.left
            anchors.rightMargin: have_home ? 30*rectangle2.a_min/720 : 0
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            source: "qrc:/image/icon_home.png"
            property bool have_home: main_widget.have_home()

            MouseArea {
                id: mouseArea4
                anchors.leftMargin: parent.have_home ? -15*rectangle2.a_min/720 : 0
                anchors.rightMargin: parent.have_home ? -15*rectangle2.a_min/720 : 0
                anchors.fill: parent
                onClicked: {
                    rectangle2.focus = true
                    main_widget.show_pkg_home()
                }
            }
        }
    }

    Flickable {
        id: flickable
        anchors.bottom: rectangle5.top
        anchors.bottomMargin: 0
        anchors.top: rectangle3.bottom
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        TextArea.flickable: TextArea {
            id: textEdit1
            objectName: "search_text"
            horizontalAlignment: Text.AlignLeft
            textFormat: TextEdit.PlainText
            wrapMode: TextEdit.Wrap
            selectByKeyboard: true
            selectByMouse: true
            //renderType: Text.NativeRendering
            selectedTextColor: "white"
            selectionColor: "#03A9F4"
            font.pixelSize: 40*rectangle3.height/100
            Text {
                id:please_input
                anchors.fill: parent
                text:qsTr("请在此输入您要搜索的内容.如输入法并未出现,请单击此处.")
                wrapMode: TextEdit.Wrap
                color: "#868686"
                font.pixelSize: 40*rectangle3.height/100
                visible: textEdit1.text.length < 1
            }
        }
        ScrollBar.vertical: ScrollBar { }
    }

    Rectangle {
        id: rectangle5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0//555*Math.min(rectangle2.a_max/1280,a_pd/12)
        height: 80*rectangle3.height/100//Math.min(rectangle2.a_max/1280,a_pd/12)
        width: rectangle2.width
        color: "#f0f0f0"
        Row {
            Text {
                height: rectangle5.height
                width: rectangle2.width/4
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("复制")
                font.pixelSize: 40*rectangle3.height/100
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        textEdit1.copy()
                        textEdit1.focus = true
                    }
                }
            }
            Text {
                height: rectangle5.height
                width: rectangle2.width/4
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("粘贴")
                font.pixelSize: 40*rectangle3.height/100
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        textEdit1.paste()
                        textEdit1.focus = true
                    }
                }
            }
            Text {
                height: rectangle5.height
                width: rectangle2.width/4
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("剪切")
                font.pixelSize: 40*rectangle3.height/100
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        textEdit1.cut()
                        textEdit1.focus = true
                    }
                }
            }
            Text {
                height: rectangle5.height
                width: rectangle2.width/4
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("清空")
                font.pixelSize: 40*rectangle3.height/100
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        textEdit1.text = ""
                        textEdit1.focus = true
                    }
                }
            }
        }
    }
}
