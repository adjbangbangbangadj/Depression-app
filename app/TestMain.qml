import QtQuick 2.15
import QtQuick.Controls 2.15

import Main

Item {
    id: test_root

    MainTester {
        id: main_tester
        Component.onCompleted: main_tester.test_start(root.username)
        Component.onDestruction: main_tester.test_end()
    }
    property var tests: JSON.parse(main_tester.get_tests())
    property var completed_tests: []
    property var uncompleted_tests: tests.filter(value => !completed_tests.includes(value))

    function setCurrentPage(name){
        const pages = {
            'option'    :'OptionPage.qml'   ,
            'image_test':'ImageTestPage.qml',
            'audio_test':'AudioTestPage.qml'
        }
        test_page_loader.source = pages[name]
    }


    Loader {
        id: test_page_loader
        anchors.fill:parent
        source: 'OptionPage.qml'
    }
}
