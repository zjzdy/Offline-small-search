import QtQuick 2.7
import QtQuick.Controls 2.0

Item {
    property real a_max: Math.max(width,height)
    property real a_min: Math.min(width,height)
    property real a_pd: 0
    property real a_sqrt: Math.min(Math.sqrt(a_max/1280*a_min/720),a_pd/12)
    z: 0
    StackView {
        id: stackView
        objectName: "pluginPages"
        anchors.fill: parent
        property url needReplace: ""
        onNeedReplaceChanged: {
            pop(StackView.Immediate)
            clear()
            main_widget.addChildToPluginPagesObject(stackView.replace("file:///"+needReplace))
        }
    }
}
