import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0

TabButton {
    id: control

    contentItem: Text {
        text: control.text
        font: control.font
        elide: Text.ElideRight
        //opacity: enabled ? 1 : 0.3
        color: !control.enabled ? "#26282A" : control.down || control.checked ? "#03A9F4" : "#353637"//607D8B 26282a 353637
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        //color: !control.enabled ? control.Material.hintTextColor : control.down || control.checked ? control.Material.accentColor : control.Material.primaryTextColor
    }

    background: Rectangle {
        //implicitHeight: 40
        //color: control.down ? (control.checked ? "#e4e4e4" : "#585a5c") : (control.checked ? "transparent" : "#353637")
    }
}
