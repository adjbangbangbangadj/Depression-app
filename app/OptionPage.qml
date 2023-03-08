import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Dialogs


import "style"
import Main

Control{
    ColumnLayout {
        TestMainStyle{ id: testMainStyle }
        id: option_page

        width: testMainStyle.mainLayoutWidth
        height: testMainStyle.optionLayoutHeight
        spacing: testMainStyle.mainLayoutSpacing
        anchors.centerIn: parent

        property bool if_image_tested: test_root.completed_tests.indexOf('image_test') !== -1
        property bool if_audio_tested: test_root.completed_tests.indexOf('audio_test') !== -1

        Button{
            id: button_image_test
            text: qsTr("图片测试")
            font.pointSize: testMainStyle.titlePointSize
            Layout.preferredHeight: testMainStyle.mainButtonHeight
            Layout.preferredWidth: testMainStyle.mainButtonWidth
            Layout.alignment:Qt.AlignHCenter
            enabled: !option_page.if_image_tested
            onClicked: test_root.setCurrentPage('image_test')

        }
        Button{
            id: button_record_test
            text: qsTr("语音测试")
            font.pointSize: testMainStyle.titlePointSize
            Layout.preferredHeight: testMainStyle.mainButtonHeight
            Layout.preferredWidth: testMainStyle.mainButtonWidth
            Layout.alignment:Qt.AlignHCenter
            enabled: !option_page.if_audio_tested
            onClicked: test_root.setCurrentPage('audio_test')
        }

        Button{
            id: button_end_test
            text: qsTr("结束测试")
            Layout.preferredHeight: testMainStyle.mainButtonHeight
            Layout.preferredWidth: testMainStyle.mainButtonWidth
            Layout.alignment:Qt.AlignHCenter
            font.pointSize: testMainStyle.titlePointSize
            onClicked: {
                if ($config.general__if_confirm_before_test_end &&
                    test_root.uncompleted_tests.length !== 0)
                    confirm_test_end_dialog.visible = true
                else
                    root.setCurrentPage('home')
            }
        }

        Item{ //work like QSpacerItem
            Layout.fillHeight: true
        }

        MessageDialog {
            id: confirm_test_end_dialog
            title: qsTr("是否结束测试?")
            text:  qsTr(`还有${format(test_root.uncompleted_tests)}未完成`)

            function format(tests) {
                const testname_en2ch = {
                    'image_test': '图片测试',
                    'audio_test': '语音测试'
                };
                tests = tests.map(i => testname_en2ch[i])
                switch (tests.length) {
                    case 0:
                    return null;
                    case 1:
                    return tests[0];
                    case 2:
                    return tests.join('和');
                    default:
                    return tests.slice(0, -1).join(',') + '和' + tests.slice(-1);
                }
            }
            buttons: MessageDialog.Ok | MessageDialog.Cancel
            onButtonClicked: function (button, role) {
                if (button === MessageDialog.Ok)
                    root.setCurrentPage('home')
            }
        }
    }
}
