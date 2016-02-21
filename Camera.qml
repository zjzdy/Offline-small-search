import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import QtMultimedia 5.5

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
    property int currentCamera: 0
    property var cameras: QtMultimedia.availableCameras
    z: 0
    VideoOutput {
        id: vo
        anchors.fill: parent
        anchors.bottomMargin: rectangle2.height/10
        source: Camera {
            id: camera
            captureMode: Camera.CaptureStillImage
            flash.mode: Camera.FlashOff
            focus {
                id: cfocus
                focusMode: Camera.FocusMacro + Camera.FocusContinuous
                focusPointMode: Camera.FocusPointCustom
                customFocusPoint: Qt.point(0.5, 0.5)
            }
            imageCapture {
                onImageSaved: {
                    camera.unlock()
                    main_widget.show_crop("file:///"+path)
                }
                onCaptureFailed: {
                    fail_messageDialog.open()
                }
            }
        }
        autoOrientation: true
        fillMode: VideoOutput.Stretch
        MouseArea {
            anchors.fill: parent
            onClicked: {
                cfocus.customFocusPoint = Qt.point(mouseX/vo.width, mouseY/vo.height)
                camera.searchAndLock()
            }
        }
    }
    MessageDialog {
        id: fail_messageDialog
        title: qsTr("拍照错误")
        text: qsTr("拍照失败,是否需要在剪裁页面自行导入图片？")
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: main_widget.show_crop()
    }
    Item {
        id: bar
        anchors.fill: parent
        anchors.topMargin: rectangle2.height/10*9
        Image {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            opacity: 0.6
            visible: cameras.length > 1
            width: height
            source: "qrc:/image/icon_refresh.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentCamera++
                    if(currentCamera > cameras.length)
                        currentCamera = 0
                    camera.deviceId = cameras[currentCamera].deviceId
                }
            }
        }
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: height
            opacity:0.6
            visible: cameras.length > 0
            source: "qrc:/image/icon_camera.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log(main_widget.get_data_dir()+"/tmp.jpg")
                    camera.imageCapture.captureToLocation(main_widget.get_data_dir()+"/tmp.jpg")
                }
            }
        }
        Image {
            id: flash_i
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            opacity: 0.6
            visible: cameras.length > 1
            width: height
            source: flash ? "qrc:/image/icon_flash.png" : "qrc:/image/icon_flash_off.png"
            property bool flash: false
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parent.flash = !parent.flash
                    camera.flash.mode = parent.flash ? Camera.FlashOn : Camera.FlashOff
                }
            }
        }
    }
}
