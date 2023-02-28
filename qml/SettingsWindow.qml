import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
Window {
    minimumWidth: 420
    minimumHeight: 500
    maximumHeight: minimumHeight
    maximumWidth: minimumWidth
    title:qsTr("设置")
    onVisibilityChanged:
    {
        if(visible == true)
            init()
    }
    QtObject{
        id:style
        property int pointSize: 10
        property int layoutMargins: 10
        property int spacing: 8
        property int dirInputWidth: 200
        property int normInputWidth: 80
        property int spinBoxWidth: 120
        property int spinBoxHeight: 30
    }
    QtObject{
        id:attrs
        property var update_list: []
        property var configs:
        {
            "pos_pic_num": 7,
            "neu_pic_num": 6,
            "neg_pic_num": 7,
            "if_same_neu_pic_for_neu":true,
            "if_same_neu_pic_for_background":true,
            "if_allowed_pics_dup":false,
            "answer_duration": 4000,
            "interval_duration": 3000,
            "if_end_immediately_after_answer": true,
            "background_color": "black",
            "if_background_fill": false,
            "if_use_api":false,
            "if_use_en_pics":false
        }
        property var default_configs:
        {
            "pos_pic_num": 7,
            "neu_pic_num": 6,
            "neg_pic_num": 7,
            "if_same_neu_pic_for_neu":true,
            "if_same_neu_pic_for_background":true,
            "if_allowed_pics_dup":false,
            "answer_duration": 4000,
            "interval_duration": 3000,
            "if_end_immediately_after_answer": true,
            "background_color": "black",
            "if_background_fill": false,
            "if_use_api":true,
            "if_use_en_pics":false
        }
    }

    property var confine:
    {
        "pos":70,
        "neu":70,
        "neg":70
    }

    function init(){
        attrs.configs = JSON.parse($config.begin_edit())
        update()
    }

    function restore_default_config(){
        attrs.configs = Object.assign({}, attrs.default_configs)
        update()
    }

    function update(){
        for(var i of attrs.update_list)
            i.update()
    }
    function save_config(){
        $config.end_edit(JSON.stringify(attrs.configs))
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: style.layoutMargins
        TabBar {
            id: tabBar
            width: parent.width
            TabButton {
                text: qsTr("图片设置")
                font.pointSize: style.pointSize
            }
            TabButton {
                text: qsTr("其他设置")
                font.pointSize: style.pointSize
            }
        }

        StackLayout {
            width: parent.width
            currentIndex: tabBar.currentIndex
            ColumnLayout{
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                spacing: style.spacing
                // Text {
                //     text: qsTr("注:可以使用数字123键作为测试时的快捷键")
                //     font.pointSize: style.pointSize
                // }
                // Text {
                //     text: qsTr("各类图片数不能大于各类图片路径的图片数")
                //     font.pointSize: style.pointSize
                // }
                Text {
                    id: prompt_total_num
                    font.pointSize: style.pointSize
                    Component.onCompleted: attrs.update_list.push(prompt_total_num)
                    function update(){
                        attrs.configs["turn_num"] = attrs.configs["pos_pic_num"]+attrs.configs["neu_pic_num"]+attrs.configs["neg_pic_num"]
                        prompt_total_num.text = qsTr(`总图片数：${attrs.configs["turn_num"] }`)
                    }
                }

                RowLayout{
                    Text {text: qsTr("积极图片数：")
                        font.pointSize: style.pointSize}
                    SpinBox{
                        id: spinBox_pos_num

                        font.pointSize: style.pointSize
                        implicitWidth: style.spinBoxWidth
                        implicitHeight: style.spinBoxHeight
                        Component.onCompleted: attrs.update_list.push(spinBox_pos_num)
                        editable:true
                        from:0; to:confine["pos"]
                        onValueModified:{ attrs.configs["pos_pic_num"] = parseInt(value); prompt_total_num.update()}
                        function update(){value = attrs.configs["pos_pic_num"]}
                    }
                }
                RowLayout{
                    Text {text: qsTr("中性图片数：")
                        font.pointSize: style.pointSize}
                    SpinBox{
                        id: spinBox_neu_num
                        font.pointSize: style.pointSize
                        implicitWidth: style.spinBoxWidth
                        implicitHeight: style.spinBoxHeight
                        Component.onCompleted: attrs.update_list.push(spinBox_neu_num)
                        editable:true
                        from:0; to:confine["neu"]
                        onValueModified:{ attrs.configs["neu_pic_num"] = parseInt(value); prompt_total_num.update()}
                        function update(){value = attrs.configs["neu_pic_num"]}
                    }
                }
                RowLayout{
                    Text {text: qsTr("消极图片数：")
                        font.pointSize: style.pointSize}
                    SpinBox{
                        id: spinBox_neg_num
                        font.pointSize: style.pointSize
                        implicitWidth: style.spinBoxWidth
                        implicitHeight: style.spinBoxHeight
                        Component.onCompleted: attrs.update_list.push(spinBox_neg_num)
                        editable:true
                        from:0; to:confine["neg"]
                        onValueModified:{ attrs.configs["neg_pic_num"] = parseInt(value); prompt_total_num.update()}
                        function update(){value = attrs.configs["neg_pic_num"]}
                    }
                }
                CheckBox {
                    id: checkBox_if_same_neu_pic_for_background
                    font.pointSize: style.pointSize
                    Component.onCompleted: attrs.update_list.push(checkBox_if_same_neu_pic_for_background)
                    text: qsTr("在测试图片中是否使用相同的三张中性图片")
                    onCheckedChanged: attrs.configs["if_same_neu_pic_for_background"] = checked
                    function update(){checked = attrs.configs["if_same_neu_pic_for_background"]}
                }
                CheckBox {
                    id: checkBox_if_same_neu_pic_for_neu
                    font.pointSize: style.pointSize
                    Component.onCompleted: attrs.update_list.push(checkBox_if_same_neu_pic_for_neu)
                    text: qsTr("在中性测试图片中是否使用相同的四张中性图片")
                    onCheckedChanged: attrs.configs["if_same_neu_pic_for_neu"] = checked
                    function update(){checked = attrs.configs["if_same_neu_pic_for_neu"]}
                }
                CheckBox {
                    id: checkBox_if_allowed_pics_dup
                    font.pointSize: style.pointSize
                    Component.onCompleted: attrs.update_list.push(checkBox_if_allowed_pics_dup)
                    text: qsTr("是否允许图片重复")
                    onCheckedChanged: attrs.configs["if_allowed_pics_dup"] = checked
                    function update(){checked = attrs.configs["if_allowed_pics_dup"]}
                }
                CheckBox {
                    id: checkBox_if_use_en_pics
                    font.pointSize: style.pointSize
                    text: qsTr("是否使用KDEF&AKDEF表情库")
                    Component.onCompleted: attrs.update_list.push(checkBox_if_use_en_pics)
                    onCheckedChanged: attrs.configs["if_use_en_pics"] = checked
                    function update(){checked = attrs.configs["if_use_en_pics"]}
                }
            }

            ColumnLayout{
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                spacing: style.spacing
                PromptTextInput{
                    id: input_answer_duration
                    pointSize: style.pointSize
                    inputWidth: style.normInputWidth
                    Component.onCompleted: attrs.update_list.push(input_answer_duration)
                    textPrompt.text: qsTr("每张图片作答时长（单位：秒）：")
                    textInput.validator: DoubleValidator{bottom:0}
                    textInput.onEditingFinished: attrs.configs["answer_duration"] = parseFloat(textInput.text) *1000
                    function update(){textInput.text = attrs.configs["answer_duration"] /1000}
                }
                PromptTextInput{
                    id: input_interval_duration
                    pointSize: style.pointSize
                    inputWidth: style.normInputWidth
                    Component.onCompleted: attrs.update_list.push(input_interval_duration)
                    textPrompt.text: qsTr("两张图片间隔时长（单位：秒）：")
                    textInput.validator: DoubleValidator{bottom:0}
                    textInput.onEditingFinished: attrs.configs["interval_duration"] = parseFloat(textInput.text) *1000
                    function update(){textInput.text = attrs.configs["interval_duration"] /1000}
                }
                CheckBox {
                    id: checkBox_if_end_immediately
                    font.pointSize: style.pointSize
                    text: qsTr("是否在图片作答后立刻结束对该图片的作答")
                    Component.onCompleted: attrs.update_list.push(checkBox_if_end_immediately)
                    onCheckedChanged: attrs.configs.if_end_immediately_after_answer = checked
                    function update(){checked = attrs.configs["if_end_immediately_after_answer"]}
                }
                PromptTextInput{
                    id: input_background_color
                    pointSize: style.pointSize
                    inputWidth: style.normInputWidth
                    Component.onCompleted: attrs.update_list.push(input_background_color)
                    textPrompt.text: qsTr("背景颜色（#RRGGBB或英文）：")
                    textInput.text: attrs.configs["background_color"]
                    textInput.onEditingFinished:  attrs.configs["background_color"] = textInput.text
                    function update(){textInput.text = attrs.configs["background_color"]}
                }
                CheckBox {
                    id: checkBox_if_background_fill
                    font.pointSize: style.pointSize
                    text: qsTr("背景是否填满整个区域")
                    Component.onCompleted: attrs.update_list.push(checkBox_if_background_fill)
                    onCheckedChanged: attrs.configs["if_background_fill"] = checked
                    function update(){checked = attrs.configs["if_background_fill"]}
                }
                CheckBox {
                    id: checkBox_if_use_api
                    font.pointSize: style.pointSize
                    text: qsTr("是否send trigger to neuracle")
                    Component.onCompleted: attrs.update_list.push(checkBox_if_use_api)
                    onCheckedChanged: attrs.configs["if_use_api"] = checked
                    function update(){checked = attrs.configs["if_use_api"]}
                }
                //                CheckBox {
                //                    id: checkBox_if_ch_headers
                //                    font.pointSize: style.pointSize
                //                    text: qsTr("csv文件表头是否使用中文（否则英文）")
                //                    Component.onCompleted: attrs.update_list.push(checkBox_if_ch_headers)
                //                    onCheckedChanged: attrs.configs["if_ch_headers"] = checked
                //                    function update(){checked = attrs.configs["if_ch_headers"]}
                //                }
                //                CheckBox {
                //                    id: checkBox_if_ch_contents
                //                    font.pointSize: style.pointSize
                //                    text: qsTr("csv文件内容是否使用中文（否则英文）")
                //                    Component.onCompleted: attrs.update_list.push(checkBox_if_ch_contents)
                //                    onCheckedChanged: attrs.configs["if_ch_contents"] = checked
                //                    function update(){checked = attrs.configs["if_ch_contents"]}
                //                }

            }
        }
        RowLayout{
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            Button {
                id: button_restore_default
                font.pointSize: style.pointSize
                text: qsTr("恢复默认值")
                onClicked: restore_default_config()
            }
            Button {
                id: button_save
                font.pointSize: style.pointSize
                text: qsTr("确定")
                onClicked: {save_config();close()}
            }
            Button {
                id: button_cancel
                font.pointSize: style.pointSize
                text: qsTr("取消")
                onClicked: close()
            }
        }
    }
}

