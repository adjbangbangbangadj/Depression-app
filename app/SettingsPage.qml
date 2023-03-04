import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15

import 'control'

Page{
    Style{id: settings_style}
    property bool need_combine_image : true
    QtObject{
        id: configs
        property string image_dataset: "CAPS"
        property int pos_image_num: 7
        property int neu_image_num: 6
        property int neg_image_num: 7
        property bool if_same_neu_image_for_neu:true
        property bool if_same_neu_image_for_background:true
        property bool if_allowed_images_dup:false
        property double answer_duration: 4.0
        property double interval_duration: 3.0
        property bool if_end_immediately_after_answer: true
        property string background_color: "black"
        property bool if_background_fill_view: false

    }

    property var confine:
    {
        "pos":70,
        "neu":70,
        "neg":70
    }

    function reset_configs_to_default(){
        attrs.configs = Object.assign({}, attrs.default_configs)
        update()
    }

    // function save_config(){
    //     $configs.end_edit(JSON.stringify(attrs.configs))
    // }


    header: RowLayout {
        TabBar {
            id: tabBar
            // width: parent.width
            TabButton {
                text: qsTr("图片测试设置")
                font.pointSize: settings_style.textPointSize
            }
            TabButton {
                text: qsTr("语音测试设置")
                font.pointSize: settings_style.textPointSize
            }
        }
        Item {}
    }

    StackLayout {
        // anchors.top: parent.top
        // anchors.topMargin: 20
        anchors.fill: parent
        anchors.margins: settings_style.layoutMargins
        clip: true
        currentIndex: tabBar.currentIndex
        GridLayout {
            columns:2
            anchors.margins: 100
            columnSpacing: settings_style.horizontalSpacing
            Text {
                text: qsTr("图片数据集")
                font.pointSize: settings_style.textPointSize
            }
            ComboBox {
                id: comboBox_dataset
                textRole: "text"
                valueRole: "value"
                font.pointSize: settings_style.textPointSize
                implicitHeight: settings_style.boxHeight
                model: [
                    { value: "CAPS", text: qsTr("Chinese Affective Picture System") },
                    { value: "KDEF", text: qsTr("The Karolinska Directed Emotional Faces") },
                ]
                function change_relevant_components_visible(){
                    attrs.need_image_combine = currentValue == "KDEF"? false:true
                }
            }

            // Text {
            //     id: prompt_total_num
            //     font.pointSize: settings_style.textPointSize
            //     Component.onCompleted: attrs.comps_need_updated.push(prompt_total_num)
            //     function update(){
            //         attrs.configs["turn_num"] = attrs.configs["pos_image_num"]+attrs.configs["neu_image_num"]+attrs.configs["neg_image_num"]
            //         prompt_total_num.text = qsTr(`总图片数${attrs.configs["turn_num"] }`)
            //     }
            // }
            // Item {}
            Text {
                text: qsTr("积极图片数")
                font.pointSize: settings_style.textPointSize
            }
            SpinBox{
                id: spinBox_pos_num
                font.pointSize: settings_style.textPointSize
                implicitWidth: settings_style.boxWidth
                implicitHeight: settings_style.boxHeight
                editable:true
                from:0; to:confine["pos"]
                value: configs.pos_image_num
            }
            Text {
                text: qsTr("中性图片数")
                font.pointSize: settings_style.textPointSize
            }
            SpinBox{
                id: spinBox_neu_num
                font.pointSize: settings_style.textPointSize
                implicitWidth: settings_style.boxWidth
                implicitHeight: settings_style.boxHeight
                editable:true
                from:0; to:confine["neu"]
                value: configs.neu_image_num
            }
            Text {
                text: qsTr("消极图片数")
                font.pointSize: settings_style.textPointSize
            }
            SpinBox{
                id: spinBox_neg_num
                font.pointSize: settings_style.textPointSize
                implicitWidth: settings_style.boxWidth
                implicitHeight: settings_style.boxHeight
                editable:true
                from:0; to:confine["neg"]
                value: configs.neg_image_num
            }
            Text {
                text: qsTr("在组合图片时使用相同的三张中性图片")
                font.pointSize: settings_style.textPointSize
            }
            CheckBox {
                id: checkBox_if_same_neu_image_for_background
                visible: need_combine_image
                font.pointSize: settings_style.textPointSize
                implicitHeight: settings_style.checkBoxHeight
                checked: configs.if_same_neu_image_for_background
            }
            Text {
                text: qsTr("在组合中性测试图片时使用相同的四张中性图片")
                font.pointSize: settings_style.textPointSize
            }
            CheckBox {
                id: checkBox_if_same_neu_image_for_neu
                visible: need_combine_image
                font.pointSize: settings_style.textPointSize
                implicitHeight: settings_style.checkBoxHeight
                checked: configs.if_same_neu_image_for_neu
            }
            Text {
                text: qsTr("允许图片重复")
                font.pointSize: settings_style.textPointSize
            }
            CheckBox {
                id: checkBox_if_allowed_images_dup
                font.pointSize: settings_style.textPointSize
                implicitHeight: settings_style.checkBoxHeight
                checked: configs.if_allowed_images_dup
            }
            Text {
                text: qsTr("每张图片作答时长（单位秒）")
                font.pointSize: settings_style.textPointSize
            }
            DoubleSpinBox{
                id: input_answer_duration
                implicitWidth: settings_style.boxWidth
                implicitHeight: settings_style.boxHeight
                font.pointSize: settings_style.textPointSize
                doubleValue: configs.answer_duration
            }
            Text {
                text: qsTr("两张图片间隔时长（单位秒）")
                font.pointSize: settings_style.textPointSize
            }
            DoubleSpinBox{
                id: input_interval_duration
                implicitWidth: settings_style.boxWidth
                implicitHeight: settings_style.boxHeight
                font.pointSize: settings_style.textPointSize
                doubleValue: configs.interval_duration
            }
            Text {
                text: qsTr("在图片作答后立刻结束对该图片的作答")
                font.pointSize: settings_style.textPointSize
            }
            CheckBox {
                id: checkBox_if_end_immediately
                font.pointSize: settings_style.textPointSize
                implicitHeight: settings_style.checkBoxHeight
                checked:configs.if_end_immediately_after_answer
            }
            // Text {
            //     text: qsTr("背景颜色")
            //     font.pointSize: settings_style.textPointSize
            // }
            // PromptTextInput{
            //     id: input_background_color
            //     pointSize: settings_style.textPointSize
            //     inputWidth: settings_style.normalInputWidth
            //     Component.onCompleted: attrs.comps_need_updated.push(input_background_color)
            //     textPrompt.text: qsTr("")
            //     textInput.onEditingFinished:  attrs.configs["background_color"] = textInput.text
            //     function update(){textInput.text = attrs.configs["background_color"]}
            // }
        }

        GridLayout {
            columns:2
            columnSpacing: settings_style.horizontalSpacing

            Text {
                text: qsTr("题目顺序随机")
                font.pointSize: settings_style.textPointSize
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
            font.pointSize: settings_style.textPointSize
            text: qsTr("恢复默认值")
            onClicked: {
                console.log('t')
                for (var prop in configs) {
                    print(prop += " (" + typeof(configs[prop]) + ") = " + configs[prop]);
                }
            }
        }
        Button {
            id: button_cancel
            font.pointSize: settings_style.textPointSize
            text: qsTr("取消")
            onClicked: root_layout.setCurrentPage('home')
        }
        Button {
            id: button_save
            font.pointSize: settings_style.textPointSize
            text: qsTr("确定")
            onClicked: {save_config(); root_layout.setCurrentPage('home')}
        }
    }
}

