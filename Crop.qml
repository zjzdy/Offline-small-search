import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2

Rectangle {
    id: rectangle2
    width: 720
    height: 1280
    property var cropPoints: {"topLeft": Qt.point(0, 0)};
    color: "#f6f6f6"
    property real a_max: Math.max(width,height)
    property real a_min: Math.min(width,height)
    z: 0

    FileDialog {
        id: file
        selectExisting: true
        selectMultiple: false
        selectFolder: false
        title: "请选择一张图片"
        nameFilters: [ "支持的图片文件 (*.jpg *.png *.jpeg *.tiff)", "所有文件 (*)" ]
        onAccepted: {
            cropView.source = file.fileUrl
            console.log(file.fileUrl)
        }
    }

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
        z: 1

        Text {
            id: text8
            text: qsTr("剪裁")
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

        Image {
            id: image2
            width: height
            anchors.right: parent.right
            anchors.rightMargin: 10*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle2.a_max/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle2.a_max/1280
            source: "qrc:/image/icon_camera.png"

            MouseArea {
                id: mouseArea2
                anchors.topMargin: -20*rectangle2.a_max/1280
                anchors.bottomMargin: -20*rectangle2.a_max/1280
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.fill: parent
                onClicked: {
                    main_widget.startCamera()
                }
            }
        }

        Image {
            id: image3
            width: height
            anchors.right: image2.left
            anchors.rightMargin: 20*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle2.a_max/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle2.a_max/1280
            source: "qrc:/image/icon_folder.png"

            MouseArea {
                id: mouseArea3
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.bottomMargin: -20*rectangle2.a_max/1280
                anchors.topMargin: -20*rectangle2.a_max/1280
                anchors.fill: parent
                onClicked: {
                    file.open()
                }
            }
        }
    }

    Text {
        z: 2
        id: msg_text
        text: qsTr("请选择拍照或选择一张图片")
        anchors.fill: cropView
        font.pixelSize: 40*Math.sqrt(rectangle2.a_max/1280*rectangle2.a_min/720)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Image {
        id: cropView
        z: 0
        objectName: "cropView"
        anchors.top: rectangle3.bottom
        anchors.bottom: rectangle4.top
        anchors.left: parent.left
        anchors.right: parent.right
        asynchronous: true
        cache: false
        fillMode: Image.Stretch

        onStatusChanged: {
            if (cropView.status == Image.Null) {
                msg_text.text = qsTr("请选择拍照或选择一张图片")
            }
            else if (cropView.status == Image.Loading) {
                msg_text.text = qsTr("正在载入图片")
            }
            else if(cropView.status == Image.Ready){
                msg_text.text = ""
                topLeft.x = (width - paintedWidth) / 2 - topLeft.width / 2 + paintedWidth/5
                topLeft.y = (height - paintedHeight) / 2 - topLeft.height / 2 + paintedHeight/5
                topRight.x = (width - paintedWidth) / 2 + paintedWidth - topRight.width / 2 - paintedWidth/5
                topRight.y = (height - paintedHeight) / 2 - topRight.height / 2 + paintedHeight/5
                bottomLeft.x = (width - paintedWidth) / 2 - bottomLeft.width / 2 + paintedWidth/5
                bottomLeft.y = (height - paintedHeight) / 2 + paintedHeight - bottomLeft.height / 2 - paintedHeight/5
                bottomRight.x = (width - paintedWidth) / 2 + paintedWidth - bottomRight.width / 2 - paintedWidth/5
                bottomRight.y = (height - paintedHeight) / 2 + paintedHeight - bottomRight.height / 2 - paintedHeight/5
                addCorner(topLeft);
                addCorner(topRight);
                addCorner(bottomLeft);
                addCorner(bottomRight);
            }
            else if(cropView.status == Image.Error){
                msg_text.text = qsTr("图片载入失败,请重试")
            }
        }

        CornerPoint {

            id: topLeft
            objectName: "topLeft"
            x: (parent.width - parent.paintedWidth) / 2 - this.width / 2
            y: (parent.height - parent.paintedHeight) / 2 - this.height / 2

            onXChanged: {
                addCorner(topLeft);
                canvas.requestPaint();
            }
            onYChanged: {
                addCorner(topLeft);
                canvas.requestPaint();
            }

        }

        CornerPoint {
            id: topRight

            objectName: "topRight"
            x: (parent.width - parent.paintedWidth) / 2 + parent.paintedWidth - this.width / 2
            y: (parent.height - parent.paintedHeight) / 2 - this.height / 2

            onXChanged: {
                addCorner(topRight);
                canvas.requestPaint();
            }
            onYChanged: {
                addCorner(topRight);
                canvas.requestPaint();
            }

        }

        CornerPoint {
            id: bottomLeft

            objectName: "bottomLeft"
            x: (parent.width - parent.paintedWidth) / 2 - this.width / 2
            y: (parent.height - parent.paintedHeight) / 2 + parent.paintedHeight - this.height / 2/3

            onXChanged: {
                addCorner(bottomLeft);
                canvas.requestPaint();
            }
            onYChanged: {
                addCorner(bottomLeft);
                canvas.requestPaint();
            }

        }

        CornerPoint {
            id: bottomRight

            objectName: "bottomRight"
            x: (parent.width - parent.paintedWidth) / 2 + parent.paintedWidth - this.width / 2
            y: (parent.height - parent.paintedHeight) / 2 + parent.paintedHeight - this.height / 2

            onXChanged: {
                addCorner(bottomRight);
                canvas.requestPaint();
            }
            onYChanged: {
                addCorner(bottomRight);
                canvas.requestPaint();
            }

        }

        Canvas {
            id: canvas
            anchors.fill: parent
            z: 10

            onPaint: {
                var context = getContext("2d");

                var offset = topLeft.width / 2;

                context.reset()
                context.beginPath();
                context.lineWidth = 2;
                context.moveTo(topLeft.x + offset, topLeft.y + offset);
                context.strokeStyle = "#87CEFA"

                context.lineTo(topRight.x + offset, topRight.y + offset);
                context.lineTo(bottomRight.x + offset, bottomRight.y + offset);
                context.lineTo(bottomLeft.x + offset, bottomLeft.y + offset);
                context.lineTo(topLeft.x + offset, topLeft.y + offset);
                context.closePath();
                context.stroke();
            }
        }
    }

    Rectangle {
        id: rectangle4
        height: 120*rectangle2.a_max/1280
        color: "#f0f0f0"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        z: 1

        Image {
            id: image4
            width: height
            anchors.left: parent.left
            anchors.leftMargin: 10*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle2.a_max/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle2.a_max/1280
            source: "qrc:/image/icon_checkmark.png"

            MouseArea {
                id: mouseArea4
                anchors.topMargin: -20*rectangle2.a_max/1280
                anchors.bottomMargin: -20*rectangle2.a_max/1280
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.fill: parent
                onClicked: {
                    if (cropView.status == Image.Ready) {
                        //var source_tmp = ""
                        //source_tmp = cropView.source
                        main_widget.search_type_clear()
                        main_widget.search_type_add("ALL")
                        main_widget.set_top_bar_height(100*rectangle2.a_max/1280)
                        main_widget.crop_ocr_Q(cropView.source,cropPoints)
                        cropView.source = ""
                        msg_text.text = qsTr("正在处理图片并OCR")
                        //main_widget.show_search(crop_obj.crop_ocr(source_tmp, cropPoints));
                        //main_widget.show_back()
                    }
                }
            }
        }

        Image {
            id: image5
            width: height
            anchors.right: parent.right
            anchors.rightMargin: 10*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle2.a_max/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle2.a_max/1280
            source: "qrc:/image/icon_right.png"

            MouseArea {
                id: mouseArea5
                anchors.topMargin: -20*rectangle2.a_max/1280
                anchors.bottomMargin: -20*rectangle2.a_max/1280
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.fill: parent
                onClicked: {
                    if (cropView.status == Image.Ready) {
                        //var source_tmp = ""
                        //source_tmp = cropView.source
                        main_widget.rotate_Q(cropView.source,-90)
                        //crop_obj.rotate(cropView.source,90)
                        cropView.source = ""
                        msg_text.text = qsTr("正在旋转图片")
                        //cropView.source = source_tmp
                    }
                }
            }
        }

        Image {
            id: image6
            width: height
            anchors.right: image5.left
            anchors.rightMargin: 20*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle2.a_max/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle2.a_max/1280
            source: "qrc:/image/icon_left.png"

            MouseArea {
                id: mouseArea6
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.bottomMargin: -20*rectangle2.a_max/1280
                anchors.topMargin: -20*rectangle2.a_max/1280
                anchors.fill: parent
                onClicked: {
                    if (cropView.status == Image.Ready) {
                        //var source_tmp = ""
                        //source_tmp = cropView.source
                        main_widget.rotate_Q(cropView.source,-90)
                        //crop_obj.rotate(cropView.source,-90)
                        cropView.source = ""
                        msg_text.text = qsTr("正在旋转图片")
                        //cropView.source = source_tmp
                    }
                }
            }
        }
    }

    function addCorner(corner) {
        var offsetx = corner.width / 2;
        var offsety = corner.height / 2;
        var xScale = cropView.sourceSize.width / cropView.paintedWidth;
        var yScale = cropView.sourceSize.height / cropView.paintedHeight;
        cropPoints[corner.objectName] = Qt.point(xScale * (corner.x - (cropView.width - cropView.paintedWidth) / 2 + offsetx),
                                                 yScale * (corner.y - (cropView.height - cropView.paintedHeight) / 2 + offsety));
    }
}
