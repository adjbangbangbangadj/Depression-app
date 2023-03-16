import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Dialogs

import 'control'
import 'style'
Control{
    Page{
        id: settings_root
        SettingsStyle{ id: settingsStyle }
        background : Rectangle {color: settingsStyle.background_color}
        width: parent.width * settingsStyle.pageHProportion
        height: parent.height * settingsStyle.pageVProportion
        anchors.centerIn:parent

        property bool combine_image_needed: $config.image_test__image_dataset === 'CAPS'
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
                    width: settingsStyle.tabButtonWidth
                }
                TabButton {
                    text: qsTr("图片测试设置")
                    font.pointSize: settingsStyle.textPointSize
                    width: settingsStyle.tabButtonWidth
                }
                TabButton {
                    text: qsTr("语音测试设置")
                    font.pointSize: settingsStyle.textPointSize
                    width: settingsStyle.tabButtonWidth
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

                    Text {
                        text: qsTr("是否在结束测试前弹出确认窗口")
                        font.pointSize: settingsStyle.textPointSize
                    }
                    CheckBox {
                        id: checkBox_if_confirm_before_test_end
                        Layout.preferredHeight: settingsStyle.settingsBoxHeight
                        checked: $config.general__if_confirm_before_test_end
                        onCheckedChanged: $config.general__if_confirm_before_test_end = checked
                    }
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
                        Component.onCompleted: currentIndex = indexOfValue($config.image_test__image_dataset)
                        currentIndex: indexOfValue($config.image_test__image_dataset) // not have effect
                        onActivated: $config.image_test__image_dataset = currentValue
                        model: [
                            { value: "CAPS", text: qsTr("Chinese Affective Picture System") },
                            { value: "KDEF", text: qsTr("The Karolinska Directed Emotional Faces") },
                        ]

                    }

                    Text {
                        id: prompt_total_num
                        font.pointSize: settingsStyle.textPointSize
                        text:qsTr(`总图片数: ${$config.image_test__pos_image_num+$config.image_test__neu_image_num+
                            $config.image_test__neg_image_num} `)
                    }

                    Text {
                        id: prompt_total_time
                        font.pointSize: settingsStyle.textPointSize
                        function format_time(total_time) {
                            const minutes = Math.floor(total_time / 60)
                            const seconds = Math.floor(total_time % 60 *100) /100 // 0.003 consider as 0
                            let formatted = '最大总时间:'
                            if (minutes !== 0)
                                formatted += ` ${minutes} 分钟`
                            if (seconds !== 0 || minutes === 0)
                                formatted += ` ${seconds} 秒`
                            return formatted;

                        }

                        text:qsTr(format_time(Math.max((($config.image_test__pos_image_num+
                            $config.image_test__neu_image_num+$config.image_test__neg_image_num)*
                            ($config.image_test__answer_duration+$config.image_test__interval_duration)-
                            $config.image_test__interval_duration)/1000,0)))
                    }
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
                        from: 0
                        to: settings_root.confine["pos"]
                        value: $config.image_test__pos_image_num
                        onValueModified:{ $config.image_test__pos_image_num = value}
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
                        from: 0
                        to: settings_root.confine["neu"]
                        value: $config.image_test__neu_image_num
                        onValueModified:{ $config.image_test__neu_image_num = value}
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
                        from: 0
                        to: settings_root.confine["neg"]
                        value: $config.image_test__neg_image_num
                        onValueModified:{ $config.image_test__neg_image_num = value}
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
                        editable:true
                        from: 1
                        value: $config.image_test__answer_duration
                        onValueModified: $config.image_test__answer_duration = value
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
                        editable: true
                        from: 1
                        value: $config.image_test__interval_duration
                        onValueModified: $config.image_test__interval_duration = value
                    }
                    Text {
                        text: qsTr("在图片作答后立刻结束对该图片的作答")
                        font.pointSize: settingsStyle.textPointSize
                    }
                    CheckBox {
                        id: checkBox_if_end_immediately
                        Layout.preferredHeight: settingsStyle.settingsBoxHeight
                        checked: $config.image_test__if_end_immediately_after_answer
                        onCheckedChanged: $config.image_test__if_end_immediately_after_answer = checked
                    }

                    Text {
                        text: qsTr("在组合图片时使用相同的三张中性图片")
                        font.pointSize: settingsStyle.textPointSize
                    }
                    CheckBox {
                        id: checkBox_if_same_neu_image_for_background
                        enabled: settings_root.combine_image_needed
                        Layout.preferredHeight: settingsStyle.settingsBoxHeight
                        checked: $config.image_test__if_same_neu_image_for_background
                        onCheckedChanged: $config.image_test__if_same_neu_image_for_background = checked
                    }
                    Text {
                        text: qsTr("在组合中性测试图片时使用四张相同中性图片")
                        font.pointSize: settingsStyle.textPointSize
                    }
                    CheckBox {
                        id: checkBox_if_same_neu_image_for_neu
                        enabled: settings_root.combine_image_needed
                        Layout.preferredHeight: settingsStyle.settingsBoxHeight
                        checked: $config.image_test__if_same_neu_image_for_neu
                        onCheckedChanged: $config.image_test__if_same_neu_image_for_neu = checked
                    }
                    Text {
                        text: qsTr("允许图片重复")
                        font.pointSize: settingsStyle.textPointSize
                    }
                    CheckBox {
                        id: checkBox_if_allowed_images_dup
                        Layout.preferredHeight: settingsStyle.settingsBoxHeight
                        checked: $config.image_test__if_allowed_images_dup
                        onCheckedChanged: $config.image_test__if_allowed_images_dup = checked
                    }


                    // Text {
                    //     text: qsTr("if_interval_background_fill_view")
                    //     font.pointSize: settingsStyle.textPointSize
                    // }
                    // CheckBox {
                    //     id: checkBox_if_interval_background_fill_view
                    //     Layout.preferredHeight: settingsStyle.settingsBoxHeight
                    //     checked: $config.image_test__if_interval_background_fill_view
                    // }
                    // Text {
                    //     text: qsTr("图片测试间隔时的背景颜色")
                    //     font.pointSize: settingsStyle.textPointSize
                    // }

                    // ColorDialog {
                    //     id: colorDialog
                    //     onAccepted: {$config.image_test__interval_background_color = color}
                    //     color: $config.image_test__interval_background_color
                    // }
                    // RowLayout{
                    //     Rectangle {
                    //         Layout.preferredHeight: parent.height
                    //         Layout.preferredWdith: parent.height * 1.8
                    //     }
                    //     Button {
                    //         text: "选择颜色"
                    //         anchors.centerIn: parent
                    //         onClicked: colorDialog.open()
                    //     }
                    // }

                    Text {
                        text: qsTr("是否在测试时录像")
                        font.pointSize: settingsStyle.textPointSize
                    }
                    CheckBox {
                        id: checkBox_if_record_video_in_image_test
                        Layout.preferredHeight: settingsStyle.settingsBoxHeight
                        checked: $config.image_test__if_record_video
                        onCheckedChanged: $config.image_test__if_record_video = checked
                    }

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
                        Layout.preferredHeight: settingsStyle.settingsBoxHeight
                        checked: $config.audio_test__if_shuffle_questions
                        onCheckedChanged: $config.audio_test__if_shuffle_questions = checked
                    }
                    Text {
                        text: qsTr("是否在测试时录像")
                        font.pointSize: settingsStyle.textPointSize
                    }
                    CheckBox {
                        id: checkBox_if_record_video_in_audio
                        Layout.preferredHeight: settingsStyle.settingsBoxHeight
                        checked: $config.audio_test__if_record_video
                        onCheckedChanged: $config.audio_test__if_record_video = checked
                    }
                }
            }

        }
        footer: RowLayout{
            Layout.alignment: Qt.AlignRight
            Item {
                Layout.fillWidth: true
            }
            Button {
                id: button_reset
                font.pointSize: settingsStyle.textPointSize
                Layout.preferredWidth: settingsStyle.settingsButtonWidth
                text: qsTr("恢复默认值")
                onClicked: $config.reset_to_default()
            }
            Button {
                id: button_cancel
                font.pointSize: settingsStyle.textPointSize
                Layout.preferredWidth: settingsStyle.settingsButtonWidth
                text: qsTr("取消")
                onClicked: {
                    $config.cancel_changes()
                    root.setCurrentPage('home')
                }
            }
            Button {
                id: button_save
                font.pointSize: settingsStyle.textPointSize
                Layout.preferredWidth: settingsStyle.settingsButtonWidth
                text: qsTr("确定")
                onClicked: {
                    if ($config.save_changes())
                        root.setCurrentPage('home')
                    else
                        config_save_failure_dialog.visible = true
                }
            }
            MessageDialog {
                id:config_save_failure_dialog
                title: qsTr("设置保存失败")
                text: qsTr(`查看日志获取详细错误信息`)
                buttons: MessageDialog.Ok
            }
        }
    }

}
