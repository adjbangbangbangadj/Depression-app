import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Dialogs

import 'control'

Page{
    // property path
    Style {id:home_style}
    header: MenuBar {
        font.pointSize: home_style.textPointSize
        Menu {
            title: qsTr("文件")
            font.pointSize: home_style.textPointSize
            Action { text: qsTr("打开结果目录"); onTriggered: $file_utils.open_results_dir()}
            Action { text: qsTr("打开日志目录"); onTriggered: $file_utils.open_log_dir()}
            Action { text: qsTr("打开数据目录"); onTriggered: $file_utils.open_data_dir()}
        }
        Menu {
            title: qsTr("设置")
            font.pointSize: home_style.textPointSize
            Action { text: qsTr("设置"); onTriggered: root.setCurrentPage('settings')}
            MenuSeparator {}
            Action { text: qsTr("导出设置"); onTriggered: export_file_dialog.open()}
            Action { text: qsTr("载入设置"); onTriggered: import_file_dialog.open()}
        }
        Menu {
            title: qsTr("关于")
            font.pointSize: home_style.textPointSize
            // Action { text: qsTr("关于"); onTriggered: aboutwindow_loader.active = true}
            Action { text: qsTr("关于"); onTriggered: aboutwindow.visible = true}
        }
    }
    FileDialog {
        id: export_file_dialog
        fileMode: FileDialog.SaveFile
        nameFilters: ["Configuration files (*.ini)"]
        currentFolder: $config.get_configs_dir()
        onAccepted: $config.export_configs(export_file_dialog.selectedFile)
    }
    FileDialog {
        id: import_file_dialog
        fileMode: FileDialog.OpenFile
        nameFilters: ["Configuration files (*.ini)"]
        currentFolder: $config.get_configs_dir()
        onAccepted: $config.import_configs(import_file_dialog.selectedFile)
    }
    // MessageDialog {
    //     id:aboutwindow
    //     title: "Depression Tester 2.0"
    //     text: "© 2023 Southeast University"
    //     // text.font.pointSize: home_style.textPointSize
    //     buttons: MessageDialog.Ok
    // }
    MessageDialog {
        id:aboutwindow
        title: "Depression Tester 2.0"
        text: "© 2023 Southeast University"
        // text.font.pointSize: home_style.textPointSize
        buttons: MessageDialog.Ok
    }
    // Loader {
    //     id: aboutwindow_loader
    //     active: false
    //     sourceComponent: AboutWindow{
    //         id: settings_window
    //         visible: true
    //         onClosing: aboutwindow_loader.active = false
    //     }
    // }
            // text: "Depression Tester 2.0"
            // font.bold: true
            // font.pointSize: 14
            // text: "© 2023 Southeast University"
            // font.pointSize: 14
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
            font.pointSize: home_style.titlePointSize
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                root.setCurrentPage('option')
                $test_manager.test_start(name_input.text)
            }
        }

        PromptTextInput{
            id: name_input
            Layout.alignment: Qt.AlignHCenter
            pointSize: home_style.titlePointSize
            inputHeight: 34
            inputWidth: 120
            textPrompt.text: qsTr("姓名：")
        }
    }
}
