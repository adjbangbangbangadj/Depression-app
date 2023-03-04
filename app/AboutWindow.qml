import QtQuick 2.15

Window {
    title: "About"
    minimumWidth: 300
    minimumHeight: 180
    maximumHeight: minimumHeight
    maximumWidth: minimumWidth
    Column {
        spacing: 10
        anchors.centerIn: parent

        Text {
            text: "Depression Tester 2.0"
            font.bold: true
            font.pointSize: 14
        }

        Text {
            text: "© 2023 Southeast University"
            font.pointSize: 14
        }
    }
}
