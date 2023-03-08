import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Dialogs

import 'control'
import 'style'

Page{
    HomeStyle { id:homeStyle }
    header: MenuBar {
        font.pointSize: homeStyle.textPointSize
        Menu {
            title: qsTr("文件")
            font.pointSize: homeStyle.textPointSize
            Action { text: qsTr("打开结果目录"); onTriggered: $file_utils.open_results_dir()}
            Action { text: qsTr("打开日志目录"); onTriggered: $file_utils.open_log_dir()}
            Action { text: qsTr("打开数据目录"); onTriggered: $file_utils.open_data_dir()}
        }
        Menu {
            title: qsTr("设置")
            font.pointSize: homeStyle.textPointSize
            Action { text: qsTr("设置"); onTriggered: root.setCurrentPage('settings')}
            MenuSeparator {}
            Action { text: qsTr("导出设置"); onTriggered: export_file_dialog.open()}
            Action { text: qsTr("载入设置"); onTriggered: import_file_dialog.open()}
        }
        Menu {
            title: qsTr("关于")
            font.pointSize: homeStyle.textPointSize
            // Action { text: qsTr("关于"); onTriggered: aboutwindow_loader.active = true}
            Action { text: qsTr("关于"); onTriggered: aboutwindow.visible = true}
        }
    }
    FileDialog {
        id: export_file_dialog
        fileMode: FileDialog.SaveFile
        nameFilters: ["Configuration files (*.ini)"]
        Component.onCompleted: currentFolder = $config.get_configs_dir()
        onAccepted: {
            if (!$config.export_configs(export_file_dialog.selectedFile)){
                export_failure_window.path = export_file_dialog.selectedFile
                export_failure_window.visible = true
            }
        }
    }
    FileDialog {
        id: import_file_dialog
        fileMode: FileDialog.OpenFile
        nameFilters: ["Configuration files (*.ini)"]
        Component.onCompleted: currentFolder = $config.get_configs_dir()
        onAccepted: {
            if (!$config.import_configs(import_file_dialog.selectedFile)){
                import_failure_window.path = import_file_dialog.selectedFile
                import_failure_window.visible = true
            }
        }
    }
    MessageDialog {
        id:export_failure_window
        property string path: ""
        title:  qsTr("设置导出失败")
        text: qsTr(`无法导出设置至${path}`)
        buttons: MessageDialog.Ok
    }
    MessageDialog {
        id:import_failure_window
        property string path: ""
        title: qsTr("设置导入失败")
        text: qsTr(`无法从${path}导入设置`)
        buttons: MessageDialog.Ok
    }
    MessageDialog {
        id:aboutwindow
        title: "Depression Tester 2.0"
        text: "© 2023 Southeast University"
        buttons: MessageDialog.Ok
    }
    // Loader {
    //     id: aboutwindow_loader
    //     active: false
    //     sourceComponent: MessageDialog{
    //         id:aboutwindow
    //         title: "Depression Tester 2.0"
    //         text: "© 2023 Southeast University"
    //         buttons: MessageDialog.Ok
    //         onButtonClicked: aboutwindow_loader.active = false
    //     }
    // }

    ColumnLayout{
        id: start_view
        visible: true
        spacing: homeStyle.mainLayoutSpacing
        width: homeStyle.mainLayoutWidth
        height: homeStyle.mainLayoutHeight
        anchors.centerIn: parent

        Button {
            id: button_start
            text: qsTr("开始测试")
            Layout.preferredWidth: homeStyle.mainButtonWidth
            Layout.preferredHeight: homeStyle.mainButtonHeight
            Layout.alignment: Qt.AlignHCenter
            font.pointSize: homeStyle.titlePointSize
            onClicked: root.setCurrentPage('test')
        }

        PromptTextInput{
            id: name_input
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: homeStyle.mainButtonWidth
            Layout.preferredHeight: homeStyle.mainButtonHeight
            pointSize: homeStyle.titlePointSize
            textPrompt.text: qsTr("姓名：")
            textInput.text: root.username
        }

        Item{ //work like QSpacerItem
            Layout.fillHeight: true
        }
    }
}
