import QtQuick 2.8
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.3

TabButton {
    id: control
    padding: height/2
    //spacing: 0


    contentItem: Rectangle{
        anchors.fill: control
        color: "#00000000"
        Text {
            anchors.fill: parent
            z: 4
            text: control.text
            font: control.font
            elide: Text.ElideRight
            //opacity: enabled ? 1 : 0.3
            color: !control.enabled ? "#26282A" : control.down || control.checked ? "#03A9F4" : "#353637"//607D8B 26282a 353637
            height: control.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            //color: !control.enabled ? control.Material.hintTextColor : control.down || control.checked ? control.Material.accentColor : control.Material.primaryTextColor
        }
    }

    background: Rectangle {
        //implicitHeight: 40
        //color: control.down ? (control.checked ? "#e4e4e4" : "#585a5c") : (control.checked ? "transparent" : "#353637")
    }
}
