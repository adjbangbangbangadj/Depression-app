import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Timeline 1.0

import Main
import 'style'

Item{
    anchors.margins: 100
    id: image_test_root

    Component.onCompleted: main_tester.subtest_start('image_test')
    Component.onDestruction: main_tester.subtest_end('image_test')

    ImageTestStyle{ id: imageTestStyle }

    states:  [
        State {//该状态表示正在选择图片
            name: "answering"
            PropertyChanges { image_test_timeline.currentFrame: 0}
            PropertyChanges { answer_duration_animation.running: true}
            PropertyChanges { buttons.unmarked: true}
            PropertyChanges { image.source: `image://main/${attrs.current_turn_index - 1}`}
            PropertyChanges { attrs.curr_turn_begin_time: image_test_root.curr_time()}
        },
        State {//该状态表示两张图片之间的间隔
            name: "interval"
            PropertyChanges { image_test_timeline.currentFrame: attrs.answer_duration}
            PropertyChanges { interval_duration_animation.running: true}
            PropertyChanges { buttons.unmarked: false}
            PropertyChanges { image.source: "image://main/background" }
        }
    ]
    QtObject{
        id: attrs
        property int current_turn_index: 1
        property int curr_turn_begin_time: 0
        property int total_turn_num: $config.get_int('image_test',"pos_image_num")+
                $config.get_int('image_test',"neu_image_num") + $config.get_int('image_test','neg_image_num')
        property int answer_duration: $config.get_int('image_test','answer_duration')
        property int interval_duration: $config.get_int('image_test','interval_duration')
        property bool if_end_immediately_after_answer: $config.get_bool('image_test', 'if_end_immediately_after_answer')
        // property bool if_background_fill_view: $config.get_bool('image_test','if_background_fill_view')
    }
    ImageTester{
        id: image_tester
    }
    Timeline{
        id: image_test_timeline
        startFrame: 0
        currentFrame: 0
        enabled: true
        // loop: Timeline
        endFrame: attrs.answer_duration + attrs.interval_duration + 1000

        animations: [
            TimelineAnimation {
                id: answer_duration_animation
                running: true
                duration: attrs.answer_duration
                onFinished: image_test_root.enter_interval()
            },
            TimelineAnimation {
                id: interval_duration_animation
                running: false
                duration: attrs.interval_duration
                onFinished: image_test_root.enter_answering()
            }
        ]
    }

    function curr_time(){
        //时间戳%1000000避免计算时间差时溢出
        return new Date().getTime() % 1000000
    }

    function enter_interval(){//本张图片结束，进入两张图片之间的间隔
        if (attrs.current_turn_index < attrs.total_turn_num)
            state = 'interval'
        else
            end_test()
    }

    function enter_answering(){//下一张图片
        attrs.current_turn_index++
        state = 'answering'
    }

    function end_test(){
        test_root.setCurrentPage('option')
        // main_tester.subtest_end('image_test')
    }

    RowLayout {
        width: parent.width * 0.9
        height: parent.height * 0.9
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
            id: buttons
            property bool unmarked: true
            spacing: imageTestStyle.buttonsSpacing

            function button_clicked(user_tag){

                for (var prop in attrs) {
                    print(prop += " (" + typeof(attrs[prop]) + ") = " + attrs[prop]);
                }

                if (buttons.unmarked)
                    buttons.unmarked = false
                    if (attrs.if_end_immediately_after_answer)
                        image_test_root.enter_interval()
                    image_tester.answer(attrs.current_turn_index-1, user_tag,
                         image_test_root.curr_time()-attrs.curr_turn_begin_time)
                    console.log(image_test_root.state)
            }

            Button {
                id: button_pos
                text: qsTr("积极")
                font.pointSize: imageTestStyle.buttonTextSize
                Layout.preferredHeight: imageTestStyle.buttonHeight
                Layout.preferredWidth: imageTestStyle.buttonWidth
                enabled: buttons.unmarked
                onClicked: buttons.button_clicked('pos')
            }
            Button {
                id: button_neu
                text: qsTr("中性")
                font.pointSize: imageTestStyle.buttonTextSize
                Layout.preferredHeight: imageTestStyle.buttonHeight
                Layout.preferredWidth: imageTestStyle.buttonWidth
                enabled: buttons.unmarked
                onClicked: buttons.button_clicked('neu')
            }
            Button {
                id: button_neg
                text: qsTr("消极")
                font.pointSize: imageTestStyle.buttonTextSize
                Layout.preferredHeight: imageTestStyle.buttonHeight
                Layout.preferredWidth: imageTestStyle.buttonWidth
                enabled: buttons.unmarked
                onClicked: buttons.button_clicked('neg')
            }
            Text {
                id: prompt_turn_index
                text: qsTr(`${attrs.current_turn_index} / ${attrs.total_turn_num}`)
                font.pointSize: imageTestStyle.buttonTextSize
            }

        }
    }
}
