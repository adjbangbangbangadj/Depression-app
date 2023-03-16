import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Timeline 1.0

import Main
import 'style'

Pane {
    id: image_test_root
    Component.onCompleted: main_tester.subtest_start('image_test')
    Component.onDestruction: {
        main_tester.subtest_end('image_test')
        test_root.completed_tests.push('image_test')
    }

    ImageTestStyle{ id: imageTestStyle }
    ImageTester{ id: imageTester }

    states:  [
        State {//该状态表示正在选择图片
            name: "answering"
            PropertyChanges { image_test_timeline.currentFrame: 0}
            PropertyChanges { answer_duration_animation.running: true}
            PropertyChanges { image_buttons.marked: false}
            PropertyChanges { image.source: `image://main/${attrs.current_turn_index - 1}`}
            PropertyChanges { attrs.curr_turn_begin_time: image_test_root.curr_time()}
        },
        State {//该状态表示两张图片之间的间隔
            name: "interval"
            PropertyChanges { image_test_timeline.currentFrame: $config.image_test__answer_duration}
            PropertyChanges { interval_duration_animation.running: true}
            PropertyChanges { image_buttons.marked: true}
            PropertyChanges { image.source: "image://main/background" }
        }
    ]
    QtObject{
        id: attrs
        property int current_turn_index: 1
        property int curr_turn_begin_time: 0
        property int total_turn_num: imageTester.image_num()
    }

    Timeline{
        id: image_test_timeline
        startFrame: 0
        currentFrame: 0
        enabled: true
        endFrame: $config.image_test__answer_duration + $config.image_test__interval_duration + 1000

        animations: [
            TimelineAnimation {
                id: answer_duration_animation
                running: true
                duration: $config.image_test__answer_duration
                onFinished: image_test_root.enter_interval()
            },
            TimelineAnimation {
                id: interval_duration_animation
                running: false
                duration: $config.image_test__interval_duration
                onFinished: image_test_root.enter_answering()
            }
        ]
    }

    function curr_time(){
        //时间戳%1000000避免计算时间差时溢出
        return new Date().getTime() % 1000000
    }

    function enter_interval(){//本张图片结束，进入两张图片之间的间隔
        if (attrs.current_turn_index >= attrs.total_turn_num){
            imageTester.save_result()
            test_root.setCurrentPage('option')
        }
        else
            state = 'interval'
    }

    function enter_answering(){//下一张图片
        ++attrs.current_turn_index
        imageTester.turn_start(attrs.current_turn_index)
        state = 'answering'
    }

    RowLayout {
        width: parent.width * imageTestStyle.pageHProportion
        height: parent.height * imageTestStyle.pageVProportion
        anchors.centerIn:parent

        Image {
            id: image
            // width: 150
            // height: 150
            source: 'image://main/0'
            Layout.fillHeight: true
            Layout.fillWidth: true
            fillMode: Image.PreserveAspectFit

        }
        Keys.onDigit1Pressed: button_pos.clicked()//数字键1表示积极
        Keys.onDigit2Pressed: button_neu.clicked()//数字键2表示中性
        Keys.onDigit3Pressed: button_neg.clicked()//数字键3表示消极

        ColumnLayout {
            id: image_buttons
            spacing: imageTestStyle.buttonsSpacing
            property bool marked: false

            function button_clicked(user_tag){
                if (!image_buttons.marked)
                    image_buttons.marked = true
                    if ($config.image_test__if_end_immediately_after_answer)
                        image_test_root.enter_interval()
                    imageTester.answer(attrs.current_turn_index-1, user_tag,
                         image_test_root.curr_time()-attrs.curr_turn_begin_time)
            }

            Button {
                id: button_pos
                text: qsTr("积极")
                font.pointSize: imageTestStyle.buttonTextSize
                Layout.preferredHeight: imageTestStyle.buttonHeight
                Layout.preferredWidth: imageTestStyle.buttonWidth
                enabled: !image_buttons.marked
                onClicked: image_buttons.button_clicked('pos')
            }
            Button {
                id: button_neu
                text: qsTr("中性")
                font.pointSize: imageTestStyle.buttonTextSize
                Layout.preferredHeight: imageTestStyle.buttonHeight
                Layout.preferredWidth: imageTestStyle.buttonWidth
                enabled: !image_buttons.marked
                onClicked: image_buttons.button_clicked('neu')
            }
            Button {
                id: button_neg
                text: qsTr("消极")
                font.pointSize: imageTestStyle.buttonTextSize
                Layout.preferredHeight: imageTestStyle.buttonHeight
                Layout.preferredWidth: imageTestStyle.buttonWidth
                enabled: !image_buttons.marked
                onClicked: image_buttons.button_clicked('neg')
            }
            Text {
                id: prompt_turn_index
                text: qsTr(`${attrs.current_turn_index} / ${attrs.total_turn_num}`)
                font.pointSize: imageTestStyle.buttonTextSize
            }

        }
    }
}
