import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


Window {
    id:root
    width: 800
    height: 600
    visible: true
    title: qsTr("DepressionTest")
    minimumWidth: 640
    minimumHeight: 480
    property string username: ""
    function begin_test(){
//        $test.begin_test(username)
        start_view.visible = false
        option_main.visible = true
        $test.new_folder()
//        test_view.visible = true
//        test_view.begin_test()

    }
    function end_image_test(){
        $test.end_image_test()
        test_view.visible = false
//        result_view.visible = true
        option_main.visible = true
    }
    SettingsWindow{
        id:settings_window
    }

    ColumnLayout{
        id: start_view
        visible: true
        spacing: 20
        width: 480
        height: 120
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter


        Button {
            id: button_start
            text: qsTr("开始测试")
            Layout.preferredWidth: 200
            Layout.preferredHeight: 40
            font.pointSize: 14
            Layout.alignment: Qt.AlignHCenter
            onClicked: root.begin_test()
        }
        Button {
            id: button_settings
            text: qsTr("设置")
            Layout.preferredWidth: 200
            Layout.preferredHeight: 40
            font.pointSize: 14
            Layout.alignment: Qt.AlignHCenter
            onClicked: settings_window.show()
        }
        PromptTextInput{
            id: name_layout
            Layout.alignment: Qt.AlignHCenter
            pointSize: 14
            inputHeight: 34
            inputWidth: 120
            textPrompt.text: qsTr("姓名：")
            textInput.text: username
        }
    }
//    GridLayout{
//        id: result_view
//        visible: false
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.verticalCenter: parent.verticalCenter

//        Text {
//            id: prompt_finish
//            text: qsTr("测试结束，请关闭程序")
//            font.pointSize: 14
//        }

//    }
    OptionMain{
        id: option_main
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 80

    }

    RecorderView{
        id:recorder_view
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 30
    }

    TestView{
        id: test_view
        visible: false
        anchors.fill: parent
        anchors.margins: 30
        onTestEnd: root.end_image_test()
    }



}
