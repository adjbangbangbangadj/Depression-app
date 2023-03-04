import QtQuick 2.14
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout{
    property alias textInput: input
    property alias textPrompt: prompt
    property int inputWidth: 120
    property int inputHeight: 26
    property int pointSize: 12
    Text {
        id: prompt
        font.pointSize: pointSize
        text:promptText
    }
    Rectangle {
        width: inputWidth
        height: inputHeight
        border.color: "black"
        clip: true
        TextInput{
            id: input
            selectByMouse: true
            anchors.fill: parent
            anchors.leftMargin: 6
            font.pointSize: pointSize
            verticalAlignment: TextInput.AlignVCenter

        }
    }
}
