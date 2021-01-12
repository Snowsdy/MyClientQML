import QtQuick 2.10
import QtQuick.Controls 2.3

Button {
    id: control

    leftPadding: padding + 10
    topPadding: padding + 5
    rightPadding: padding + 10
    bottomPadding: padding + 5

    property alias color: back.color
    property alias border: back.border

    contentItem: Text {
        text: control.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 22
    }

    background: Rectangle {
        id: back
        border.width: 2
        radius: 5
    }
}
