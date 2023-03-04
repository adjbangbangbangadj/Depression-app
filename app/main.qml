import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Layouts 2.15

Window {
    id: root
    visible: true
    title: qsTr("DepressionTester")

    width: 800
    height: 600
    minimumWidth: 640
    minimumHeight: 480

    StackLayout {
        id: root_layout
        anchors.fill: parent

        function setCurrentPage(value){
            currentIndex = ['home','option','settings','image_test','audio_test'].indexOf(value)
        }

        HomePage {}
        OptionPage {}
        SettingsPage {}
        ImageTestPage {}
        AudioTestPage {}
    }
}
