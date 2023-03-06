import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15


import Main
import 'style'


Item{
    id: audio_test_root
    Component.onCompleted: main_tester.subtest_start('audio_test')
    Component.onDestruction: {
        main_tester.subtest_end('audio_test')
        test_root.completed_tests.push('audio_test')
    }

    AudioTestStyle{ id: audioTestStyle }
    AudioTester{ id: audioTester }

    QtObject{
        id:attrs
        property int current_turn_index: 0
        property int total_turn_num: audioTester.question_num()
    }

    function next_turn(){
        ++attrs.current_turn_index
        if (attrs.current_turn_index >= attrs.total_turn_num)
            test_root.setCurrentPage('option')
    }

    ColumnLayout {
        width: parent.width * audioTestStyle.testLayoutHProportion
        height: parent.height * audioTestStyle.testLayoutVProportion
        anchors.centerIn:parent

        Text {
            id: question
            font.pointSize: audioTestStyle.questionPointSize
            wrapMode: Text.Wrap
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter
            text: qsTr(String(attrs.current_turn_index + 1) + '. ' + audioTester.get_question(attrs.current_turn_index))
        }

        RowLayout{
            id: audio_bottons
            spacing: audioTestStyle.buttonsSpacing
            Layout.alignment: Qt.AlignHCenter

            state: 'before_recording'
            states:[
                State {
                    name: 'before_recording'
                    PropertyChanges {recordStartButton.enabled: true}
                    PropertyChanges {recordEndButton.enabled: false}
                    PropertyChanges {nextTurnButton.enabled: false}
                },
                State {
                    name: 'recording'
                    PropertyChanges {recordStartButton.enabled: false}
                    PropertyChanges {recordEndButton.enabled: true}
                    PropertyChanges {nextTurnButton.enabled: false}
                },
                State {
                    name: 'after_recording'
                    PropertyChanges {recordStartButton.enabled: false}
                    PropertyChanges {recordEndButton.enabled: false}
                    PropertyChanges {nextTurnButton.enabled: true}
                }
            ]

            Button{
                id: recordStartButton
                text: qsTr("开始录音")
                font.pointSize: audioTestStyle.buttonTextSize
                Layout.preferredHeight: audioTestStyle.buttonHeight
                Layout.preferredWidth: audioTestStyle.buttonWidth
                enabled: true
                onClicked: {
                    audio_bottons.state = 'recording'
                    audioTester.start_record(attrs.current_turn_index)
                }
            }
            Button{
                id: recordEndButton
                text: qsTr("停止录音")
                font.pointSize: audioTestStyle.buttonTextSize
                Layout.preferredHeight: audioTestStyle.buttonHeight
                Layout.preferredWidth: audioTestStyle.buttonWidth
                enabled: false
                onClicked: {
                    audio_bottons.state = 'after_recording'
                    audioTester.end_record()
                }
            }
            Button{
                id: nextTurnButton
                text: qsTr("下一步")
                font.pointSize: audioTestStyle.buttonTextSize
                Layout.preferredHeight: audioTestStyle.buttonHeight
                Layout.preferredWidth: audioTestStyle.buttonWidth
                enabled: false
                onClicked: {
                    audio_test_root.next_turn()
                    audio_bottons.state = 'before_recording'
                }
            }
        }

    }
}
