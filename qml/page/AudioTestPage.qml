import QtQuick 2.14
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


ColumnLayout {



    spacing: 250

    Text {
        id: question
        text: qsTr("text")
    }

    RowLayout{
        // var question_text = { "question": [{ "content": "你的名字是" }, { "content": "你的性别是" }] }

        id: record_control
        property int current_question: 0

        property int buttonHeight: 50
        property int buttonWidth: 150
        property int buttonTextSize: 14
        property bool buttons_enabled: true

        spacing: 50

        function record_start_click(){
            record_start.enabled = false
            record_stop.enabled = true
        }

        function record_stop_click(){
            record_stop.enabled = false
            record_next.enabled = true
        }

        function record_next_click(){
            record_next.enabled = false
            record_start.enabled = true
            question.text = question_text[current_question]
            current_question++


        }


        Button{
            id: record_start
            text: qsTr("开始录音")
            font.pointSize: record_control.buttonTextSize
            Layout.minimumHeight: record_control.buttonHeight
            Layout.minimumWidth: record_control.buttonWidth
            enabled: record_control.buttons_enabled
            onClicked: record_control.record_start_click()
        }
        Button{
            id: record_stop
            text: qsTr("停止录音")
            font.pointSize: record_control.buttonTextSize
            Layout.minimumHeight: record_control.buttonHeight
            Layout.minimumWidth: record_control.buttonWidth
            enabled: false
            onClicked: record_control.record_stop_click()
        }
        Button{
            id: record_next
            text: qsTr("下一步")
            font.pointSize: record_control.buttonTextSize
            Layout.minimumHeight: record_control.buttonHeight
            Layout.minimumWidth: record_control.buttonWidth
            enabled: false
            onClicked: record_control.record_next_click()
        }
    }

}
