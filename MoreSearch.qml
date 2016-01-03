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

    MessageDialog {
        id: exit_messageDialog
        title: qsTr("退出")
        text: qsTr("您真的要退出吗?")
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: main_widget.close_app()
    }

    Rectangle {
        id: rectangle1
        y: 1175*rectangle2.a_max/1280
        width: rectangle2.width
        height: 105*rectangle2.a_max/1280
        color: "#f0f0f0"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        Row {
            id: row1
            width: rectangle2.width
            height: 105*rectangle2.a_max/1280

            MouseArea {
                id: button1
                anchors.rightMargin: rectangle2.width/4*3
                anchors.fill: parent
                onClicked: main_widget.show_main()

                Text {
                    id: text1
                    text: qsTr("一键搜索")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 30*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
                }
            }

            MouseArea {
                id: button2
                anchors.leftMargin: rectangle2.width/4*1
                anchors.rightMargin: rectangle2.width/4*2
                anchors.fill: parent
                onClicked: main_widget.show_more_search()

                Text {
                    id: text2
                    text: qsTr("更多搜索")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 30*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
                }
            }

            MouseArea {
                id: button3
                anchors.leftMargin: rectangle2.width/4*2
                anchors.rightMargin: rectangle2.width/4*1
                anchors.fill: parent
                onClicked: main_widget.show_history()

                Text {
                    id: text3
                    text: qsTr("历史记录")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 30*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
                }
            }

            MouseArea {
                id: button4
                anchors.leftMargin: rectangle2.width/4*3
                anchors.fill: parent
                onClicked: main_widget.show_more()

                Text {
                    id: text4
                    text: qsTr("更多")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 30*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
                }
            }
        }
    }

    Column {
        id: column1
        anchors.bottom: rectangle1.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottomMargin: 0

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
                text: qsTr("更多搜索")
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 45*rectangle2.a_max/1280
            }
        }
        GridView {
            id: gridView1
            anchors.top: rectangle3.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.topMargin: 0
            model: more_search_list
            z: -1
            cellWidth: 240*rectangle2.a_min/720
            cellHeight: 250*rectangle2.a_max/1280

            delegate: Item {
                width: 240*rectangle2.a_min/720
                height: 240*rectangle2.a_max/1280
                Column {
                    z: -2
                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        height: 200*rectangle2.a_max/1280
                        width: height
                        border.width: 0
                        radius: height/2
                        Text {
                            text: model.modelData.type
                            anchors.centerIn: parent
                            font.pixelSize: 100*rectangle2.a_max/1280
                        }
                    }
                    Text {
                        text: model.modelData.name
                        width: 200*rectangle2.a_max/1280
                        height: 40*rectangle2.a_max/1280
                        font.pixelSize: 40*rectangle2.a_max/1280
                        //elide: Text.ElideRight
                        maximumLineCount: 1
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        main_widget.search_type_clear()
                        main_widget.search_type_add(model.modelData.name_code)
                        main_widget.set_top_bar_height(100*rectangle2.a_max/1280)
                        main_widget.show_search();
                    }
                }
            }
        }
    }

    function oppositeColor(a){
        a=a.replace('#','');
        var c16,c10,max16=15,b=[];
        for(var i=0;i<a.length;i++){
            c16=parseInt(a.charAt(i),16);
            c10=parseInt(max16-c16,10);
            b.push(c10.toString(16));
        }
        return '#'+b.join('');
    }
}
