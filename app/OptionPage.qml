import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

import "style"
import Main

Item{
    ColumnLayout {
        id: option_page
        TestMainStyle{ id: testMainStyle }

        width: testMainStyle.mainLayoutWidth
        height: testMainStyle.optionLayoutHeight
        spacing: testMainStyle.mainLayoutSpacing
        anchors.centerIn: parent

        // function button_record_click(){
        //     option_main.visible = false
        //     recorder_view.visible = true
        //     button_record_test.enabled = false
        // }

        // function button_image_click(){
        //     $test.begin_test(username)
        //     option_main.visible = false
        //     test_view.visible = true
        //     button_image_test.enabled = false
        //     test_view.begin_test()
        // }

        // function button_end_click(){

        // }

        Button{
            id: button_image_test
            text: qsTr("图片测试")
            font.pointSize: testMainStyle.titlePointSize
            Layout.preferredHeight: testMainStyle.mainButtonHeight
            Layout.preferredWidth: testMainStyle.mainButtonWidth
            Layout.alignment:Qt.AlignHCenter
            onClicked: test_root.setCurrentPage('image_test')

        }
        Button{
            id: button_record_test
            text: qsTr("语音测试")
            font.pointSize: testMainStyle.titlePointSize
            Layout.preferredHeight: testMainStyle.mainButtonHeight
            Layout.preferredWidth: testMainStyle.mainButtonWidth
            Layout.alignment:Qt.AlignHCenter
            onClicked: test_root.setCurrentPage('audio_test')
        }


        Button{
            id: button_end_test
            text: qsTr("结束测试")
            Layout.preferredHeight: testMainStyle.mainButtonHeight
            Layout.preferredWidth: testMainStyle.mainButtonWidth
            Layout.alignment:Qt.AlignHCenter
            font.pointSize: testMainStyle.titlePointSize
            // onClicked: root.setCurrentPage('home')
        }

        Item{ //work like QSpacerItem
            Layout.fillHeight: true
        }

    }
}
