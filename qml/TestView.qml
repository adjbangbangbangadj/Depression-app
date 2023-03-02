import QtQuick 2.14
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout {
    signal testEnd
    state: "inactive"
    states:  [
        State {//该状态表示测试已结束或者未开始
            name: "inactive"
        },
        State {//该状态表示正在选择图片
            name: "testing"
            PropertyChanges { target: buttons; buttons_enabled: true; is_marked: false}
            PropertyChanges { target: image; source: `image://test/${attrs.current_turn_index - 1}`;
                fillMode:Image.PreserveAspectFit}
            PropertyChanges { target: attrs; curr_turn_begin_time: curr_time()}
        },
        State {//该状态表示两张图片之间的间隔
            name: "interval"
            PropertyChanges { target: buttons; buttons_enabled: false; is_marked: true}
            PropertyChanges { target: image; source: "image://test/background";
                fillMode:attrs.if_background_fill?Image.Stretch :Image.PreserveAspectFit}
        }
    ]
    QtObject{
        id: attrs
        property string pic_source: "image://test/0"
        property int current_turn_index: 1
        property int turn_num: 20
        property int answer_duration: 3000
        property int interval_duration: 1000
        property int curr_turn_begin_time: 0
        property bool if_end_immediately_after_answer:false
        property bool if_background_fill:false
    }
    function curr_time(){
        //时间戳%1000000避免计算时间差时溢出
        return new Date().getTime() % 1000000
    }
    function into_interval(){//本张图片结束，进入两张图片之间的间隔
        if (attrs.current_turn_index < attrs.turn_num){
            state = 'interval'
            interval_timer.start()
        }
        else
            end_image_test()
    }
   function next_turn(){//下一张图片
        attrs.current_turn_index++
        state = 'testing'
        test_timer.start()
        $test.turn_start()
    }
    function begin_image_test(){//开始测试
        state = 'testing'
        test_timer.start()
        focus = true
        //initialize configs
        attrs.turn_num = $config.get_config("pos_pic_num")+$config.get_config("neu_pic_num")+$config.get_config("neg_pic_num")
        attrs.answer_duration = $config.get_config("answer_duration")
        attrs.interval_duration = $config.get_config("interval_duration")
        attrs.if_end_immediately_after_answer = $config.get_config("if_end_immediately_after_answer")
        attrs.if_background_fill = $config.get_config("if_background_fill")
    }

    function end_image_test(){//结束测试
        state = 'inactive'
        testEnd()
    }
    function end_immediately_after_answer(){
        into_interval()
        test_timer.stop()
    }
    Timer {//用于计每张图片的作答的时间的计时器
        id: test_timer
        interval: attrs.answer_duration
        repeat: false
        triggeredOnStart: false
        onTriggered:{
            into_interval()
        }
    }

    Timer {//用于计两张图片之间的时间的计时器
        id: interval_timer
        interval: attrs.interval_duration
        repeat: false
        triggeredOnStart: false
        onTriggered:{
            next_turn()
        }
    }

    Image {
        id: image
        width: 150
        height: 150
        Layout.fillHeight: true
        Layout.fillWidth: true
        fillMode: Image.PreserveAspectFit

    }
    Keys.onDigit1Pressed: buttons.button_press(button_pos,"pos")//数字键1表示积极
    Keys.onDigit2Pressed: buttons.button_press(button_neu,"neu")//数字键2表示中性
    Keys.onDigit3Pressed: buttons.button_press(button_neg,"neg")//数字键3表示消极
    Keys.onReleased: {
        switch(event.key){
        case Qt.Key_1:buttons.button_release(button_pos);break
        case Qt.Key_2:buttons.button_release(button_neu);break
        case Qt.Key_3:buttons.button_release(button_neg);break
        }
    }
    ColumnLayout {
        id: buttons
        spacing: 20
        property bool buttons_enabled: true
        property bool is_marked: false
        property int buttonHeight: 50
        property int buttonWidth: 150
        property int buttonTextSize: 14

        function button_press(button,tag){
            if (buttons.is_marked != true){
                button.down = true
                $test.mark(attrs.current_turn_index-1,tag,
                           curr_time()-attrs.curr_turn_begin_time)
                buttons.is_marked = true
            }
        }
        function button_release(button){
            if(attrs.if_end_immediately_after_answer && buttons.buttons_enabled)
                end_immediately_after_answer()
            button_neg.down = false
            button_neu.down = false
            button_pos.down = false
            buttons.buttons_enabled = false
        }

        Button {
            id: button_pos
            text: qsTr("积极")
            font.pointSize: buttons.buttonTextSize
            Layout.minimumHeight: buttons.buttonHeight
            Layout.minimumWidth: buttons.buttonWidth
            enabled: buttons.buttons_enabled
            onPressed: buttons.button_press(button_pos,"pos")
            onReleased: buttons.button_release(button_pos)
        }
        Button {
            id: button_neu
            text: qsTr("中性")
            font.pointSize: buttons.buttonTextSize
            Layout.minimumHeight: buttons.buttonHeight
            Layout.minimumWidth: buttons.buttonWidth
            enabled: buttons.buttons_enabled
            onPressed: buttons.button_press(button_neu,"neu")
            onReleased: buttons.button_release(button_neu)
        }
        Button {
            id: button_neg
            text: qsTr("消极")
            font.pointSize: buttons.buttonTextSize
            Layout.minimumHeight: buttons.buttonHeight
            Layout.minimumWidth: buttons.buttonWidth
            enabled: buttons.buttons_enabled
            onPressed: buttons.button_press(button_neg,"neg")
            onReleased: buttons.button_release(button_neg)
        }
        Text {
            id: prompt_turn_index
            text: qsTr(`${attrs.current_turn_index} / ${attrs.turn_num}`)
            font.pointSize: 14
        }

    }
}
