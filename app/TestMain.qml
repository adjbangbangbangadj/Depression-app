import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

import Main

Item {
    id: test_root


    function setCurrentPage(name){
        let pages = {
            'option'    :'OptionPage.qml'   ,
            'image_test':'ImageTestPage.qml',
            'audio_test':'AudioTestPage.qml'
        }
        test_page_loader.source = pages[name]
    }

    // function

    MainTester {
        id: main_tester
        Component.onCompleted: main_tester.test_start(root.username)
    }

    Loader {
        id: test_page_loader
        anchors.fill:parent
        source: 'OptionPage.qml'
    }


}
