import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

import "page"
// import QtQuick.Controls.Material 2.2

Window {

    // Material.theme: Material.Light

    id:root
    width: 800
    height: 600
    visible: true
    title: qsTr("DepressionTest")
    minimumWidth: 640
    minimumHeight: 480



//     function begin_test(){
// //        $test.begin_test(username)
//         // start_view.visible = false
//         // option_main.visible = true
// //        test_view.visible = true
// //        test_view.begin_test()

//     }
//     function end_test(){
//         $test.end_test()
//         test_view.visible = false
// //        result_view.visible = true
//         option_main.visible = true
//     }

// state: 'home'
// states: [
//     State {
//         name: 'home'
//         PropertyChanges { target: main_stackview; currentIndex: 0}
//     },
//     State {
//         name: 'option'
//         PropertyChanges { target: main_stackview; currentIndex: 1}
//     },
//     State {
//         name: 'settings'
//         PropertyChanges { target: main_stackview; currentIndex: 2}
//     },
//     State {
//         name: 'image_test'
//         PropertyChanges { target: main_stackview; currentIndex: 3}
//     },
//     State {
//         name: 'audio_test'
//         PropertyChanges { target: main_stackview; currentIndex: 4}
//     }
// ]

    StackLayout {
        id: root_layout
        // anchors.left: parent.left
        // anchors.right: parent.right
        // anchors.top: parent.top
        // anchors.bottom: parent.bottom
        anchors.fill: parent

        function setCurrentPage(value){
            currentIndex = ['home','option','settings','image_test','audio_test'].indexOf(value)
            // console.log(Object.values(root_layout.children) )
            // console.log(currentIndex)
        }

        HomePage {
        }

        OptionPage {
        }

        SettingsPage {
        }

        ImageTestPage {
        }

        AudioTestPage {
        }
    }


//     Loader {
//         id: settings_window_loader
//         active: false
//         sourceComponent: SettingsWindow{
//             minimumWidth: 640
//             minimumHeight: 480
//             maximumHeight: minimumHeight
//             maximumWidth: minimumWidth
//             id:settings_window
//             visible: true
//             onClosing: settings_window_loader.active = false
//         }
//     }

//     Loader {
//         id: main_loader
//         anchors.left: parent.left
//         anchors.right: parent.right
//         anchors.top: parent.top
//         anchors.bottom: analogButton.top
//         onLoaded: {
//             binder.target = main_loader.item;
//         }
//     }

//     ColumnLayout{
//         id: start_view
//         visible: true
//         spacing: 20
//         width: 480
//         height: 120
//         anchors.verticalCenter: parent.verticalCenter
//         anchors.horizontalCenter: parent.horizontalCenter


//         Button {
//             id: button_start
//             text: qsTr("开始测试")
//             Layout.preferredWidth: 200
//             Layout.preferredHeight: 40
//             font.pointSize: 14
//             Layout.alignment: Qt.AlignHCenter
//             onClicked: root.begin_test()
//         }
//         Button {
//             id: button_settings
//             text: qsTr("设置")
//             Layout.preferredWidth: 200
//             Layout.preferredHeight: 40
//             font.pointSize: 14
//             Layout.alignment: Qt.AlignHCenter
//             onClicked: settings_window_loader.active = true
//         }
//         PromptTextInput{
//             id: name_layout
//             Layout.alignment: Qt.AlignHCenter
//             pointSize: 14
//             inputHeight: 34
//             inputWidth: 120
//             textPrompt.text: qsTr("姓名：")
//             textInput.text: username
//         }
//     }


}
