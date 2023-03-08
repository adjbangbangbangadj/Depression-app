import QtQuick 2.15
import QtQuick.Window 2.15
// import QtQuick.Controls.Basic     2.12
// import QtQuick.Controls.Fusion    2.12
// import QtQuick.Controls.Imagine   2.12
// import QtQuick.Controls.Material  2.12
// import QtQuick.Controls.Universal 2.12
// import QtQuick.Controls.Windows   2.12

Window {
    id: root
    visible: true
    title: qsTr("DepressionTester")

    width: 800
    height: 600
    minimumWidth: 640
    minimumHeight: 480

    property string username: ''

    function setCurrentPage(name){
        const pages = {
            'home'      :'HomePage.qml',
            'test'      :'TestMain.qml',
            'settings'  :'SettingsPage.qml'
        }
        main_page_loader.source = pages[name]
    }

    Loader {
        id: main_page_loader
        anchors.fill:parent
        // active: true
        source: 'HomePage.qml'
        // sourceComponent: Window{
            // id: settings_window
            // visible: true
            // onClosing: Loader.active = false
        // }
    }

    // StackLayout {
    //     id: root
    //     anchors.fill: parent

    //     function setCurrentPage(value){
    //         currentIndex = ['home','option','settings','image_test','audio_test'].indexOf(value)
    //     }

    //     HomePage {}
    //     OptionPage {}
    //     SettingsPage {}
    //     ImageTestPage {}
    //     AudioTestPage {}
    // }
}
