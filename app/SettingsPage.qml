import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


Page{
    QtObject{
        id: style
        property int pointSize: 10
        property int layoutMargins: 10
        property int spacing: 8
        property int dirInputWidth: 200
        property int normInputWidth: 80
        property int spinBoxWidth: 120
        property int spinBoxHeight: 30
    }
    QtObject{
        id: attrs
        property var comps_need_updated: []
        property bool need_image_combine : true
        property var configs: {}
        property var default_configs:
        {
            "image_dataset":"Default",
            "if_use_api":true,
            "pos_image_num": 7,
            "neu_image_num": 6,
            "neg_image_num": 7,
            "if_same_neu_image_for_neu":true,
            "if_same_neu_image_for_background":true,
            "if_allowed_images_dup":false,
            "answer_duration": 4000,
            "interval_duration": 3000,
            "if_end_immediately_after_answer": true,
            "background_color": "black",
            "if_background_fill": false,
        }
    }

    property var confine:
    {
        "pos":70,
        "neu":70,
        "neg":70
    }

    function init(){
        console.log($config.get_configs())
        // attrs.configs = JSON.parse($config.get_configs())
        reset_configs_to_default()
        console.log(comps_need_updated)
        update()
    }

    function reset_configs_to_default(){
        attrs.configs = Object.assign({}, attrs.default_configs)
        update()
    }

    function update(){
        for(var i of attrs.comps_need_updated)
            i.update()
    }

    function save_config(){
        $config.end_edit(JSON.stringify(attrs.configs))
    }


        // anchors.fill: parent
        // anchors.margins: style.layoutMargins
    header: TabBar {
        id: tabBar
        width: parent.width
        TabButton {
            text: qsTr("图片测试")
            font.pointSize: style.pointSize
        }
        TabButton {
            text: qsTr("语音测试")
            font.pointSize: style.pointSize
        }
    }

    StackLayout {
        width: parent.width
        clip: true
        currentIndex: tabBar.currentIndex
        GridLayout {
            columns:2
            // Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Text {
                text: qsTr("图片数据集：")
                font.pointSize: style.pointSize
            }
            ComboBox {
                id: comboBox_dataset
                textRole: "text"
                valueRole: "value"
                Component.onCompleted: attrs.comps_need_updated.push(comboBox_dataset)
                onActivated: {
                    attrs.configs["image_dataset"] = currentValue
                    change_relevant_components_visible()
                }
                model: [
                    { value: "Default", text: qsTr("Default") },
                    { value: "KDEF&AKDEF", text: qsTr("KDEF&AKDEF") },
                ]
                function update(){
                    currentIndex = indexOfValue(attrs.configs["image_dataset"])
                    change_relevant_components_visible()
                }
                function change_relevant_components_visible(){
                    attrs.need_image_combine = currentValue == "KDEF&AKDEF"? false:true
                }
            }

            Text {
                id: prompt_total_num
                font.pointSize: style.pointSize
                Component.onCompleted: attrs.comps_need_updated.push(prompt_total_num)
                function update(){
                    attrs.configs["turn_num"] = attrs.configs["pos_image_num"]+attrs.configs["neu_image_num"]+attrs.configs["neg_image_num"]
                    prompt_total_num.text = qsTr(`总图片数：${attrs.configs["turn_num"] }`)
                }
            }
            Item {}
            Text {
                text: qsTr("积极图片数：")
                font.pointSize: style.pointSize
            }
            SpinBox{
                id: spinBox_pos_num

                font.pointSize: style.pointSize
                implicitWidth: style.spinBoxWidth
                implicitHeight: style.spinBoxHeight
                Component.onCompleted: attrs.comps_need_updated.push(spinBox_pos_num)
                editable:true
                from:0; to:confine["pos"]
                onValueModified:{ attrs.configs["pos_image_num"] = parseInt(value); prompt_total_num.update()}
                function update(){value = attrs.configs["pos_image_num"]}
            }
            Text {
                text: qsTr("中性图片数：")
                font.pointSize: style.pointSize
            }
            SpinBox{
                id: spinBox_neu_num
                font.pointSize: style.pointSize
                implicitWidth: style.spinBoxWidth
                implicitHeight: style.spinBoxHeight
                Component.onCompleted: attrs.comps_need_updated.push(spinBox_neu_num)
                editable:true
                from:0; to:confine["neu"]
                onValueModified:{ attrs.configs["neu_image_num"] = parseInt(value); prompt_total_num.update()}
                function update(){value = attrs.configs["neu_image_num"]}
            }
            Text {
                text: qsTr("消极图片数：")
                font.pointSize: style.pointSize
            }
            SpinBox{
                id: spinBox_neg_num
                font.pointSize: style.pointSize
                implicitWidth: style.spinBoxWidth
                implicitHeight: style.spinBoxHeight
                Component.onCompleted: attrs.comps_need_updated.push(spinBox_neg_num)
                editable:true
                from:0; to:confine["neg"]
                onValueModified:{ attrs.configs["neg_image_num"] = parseInt(value); prompt_total_num.update()}
                function update(){value = attrs.configs["neg_image_num"]}
            }
            Text {
                text: qsTr("在测试图片中是否使用相同的三张中性图片")
                font.pointSize: style.pointSize
            }
            CheckBox {
                id: checkBox_if_same_neu_image_for_background
                visible: attrs.need_image_combine
                font.pointSize: style.pointSize
                Component.onCompleted: attrs.comps_need_updated.push(checkBox_if_same_neu_image_for_background)
                onCheckedChanged: attrs.configs["if_same_neu_image_for_background"] = checked
                function update(){checked = attrs.configs["if_same_neu_image_for_background"]}
            }
            Text {
                text: qsTr("在中性测试图片中是否使用相同的四张中性图片")
                font.pointSize: style.pointSize
            }
            CheckBox {
                id: checkBox_if_same_neu_image_for_neu
                visible: attrs.need_image_combine
                font.pointSize: style.pointSize
                Component.onCompleted: attrs.comps_need_updated.push(checkBox_if_same_neu_image_for_neu)
                onCheckedChanged: attrs.configs["if_same_neu_image_for_neu"] = checked
                function update(){checked = attrs.configs["if_same_neu_image_for_neu"]}
            }
            Text {
                text: qsTr("是否允许图片重复")
                font.pointSize: style.pointSize
            }
            CheckBox {
                id: checkBox_if_allowed_images_dup
                font.pointSize: style.pointSize
                Component.onCompleted: attrs.comps_need_updated.push(checkBox_if_allowed_images_dup)
                onCheckedChanged: attrs.configs["if_allowed_images_dup"] = checked
                function update(){checked = attrs.configs["if_allowed_images_dup"]}
            }
            Text {
                text: qsTr("每张图片作答时长（单位：秒）：")
                font.pointSize: style.pointSize
            }
            PromptTextInput{
                id: input_answer_duration
                pointSize: style.pointSize
                inputWidth: style.normInputWidth
                Component.onCompleted: attrs.comps_need_updated.push(input_answer_duration)
                textInput.validator: DoubleValidator{bottom:0}
                textInput.onEditingFinished: attrs.configs["answer_duration"] = parseFloat(textInput.text) *1000
                function update(){textInput.text = attrs.configs["answer_duration"] /1000}
            }
            Text {
                text: qsTr("两张图片间隔时长（单位：秒）：")
                font.pointSize: style.pointSize
            }
            PromptTextInput{
                id: input_interval_duration
                pointSize: style.pointSize
                inputWidth: style.normInputWidth
                Component.onCompleted: attrs.comps_need_updated.push(input_interval_duration)
                textInput.validator: DoubleValidator{bottom:0}
                textInput.onEditingFinished: attrs.configs["interval_duration"] = parseFloat(textInput.text) *1000
                function update(){textInput.text = attrs.configs["interval_duration"] /1000}
            }
            Text {
                text: qsTr("是否在图片作答后立刻结束对该图片的作答")
                font.pointSize: style.pointSize
            }
            CheckBox {
                id: checkBox_if_end_immediately
                font.pointSize: style.pointSize
                text: qsTr("是否在图片作答后立刻结束对该图片的作答")
                Component.onCompleted: attrs.comps_need_updated.push(checkBox_if_end_immediately)
                onCheckedChanged: attrs.configs.if_end_immediately_after_answer = checked
                function update(){checked = attrs.configs["if_end_immediately_after_answer"]}
            }
            Text {
                text: qsTr("背景颜色")
                font.pointSize: style.pointSize
            }
            PromptTextInput{
                id: input_background_color
                pointSize: style.pointSize
                inputWidth: style.normInputWidth
                Component.onCompleted: attrs.comps_need_updated.push(input_background_color)
                textPrompt.text: qsTr("")
                textInput.onEditingFinished:  attrs.configs["background_color"] = textInput.text
                function update(){textInput.text = attrs.configs["background_color"]}
            }

            // CheckBox {
            //     id: checkBox_if_use_api
            //     font.pointSize: style.pointSize
            //     text: qsTr("是否向neuracleAPI发送信号")
            //     Component.onCompleted: attrs.comps_need_updated.push(checkBox_if_use_api)
            //     onCheckedChanged: attrs.configs["if_use_api"] = checked
            //     function update(){checked = attrs.configs["if_use_api"]}
            // }
        }

        ColumnLayout{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: style.spacing
        }
    }
    footer: RowLayout{
        Layout.alignment: Qt.AlignRight
        Button {
            id: button_cancel
            font.pointSize: style.pointSize
            text: qsTr("取消")
            onClicked: root_layout.setCurrentPage('home')
        }
        Button {
            id: button_save
            font.pointSize: style.pointSize
            text: qsTr("确定")
            onClicked: {save_config(); root_layout.setCurrentPage('home')}
        }
    }
}

