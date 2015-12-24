import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
import QtQuick.Window 2.2

Rectangle {
    id: rectangle2
    width: 720
    height: Screen.desktopAvailableHeight//1280
    property real a_max: Math.max(width,height)
    property real a_min: Math.min(width,height)

    Rectangle {
        id: rectangle3
        objectName: "search_top_bar"
        implicitHeight: 100*rectangle2.a_max/1280
        property real a_max: Math.max(width,height)
        property real a_min: Math.min(width,height)
        //height: 120*rectangle2.a_max/1280
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
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 45*rectangle3.height/100//rectangle2.a_max/1280
        }

        Image {
            id: image1
            width: height
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle3.height/100//rectangle2.a_max/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle3.height/100//rectangle2.a_max/1280
            source: "qrc:/image/icon_back.png"

            MouseArea {
                id: mouseArea1
                anchors.topMargin: -20*rectangle3.height/100//rectangle2.a_max/1280
                anchors.bottomMargin: -20*rectangle3.height/100//rectangle2.a_max/1280
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
            anchors.bottomMargin: 20*rectangle3.height/100//rectangle2.a_max/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle3.height/100//rectangle2.a_max/1280
            source: "qrc:/image/icon_search.png"

            MouseArea {
                id: mouseArea2
                anchors.topMargin: -20*rectangle3.height/100//rectangle2.a_max/1280
                anchors.bottomMargin: -20*rectangle3.height/100//rectangle2.a_max/1280
                anchors.leftMargin: -10*rectangle2.a_min/720
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
    }

    TextArea {
        id: textEdit1
        objectName: "search_text"
        horizontalAlignment: Text.AlignLeft
        anchors.bottom: rectangle5.top
        anchors.bottomMargin: 0
        anchors.top: rectangle3.bottom
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        textFormat: TextEdit.PlainText
        wrapMode: TextEdit.Wrap
        style: TextAreaStyle {
                textColor: "black"
                selectedTextColor: "white"
                backgroundColor: "white"
            }
        font.pixelSize: 40*Math.sqrt(rectangle3.height/100/*rectangle2.a_max/1280*/*rectangle2.a_min/720)
    }

    Rectangle {
        id: rectangle5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0//555*rectangle2.a_max/1280
        height: 80*rectangle3.height/100//rectangle2.a_max/1280
        width: rectangle2.width
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
