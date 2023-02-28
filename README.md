# DepressionApp

A PySide2 project developed for depression check.

## 配置环境

需要python3.8或者3.9（之前的版本可能也行，但是没有测试过）

安装如下pyserial和pyside2两个库，在终端中执行

    pip install pyserial
    pip install pyside2

使用任一编辑器作为python项目打开（本项目使用lntellij IDEA开发），main函数在main.py中。

qml文件可以使用QtCreator编辑。qml语法大致与JavaScript一致。调试前端最好用控制台运行程序，因为在lntellij里运行qml的报错信息是不会被显示的。

## 项目结构

    ├── data_service    // 后端运行时的数据由该模块管理（不负责保存到磁盘上）
    │    └── config.py              // 管理设置相关数据
    │    └── repo.py                // 管理其他所有数据，如图片、用户名等
    ├── qml             // 前端
    │    └── main.qml               // 主窗口
    │    └── SettingsWindow.qml     // 设置窗口
    │    └── TestView.qml           // 测试时的界面
    │    └── PromptTextInput.qml    // 辅组的一个组件，不重要
    ├── service         // 该模块提供无状态的服务
    │    └── pic_builder.py         // 提供图片的读取和处理（拼接）功能，返回前端显示的图片，用于中国表情库
    │    └── pic_reader.py          // 提供图片的读取（不拼接）功能，用于之前的表情库
    │    └── result_saver.py        // 提供结果保存功能
    │    └── api.py                 // 提供调用api的函数
    ├── neuracle_lib    // api依赖的库，由工程师提供
    ├── images          // 图片储存的文件夹 
    ├── results         // 结果保存的文件夹
    ├── config.json     // 设置保存在该文件中
    ├── controller.py   // 控制器，响应用户输入，是后端的主要逻辑所在
    ├── main.py         // 程序的入口，连接前后端
    ├── path.py         // 提供程序运行绝对路径的util组件，不重要

大致由四个部分组成：前端qml、控制器controller.py、无状态服务service和数据管理服务data_service。

它们的关系是：控制器响应前端请求，发送相应信息给前端，并且根据请求调用无状态服务service以及数据管理服务data_service。

详细信息请查看代码注释。

### 前端qml

前端负责用户界面的逻辑，包括根据时长显示不同图片，接受用户的输入传递至后端等。目前**快捷键是积极：数字键1、中性：数字键2、消极：数字键3**，数字小键盘和字母上方的数字按键都可以。快捷键可以在TestView.qml中修改。

### 无状态服务service

无状态在这里意味着对于每一次调用，只要函数的参数相同，结果几乎是相同的（第一随机选择的图片虽然不同但是性质相同；第二这里要求外部条件一样，即磁盘中的图片以及串口等等不变）。所以对于使用service里面的功能，每一次都需要传递所有配置中的参数（比如if_same_neu_pic_for_background，图片数等）。这样在调用service模块时不需要考虑它的状态，程序更简单了。

#### pic_reader.py和pic_builder.py

因为之前的KDEF&AKDEF表情库每张拼接过后的图片都是一个人的，表情按个人划分没有多少随机拼接的，所以直接手动拼接了。用pic_reader.py读取。

中国化面孔表情库由本程序动态拼接，使用pic_builder.py。

**可以在设置里修改使用哪一个表情库，如果使用KDEF&AKDEF表情库，关于图片拼接的设置将不会发挥作用。**

### 数据管理服务data_service

相当于把后端程序中的状态（或者说controller中的变量）全部提取出来，统一存储管理。数据集中在一起而不是分散在各个逻辑的上下文中，清晰。

## API

service/api.py是仿造API.py源码.zip中example_send_trigger.py写的，但是由于没有可用的串口无法进行运行或者测试。所以**为了运行项目，已将对api的调用关闭，如需使用在运行后软件的设置的第2页可以打开。（按下开始测试按钮时调用api）** 恢复默认设置后对api的调用是打开的。

在用户按下开始测试按钮时会调用service/api.py中的start函数（见api.py文件）。而api.py本身依赖工程师提供的neuracle_lib/triggerBox.py。

**测试开始时对数据打0，图片显示对数据打1，选择做答对数据打0**

如果需要对于api进行修改，理论上只改动service/api.py即可。


## 打包至exe文件

安装pyinstaller，在终端中执行

    pip install pyinstaller

在项目的根目录下打开终端，运行

    pyinstaller -w -D main.py

打包后的应用程序在根目录/dist/main下，main.exe为可执行程序。

**将代码根目录下的image文件夹，qml文件夹，以及config.json文件拷贝至应用程序根目录后，main.exe才可以正常运行。**

可以修改main.exe的名字使其更醒目。