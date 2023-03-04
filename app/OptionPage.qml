import QtQuick 2.14
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ColumnLayout {

    id: button_option
    spacing: 80
    property bool buttons_enabled: true
    property int buttonHeight: 50
    property int buttonWidth: 150
    property int buttonTextSize: 14

    function button_record_click(){
        option_main.visible = false
        recorder_view.visible = true
        button_record_test.enabled = false
    }

    function button_image_click(){
        $test.begin_test(username)
        option_main.visible = false
        test_view.visible = true
        button_image_test.enabled = false
        test_view.begin_test()
    }

    function button_end_click(){

    }

    Button{
        id: button_image_test
        text: qsTr("图片测试")
        font.pointSize: button_option.buttonTextSize
        Layout.minimumHeight: button_option.buttonHeight
        Layout.minimumWidth: button_option.buttonHeight
        onClicked: root_layout.setCurrentPage('image_test')
    }
    Button{
        id: button_record_test
        text: qsTr("语音测试")
        font.pointSize: button_option.buttonTextSize
        Layout.minimumHeight: button_option.buttonHeight
        Layout.minimumWidth: button_option.buttonHeight
        onClicked: root_layout.setCurrentPage('audio_test')
    }


    Button{
        id: button_end_test
        text: qsTr("结束测试")
        font.pointSize: button_option.buttonTextSize
        Layout.minimumHeight: button_option.buttonHeight
        Layout.minimumWidth: button_option.buttonHeight
        onClicked: root_layout.setCurrentPage('home')
    }

}