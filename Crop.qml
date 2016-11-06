import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2

Rectangle {
    id: rectangle2
    width: 720
    height: 1280
    property var cropPoints: {"topLeft": Qt.point(0, 0)};
    color: "#f6f6f6"
    property real a_max: Math.max(width,height)
    property real a_min: Math.min(width,height)
    property real a_pd: 0
    property real a_sqrt: Math.min(Math.sqrt(a_max/1280*a_min/720),a_pd/12)
    z: 0

    MessageDialog {
        id: ocr_warning
        property bool isShow: false
        text: qsTr("提示:本程序目前识别的准确度较低,识别速度较慢,可能需要数秒到数分钟,请稍等.")
        standardButtons: StandardButton.Ok
    }

    MessageDialog {
        id: ocr_not_init
        text: qsTr("对不起:OCR识别失败,OCR模块未初始化或初始化失败,请确认OCR模块是否已经成功安装.")
        standardButtons: StandardButton.Ok
    }

    MessageDialog {
        id: ocr_no_word
        text: qsTr("对不起:OCR识别失败,无法从图片中找出一个文字")
        standardButtons: StandardButton.Ok
    }

    FileDialog {
        id: file
        selectExisting: true
        selectMultiple: false
        selectFolder: false
        title: qsTr("请选择一张图片")
        nameFilters: ["支持的图片文件 (*.jpg *.png *.jpeg *.tiff)", "所有文件 (*)"]
        onAccepted: {
            cropView.source = ""
            cropView.source = main_widget.cp_grayimg_to_tmp(file.fileUrl)
            //cropView.source = file.fileUrl
        }
    }

    DefaultFileDialog {
        id: file2
        folder: "file:///sdcard"
        selectExisting: true
        selectMultiple: false
        selectFolder: false
        title: "请选择一张图片"
        nameFilters: ["支持的图片文件 (*.jpg *.png *.jpeg *.tiff)", "所有文件 (*)"]
        onAccepted: {
            cropView.source = ""
            cropView.source = main_widget.cp_grayimg_to_tmp(file2.fileUrl)
            //cropView.source = file2.fileUrl
        }
        onVisibleChanged: {
            if(!visible)
            {
                rectangle2.parent.parent.forceActiveFocus()
            }
        }
    }

    MessageDialog {
        id: read_error
        objectName: "read_error"
        text: qsTr("对不起,无法读取图片")
        standardButtons: StandardButton.Ok
    }

    MessageDialog {
        id: system_carema_error
        objectName: "system_carema_error"
        text: qsTr("对不起,调用系统相机失败")
        standardButtons: StandardButton.Ok
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
            text: qsTr("剪裁")
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

        Image {
            id: image2
            width: height
            anchors.right: parent.right
            anchors.rightMargin: 10*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            source: "qrc:/image/icon_camera.png"

            MouseArea {
                id: mouseArea2
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
            anchors.top: parent.top
            source: "qrc:/image/icon_folder.png"

            MouseArea {
                id: mouseArea3
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.fill: parent
                onClicked: {
                    (Qt.platform.os == "android") ? file2.open() : file.open()
                }
            }
        }
    }

    Text {
        z: 2
        id: msg_text
        text: qsTr("请选择拍照或选择一张图片")
        anchors.fill: cropView
        font.pixelSize: 40*rectangle2.a_sqrt
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    AnimatedImage {
        id: wait_img2
        z: 2
        anchors.bottom: msg_text.top
        anchors.bottomMargin: -(msg_text.height-msg_text.contentHeight)/2+40*rectangle2.a_sqrt
        //height: rectangle2.a_min/2
        width:  Math.min(rectangle2.a_min/2,msg_text.height-msg_text.contentHeight)
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/image/icon_wait3.gif"
        visible: msg_text.text === qsTr("正在处理图片并识别") || msg_text.text === qsTr("正在载入图片")
        fillMode: Image.PreserveAspectFit
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

        property bool have_read_error: false
        property bool have_ocr_init_error: false
        property bool have_ocr_no_word_error: false
        property bool have_system_carema_error: false
        onHave_read_errorChanged: {
            if(have_read_error) read_error.open()
            have_read_error = false
        }
        onHave_ocr_init_errorChanged: {
            if(have_ocr_init_error) ocr_not_init.open()
            have_ocr_init_error = false
        }
        onHave_ocr_no_word_errorChanged: {
            if(have_ocr_no_word_error) ocr_no_word.open()
            have_ocr_no_word_error = false
        }
        onHave_system_carema_errorChanged: {
            if(have_system_carema_error) system_carema_error.open()
            have_system_carema_error = false
        }


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
                msg_text.text = ""
                have_read_error = true
                cropView.source = ""
            }
        }

        CornerPoint {

            id: topLeft
            objectName: "topLeft"
            visible: cropView.status == Image.Ready
            x: (parent.width - parent.paintedWidth) / 2 - this.width / 2
            y: (parent.height - parent.paintedHeight) / 2 - this.height / 2

            onXChanged: {
                addCorner(topLeft);
                canvas.requestPaint();
                if(image7.lock && bottomLeft.x != x) {
                    bottomLeft.x = x
                }
            }
            onYChanged: {
                addCorner(topLeft);
                canvas.requestPaint();
                if(image7.lock && topRight.y != y) {
                    topRight.y = y
                }
            }

        }

        CornerPoint {
            id: topRight

            objectName: "topRight"
            visible: cropView.status == Image.Ready
            x: (parent.width - parent.paintedWidth) / 2 + parent.paintedWidth - this.width / 2
            y: (parent.height - parent.paintedHeight) / 2 - this.height / 2

            onXChanged: {
                addCorner(topRight);
                canvas.requestPaint();
                if(image7.lock && bottomRight.x != x) {
                    bottomRight.x = x
                }
            }
            onYChanged: {
                addCorner(topRight);
                canvas.requestPaint();
                if(image7.lock && topLeft.y != y) {
                    topLeft.y = y
                }
            }

        }

        CornerPoint {
            id: bottomLeft

            objectName: "bottomLeft"
            visible: cropView.status == Image.Ready
            x: (parent.width - parent.paintedWidth) / 2 - this.width / 2
            y: (parent.height - parent.paintedHeight) / 2 + parent.paintedHeight - this.height / 2/3

            onXChanged: {
                addCorner(bottomLeft);
                canvas.requestPaint();
                if(image7.lock && topLeft.x != x) {
                    topLeft.x = x
                }
            }
            onYChanged: {
                addCorner(bottomLeft);
                canvas.requestPaint();
                if(image7.lock && bottomRight.y != y) {
                    bottomRight.y = y
                }
            }

        }

        CornerPoint {
            id: bottomRight

            objectName: "bottomRight"
            visible: cropView.status == Image.Ready
            x: (parent.width - parent.paintedWidth) / 2 + parent.paintedWidth - this.width / 2
            y: (parent.height - parent.paintedHeight) / 2 + parent.paintedHeight - this.height / 2

            onXChanged: {
                addCorner(bottomRight);
                canvas.requestPaint();
                if(image7.lock && topRight.x != x) {
                    topRight.x = x
                }
            }
            onYChanged: {
                addCorner(bottomRight);
                canvas.requestPaint();
                if(image7.lock && bottomLeft.y != y) {
                    bottomLeft.y = y
                }
            }

        }

        Canvas {
            id: canvas
            anchors.fill: parent
            visible: cropView.status == Image.Ready
            z: 10

            onPaint: {
                var context = getContext("2d");

                var offset = topLeft.width / 2;

                context.reset()
                context.beginPath();
                context.lineWidth = 5;
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
        height: 120*Math.min(rectangle2.a_max/1280,a_pd/12)
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
                        if(!ocr_warning.isShow)
                        {
                            ocr_warning.open()
                            ocr_warning.isShow = true
                        }
                        main_widget.set_top_bar_height(100*Math.min(rectangle2.a_max/1280,a_pd/12))
                        main_widget.crop_ocr_Q(cropView.source,cropPoints,ocr_language.ocr_lang)
                        cropView.source = ""
                        msg_text.text = qsTr("正在处理图片并识别")
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
                        main_widget.rotate_Q(cropView.source,90)
                        cropView.source = ""
                        msg_text.text = qsTr("正在旋转图片")
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
                        main_widget.rotate_Q(cropView.source,-90)
                        cropView.source = ""
                        msg_text.text = qsTr("正在旋转图片")
                    }
                }
            }
        }
        Image {
            id: image7
            width: height
            anchors.right: image6.left
            anchors.rightMargin: 20*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*rectangle2.a_max/1280
            anchors.top: parent.top
            anchors.topMargin: 20*rectangle2.a_max/1280
            source: "qrc:/image/icon_locked.png"
            property bool lock: true
            onLockChanged: lock ? source = "qrc:/image/icon_locked.png" : source = "qrc:/image/icon_unlocked.png"

            MouseArea {
                id: mouseArea7
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.bottomMargin: -20*rectangle2.a_max/1280
                anchors.topMargin: -20*rectangle2.a_max/1280
                anchors.fill: parent
                onClicked: {
                    image7.lock = !image7.lock
                }
            }
        }
        Text {
            id: ocr_language
            anchors.right: image7.left
            anchors.rightMargin: 20*rectangle2.a_min/720
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            property bool ocr_eng: false
            property bool ocr_cht: false
            property bool have_ocr_eng: main_widget.is_exist("ocr/eng.zip",1)
            property bool have_ocr_cht: main_widget.is_exist("ocr/cht.zip",1)
            text: qsTr("简体中文识别")
            property string ocr_lang: "zh_cn"

            MouseArea {
                id: mouseArea8
                anchors.rightMargin: -10*rectangle2.a_min/720
                anchors.leftMargin: -10*rectangle2.a_min/720
                anchors.bottomMargin: -20*rectangle2.a_max/1280
                anchors.topMargin: -20*rectangle2.a_max/1280
                anchors.fill: parent
                onClicked: {
                    if(ocr_language.ocr_eng) {
                        if(ocr_language.have_ocr_cht) {
                            ocr_language.text = qsTr("繁体中文识别")
                            ocr_language.ocr_cht = true
                            ocr_language.ocr_eng = false
                            ocr_language.ocr_lang = "cht"
                        }
                        else {
                            ocr_language.text = qsTr("简体中文识别")
                            ocr_language.ocr_cht = false
                            ocr_language.ocr_eng = false
                            ocr_language.ocr_lang = "zh_cn"
                        }
                    }
                    else {
                        if(ocr_language.ocr_cht) {
                            ocr_language.text = qsTr("简体中文识别")
                            ocr_language.ocr_cht = false
                            ocr_language.ocr_eng = false
                            ocr_language.ocr_lang = "zh_cn"
                        }
                        else {
                            if(ocr_language.have_ocr_eng) {
                                ocr_language.text = qsTr("英文识别")
                                ocr_language.ocr_cht = false
                                ocr_language.ocr_eng = true
                                ocr_language.ocr_lang = "eng"
                            }
                            else {
                                if(ocr_language.have_ocr_cht) {
                                    ocr_language.text = qsTr("繁体中文识别")
                                    ocr_language.ocr_cht = true
                                    ocr_language.ocr_eng = false
                                    ocr_language.ocr_lang = "cht"
                                }
                            }
                        }
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
        if(isNaN(offsetx)||offsetx == null||isNaN(offsety)||offsety == null||isNaN(xScale)||xScale == null||isNaN(yScale)||yScale == null) return;
        cropPoints[corner.objectName] = Qt.point(xScale * (corner.x - (cropView.width - cropView.paintedWidth) / 2 + offsetx),yScale * (corner.y - (cropView.height - cropView.paintedHeight) / 2 + offsety));
    }
}
