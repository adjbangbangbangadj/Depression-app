import QtQuick 2.15
import QtQuick.Layouts 2.15

RowLayout{
    property alias textInput: input
    property alias textPrompt: prompt
    property int pointSize: 12
    Text {
        id: prompt
        wrapMode: Text.NoWrap
        font.pointSize: pointSize
        text:promptText
    }
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height * 1.25
        border.color: "black"
        clip: true
        TextInput{
            id: input
            anchors.centerIn: parent
            width: parent.width * 0.9
            font.pointSize: pointSize
            selectByMouse: true
        }
    }
}
