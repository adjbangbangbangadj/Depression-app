import QtQuick 2.14
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15



ColumnLayout {



    spacing: 250

    property var questions: [`1、请阅读以下寓言故事《北风与太阳》，点击开始录制后进行朗读（如自时间节点6后10秒仍未点击录制，
        播放语音提示“请点击开始录制按钮”），并在朗读完成后点击完成录制。
        有一次，北风和太阳正在争论谁比较有本事。他们正好看到有个穿着大衣的人走过来，他们就说，
        谁可以让那个人脱掉那件大衣，就算谁比较有本事。于是北风开始拼命地吹。怎知，他吹得越厉害，
        那个人就越是用大衣包裹自己。最后，北风没办法，就放弃了。接着，太阳出来晒了一会儿，
        那个人感觉变得很热，立刻把大衣脱掉了。于是，北风只好认输了。`,
                `2、请阅读以下问题，稍作思考后用简短但完整的语句回答（请不要仅使用词语），
        点击开始录制后开始回答（如自时间节点11后30秒仍未点击录制，
        播放语音提示“请点击开始录制按钮”），回答完成后点击完成录制。
        你喜欢什么动物，并说出喜欢的原因。`,
                `3、请阅读以下问题，稍作思考后用简短但完整的语句回答（请不要仅使用词语），
        点击开始录制后开始回答（如自时间节点15后30秒仍未点击录制，
        播放语音提示“请点击开始录制按钮”），回答完成后点击完成录制。
        介绍一位熟悉的朋友，比如他的性别、爱好、学习或工作经历等。`,
                `4、请阅读以下问题，稍作思考后用简短但完整的语句回答（请不要仅使用词语），
        点击开始录制后开始回答（如自时间节点19后30秒仍未点击录制，
        播放语音提示“请点击开始录制按钮”），回答完成后点击完成录制。
        请描述一下你与朋友发生分歧时你的感受，以及你会怎么做? `]

    Text {
        id: question
        text: qsTr(questions[0])
    }

    RowLayout{


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
            $test.begin_record(current_question)
        }

        function record_stop_click(){
            record_stop.enabled = false
            record_next.enabled = true
            $test.end_record()
        }

        function end_record_test(){
            recorder_view.visible = false
            option_main.visible = true
            $test.end_record_test()

        }

        function record_next_click(){
            record_next.enabled = false
            record_start.enabled = true

            current_question++
            if(current_question>=4)
                end_record_test()

            question.text = questions[current_question]
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
