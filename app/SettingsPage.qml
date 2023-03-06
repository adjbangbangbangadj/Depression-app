import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Dialogs

import 'control'
import 'style'

Page{
    property bool need_combine_image : true
    SettingsStyle{ id: settingsStyle }

    property var confine:{
        "pos":70,
        "neu":70,
        "neg":70
    }

    header: RowLayout {
        TabBar {
            id: tabBar
            TabButton {
                text: qsTr("常规设置")
                font.pointSize: settingsStyle.textPointSize
            }
            TabButton {
                text: qsTr("图片测试设置")
                font.pointSize: settingsStyle.textPointSize
            }
            TabButton {
                text: qsTr("语音测试设置")
                font.pointSize: settingsStyle.textPointSize
            }
        }
        Item {}
    }

    StackLayout {
        anchors.fill: parent
        anchors.leftMargin: 50
        anchors.rightMargin: 50
        anchors.topMargin: 20

        currentIndex: tabBar.currentIndex
        Item{
            GridLayout {
                columns:2
                width: settingsStyle.settingsLayoutWidth
                anchors.horizontalCenter: parent.horizontalCenter
                columnSpacing: settingsStyle.settingsHSpacing

                Item{Layout.preferredWidth : settingsStyle.settingsLayoutWidth / 2}
                Item{Layout.preferredWidth : settingsStyle.settingsLayoutWidth / 2}
                    // TODO:
                // Text {
                //     text: qsTr("窗口")
                //     font.pointSize: settingsStyle.textPointSize
                // }
                // CheckBox {
                //     id: checkBox_if_shuffle_questions
                //     enabled: false
                //     Layout.preferredHeight: settingsStyle.settingsBoxHeight
                //     // checked: $configs.audio_test__if_shuffle_questions
                // }
            }
        }
        Item{
            GridLayout {
                columns:2
                width: settingsStyle.settingsLayoutWidth
                anchors.horizontalCenter: parent.horizontalCenter
                columnSpacing: settingsStyle.settingsHSpacing

                Item{Layout.preferredWidth : settingsStyle.settingsLayoutWidth / 2}
                Item{Layout.preferredWidth : settingsStyle.settingsLayoutWidth / 2}
                Text {
                    text: qsTr("图片数据集")
                    font.pointSize: settingsStyle.textPointSize
                }
                ComboBox {
                    id: comboBox_dataset
                    textRole: "text"
                    valueRole: "value"
                    font.pointSize: settingsStyle.textPointSize
                    Layout.preferredHeight: settingsStyle.settingsBoxHeight
                    model: [
                        { value: "CAPS", text: qsTr("Chinese Affective Picture System") },
                        { value: "KDEF", text: qsTr("The Karolinska Directed Emotional Faces") },
                    ]
                    // function change_relevant_components_visible(){
                    //     attrs.need_image_combine = currentValue == "KDEF"? false:true
                    // }
                }

                // Text {
                //     id: prompt_total_num
                //     font.pointSize: settingsStyle.textPointSize
                //     Component.onCompleted: attrs.comps_need_updated.push(prompt_total_num)
                //     function update(){
                //         attrs.configs["turn_num"] = attrs.configs["pos_image_num"]+attrs.configs["neu_image_num"]+attrs.configs["neg_image_num"]
                //         prompt_total_num.text = qsTr(`总图片数${attrs.configs["turn_num"] }`)
                //     }
                // }
                // Item {}
                Text {
                    text: qsTr("积极图片数")
                    font.pointSize: settingsStyle.textPointSize
                }
                SpinBox{
                    id: spinBox_pos_num
                    font.pointSize: settingsStyle.textPointSize
                    Layout.preferredWidth: settingsStyle.settingsBoxWidth
                    Layout.preferredHeight: settingsStyle.settingsBoxHeight
                    editable:true
                    from:0; to:confine["pos"]
                    value: $configs.image_test__pos_image_num
                }
                Text {
                    text: qsTr("中性图片数")
                    font.pointSize: settingsStyle.textPointSize
                }
                SpinBox{
                    id: spinBox_neu_num
                    font.pointSize: settingsStyle.textPointSize
                    Layout.preferredWidth: settingsStyle.settingsBoxWidth
                    Layout.preferredHeight: settingsStyle.settingsBoxHeight
                    editable:true
                    from:0; to:confine["neu"]
                    value: $configs.image_test__neu_image_num
                }
                Text {
                    text: qsTr("消极图片数")
                    font.pointSize: settingsStyle.textPointSize
                }
                SpinBox{
                    id: spinBox_neg_num
                    font.pointSize: settingsStyle.textPointSize
                    Layout.preferredWidth: settingsStyle.settingsBoxWidth
                    Layout.preferredHeight: settingsStyle.settingsBoxHeight
                    editable:true
                    from:0; to:confine["neg"]
                    value: $configs.image_test__neg_image_num
                }
                Text {
                    text: qsTr("在组合图片时使用相同的三张中性图片")
                    font.pointSize: settingsStyle.textPointSize
                }
                CheckBox {
                    id: checkBox_if_same_neu_image_for_background
                    enabled: need_combine_image
                    Layout.preferredHeight: settingsStyle.settingsBoxHeight
                    checked: $configs.image_test__if_same_neu_image_for_background
                }
                Text {
                    text: qsTr("在组合中性测试图片时使用四张相同中性图片")
                    font.pointSize: settingsStyle.textPointSize
                }
                CheckBox {
                    id: checkBox_if_same_neu_image_for_neu
                    enabled: need_combine_image
                    Layout.preferredHeight: settingsStyle.settingsBoxHeight
                    checked: $configs.image_test__if_same_neu_image_for_neu
                }
                Text {
                    text: qsTr("允许图片重复")
                    font.pointSize: settingsStyle.textPointSize
                }
                CheckBox {
                    id: checkBox_if_allowed_images_dup
                    Layout.preferredHeight: settingsStyle.settingsBoxHeight
                    checked: $configs.image_test__if_allowed_images_dup
                }
                Text {
                    text: qsTr("每张图片作答时长（单位秒）")
                    font.pointSize: settingsStyle.textPointSize
                }
                DoubleSpinBox{
                    id: input_answer_duration
                    Layout.preferredWidth: settingsStyle.settingsBoxWidth
                    Layout.preferredHeight: settingsStyle.settingsBoxHeight
                    font.pointSize: settingsStyle.textPointSize
                    doubleValue: $configs.image_test__answer_duration
                }
                Text {
                    text: qsTr("两张图片间隔时长（单位秒）")
                    font.pointSize: settingsStyle.textPointSize
                }
                DoubleSpinBox{
                    id: input_interval_duration
                    Layout.preferredWidth: settingsStyle.settingsBoxWidth
                    Layout.preferredHeight: settingsStyle.settingsBoxHeight
                    font.pointSize: settingsStyle.textPointSize
                    doubleValue: $configs.image_test__interval_duration
                }
                Text {
                    text: qsTr("在图片作答后立刻结束对该图片的作答")
                    font.pointSize: settingsStyle.textPointSize
                }
                CheckBox {
                    id: checkBox_if_end_immediately
                    Layout.preferredHeight: settingsStyle.settingsBoxHeight
                    checked: $configs.image_test__if_end_immediately_after_answer
                }
                Text {
                    text: qsTr("")
                    font.pointSize: settingsStyle.textPointSize
                }
                CheckBox {
                    id: checkBox_image_
                    Layout.preferredHeight: settingsStyle.settingsBoxHeight
                    checked: $configs.image_test__if_end_immediately_after_answer
                }
                // Text {
                //     text: qsTr("背景颜色")
                //     font.pointSize: settingsStyle.textPointSize
                // }
                // ColorDialog
                // TODO: color
                // TODO: video
            }
        }
        Item{
            GridLayout {
                columns:2
                width: settingsStyle.settingsLayoutWidth
                anchors.horizontalCenter: parent.horizontalCenter
                columnSpacing: settingsStyle.settingsHSpacing

                Item{Layout.preferredWidth : settingsStyle.settingsLayoutWidth / 2}
                Item{Layout.preferredWidth : settingsStyle.settingsLayoutWidth / 2}
                Text {
                    text: qsTr("随机题目顺序")
                    font.pointSize: settingsStyle.textPointSize
                }
                CheckBox {
                    id: checkBox_if_shuffle_questions
                    enabled: false
                    // TODO: enable
                    Layout.preferredHeight: settingsStyle.settingsBoxHeight
                    // checked: $configs.audio_test__if_shuffle_questions
                }
            }
                // TODO: video
        }

    }
    footer: RowLayout{
        Layout.alignment: Qt.AlignRight
        Item {
            Layout.fillWidth: true
        }
        // Button {
        //     id: button_reset
        //     font.pointSize: settingsStyle.textPointSize
        //     text: qsTr("恢复默认值")
        //     onClicked: {
        //         // for (var prop in configs) {
        //         //     print(prop += " (" + typeof(configs[prop]) + ") = " + configs[prop]);
        //         // }
        //     }
        // }
        //TODO
        Button {
            id: button_cancel
            font.pointSize: settingsStyle.textPointSize
            text: qsTr("取消")
            onClicked: root.setCurrentPage('home')
        }
        Button {
            id: button_save
            font.pointSize: settingsStyle.textPointSize
            text: qsTr("确定")
            onClicked: {$config.save_changes(); root.setCurrentPage('home')}
        }
    }
}

