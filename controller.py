from PySide6.QtCore import QObject, Slot
from PySide6.QtQml import QQmlImageProviderBase
from PySide6.QtQuick import QQuickImageProvider
import datetime
import json
import vars
# from data_service import config, repo
from service import image_utils, pic_builder, api, result_writer
import cv2
#from VideoCaptureThread import VideoCaptureThread

def captureVideoFromCamera():
    cap = cv2.VideoCapture(0,cv2.CAP_DSHOW)
    WIDTH = 1920
    HEIGHT = 1920
    FILENAME = r'f:\video\myvideo.avi'

    FPS = 24
    cap.set(cv2.CAP_PROP_FPS, 24)
    # 建议使用XVID编码,图像质量和文件大小比较都兼顾的方案
    fourcc = cv2.VideoWriter_fourcc(*'XVID')

    out = cv2.VideoWriter(FILENAME, fourcc=fourcc, fps=FPS,frameSize=(WIDTH,HEIGHT))

    if not cap.isOpened():
        print("Cannot open camera")
        exit()
    while True:
        # 逐帧捕获
        ret, frame = cap.read()
        # 如果正确读取帧，ret为True
        if not ret:
            print("Can't receive frame (stream end?). Exiting ...")
            break
        frame = cv2.flip(frame, 1)  # 水平翻转
        ret = out.write(frame)
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        # 显示结果帧e
        cv2.imshow('frame', frame)
        if cv2.waitKey(1) == ord('q'):  break
    # 完成所有操作后，释放捕获器
    out.release()
    cap.release()
    cv2.destroyAllWindows()


def pic_nums():
    return [int(f) for f in [config.get_config("pos_pic_num"),
                             config.get_config("neu_pic_num"),
                             config.get_config("neg_pic_num")]]

"""
TestImageProvider用于（在main.py里）传递给前端，响应前端对于图片的请求
"""


class TestImageProvider(QQuickImageProvider):
    def requestImage(self, id, size, requestedSize):
        if id == "background":
            return vars.interval_background
        return vars.get_pic(int(id))


"""
TestController用于传递给前端，响应与测试有关的前端请求（比如作答和测试开始图片初始化，除图片的传递）
"""


class TestController(QObject):
    # def __init__(self):
    #     super().__init__()
    #     # config.read_config()
    #     # repo.pics_with_mark = pic_builder.build_pics(
    #     #     *pic_nums(), if_allowed_pics_dup=config.get_config("if_allowed_pics_dup"),
    #     #     if_same_neu_pic_for_background=config.get_config("if_same_neu_pic_for_background"))
    #     # print(repo.pics_with_mark)

    @Slot(int, str, int)
    def mark(self, pic_index, usertag, duration):
        """
        保存用户对于图片的选择，以及做出选择的时长
        """
        vars.mark(pic_index, usertag, duration)
        if config.get_config("if_use_api"):
            api.mark(1)

    @Slot()
    def turn_start(self):
        """
        每轮图片开始的时候进行打标
        """
        if config.get_config("if_use_api"):
            api.mark(0)

    @Slot(str)
    def begin_test(self, username):
        """
        点击开始测试按钮触发此函数，保存当前时间、用户名，构建图片传递并保存至repo（TestImageProvider从那里取图片），调用api
        :param username: 用户输入的用户名
        """
        config.read_config()
        vars.test_time = datetime.datetime.now()
        vars.username = username
        # config.read_config()
        # 构建并保存图片(根据设置选择图片源)
        vars.pics_with_mark = image_utils.read_images(*pic_nums(),
                                                   if_allowed_pics_dup=config.get_config("if_allowed_pics_dup")) \
            if config.get_config("if_use_en_pics") \
            else pic_builder.build_pics_consider_gender(
                *pic_nums(), if_allowed_pics_dup=config.get_config("if_allowed_pics_dup"),
                if_same_neu_pic_for_background=config.get_config("if_same_neu_pic_for_background"),
                if_same_neu_pic_for_neu=config.get_config("if_same_neu_pic_for_neu"))
        # 构建并保存背景
        vars.interval_background = pic_builder.build_background_pic(
            *(lambda x: [x.size(), x.format()])(vars.get_pic(0)), config.get_config("background_color"))
        # print(test_image_provider.requestImage("1",None,None))
        # 调用api
        if config.get_config("if_use_api"):
            api.start()

        # captureVideoFromCamera()

        # video_source = 0  # 0 for webcam, or path to video file
        # output_file = 'output.avi'
        # capture_thread = VideoCaptureThread(video_source, output_file)
        # capture_thread.setDaemon(True)
        # capture_thread.start()




    @Slot()
    def end_test(self):
        """
        测试结束时触发此函数，调用服务将结果写入磁盘
        :rtype: object
        """
        result_writer.save_result(vars.username, vars.test_time.strftime('%Y-%m-%d %H:%M:%S'), vars.pics_with_mark,
                                 if_ch_contents=config.get_config("if_ch_contents"),
                                 if_ch_header=config.get_config("if_ch_headers"))


"""
ConfigController，用于响应与设置配置有关的前端请求
"""


# @QmlElement
class ConfigController(QObject):
    @Slot(str, result="QVariant")
    def get_config(self, key):
        return vars.config[key]

    @Slot(str, result="QString")
    def get_default_configs(self, section):
            return json.dumps(dict(vars.config['DEFAULT'][section]))

    @Slot(str, result="QString")
    def get_configs(self, section):
            return json.dumps(dict(vars.config[section]))

    @Slot(str)
    def set_configs(self, edited_config_json):
        ...
        # repo.config.set_configs(json.loads(edited_config))
        # config.save_config()

class Controller(QObject):
    ...


test_image_provider = TestImageProvider(QQmlImageProviderBase.Image)
test_controller = TestController()
config_controller = ConfigController()
