import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page{
    header: MenuBar {
        Menu {
            title: qsTr("文件")
            Action { text: qsTr("打开结果目录"); onTriggered: $file_utils.open_results_dir()}
            Action { text: qsTr("打开日志目录"); onTriggered: $file_utils.open_data_dir()}
            Action { text: qsTr("打开数据目录"); onTriggered: $file_utils.open_log_dir()}
        }
        Menu {
            title: qsTr("设置")
            Action { text: qsTr("设置"); onTriggered: root_layout.setCurrentPage('settings')}
            MenuSeparator {}
            Action { text: qsTr("导出设置") }
            Action { text: qsTr("载入设置") }
        }
        Menu {
            title: qsTr("关于")
            Action { text: qsTr("关于") }
        }
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
            onClicked: root_layout.setCurrentPage('option')
        }

        PromptTextInput{
            id: name_layout
            Layout.alignment: Qt.AlignHCenter
            pointSize: 14
            inputHeight: 34
            inputWidth: 120
            textPrompt.text: qsTr("姓名：")
            // textInput.text: username
        }
    }
}
