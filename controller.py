import os
import time

from PySide2.QtCore import QObject, Slot
from PySide2.QtQml import QQmlImageProviderBase
from PySide2.QtQuick import QQuickImageProvider
import datetime
import json

import path
from data_service import config, repo
from service import result_saver, pic_builder, pic_reader, api
import cv2
from VideoCaptureThread import VideoCaptureThread
from Recorder import RecorderThread

# def captureVideoFromCamera():
#     cap = cv2.VideoCapture(0,cv2.CAP_DSHOW)
#     WIDTH = 1920
#     HEIGHT = 1920
#     FILENAME = r'f:\video\myvideo.avi'
#
#     FPS = 24
#     cap.set(cv2.CAP_PROP_FPS, 24)
#     # 建议使用XVID编码,图像质量和文件大小比较都兼顾的方案
#     fourcc = cv2.VideoWriter_fourcc(*'XVID')
#
#     out = cv2.VideoWriter(FILENAME, fourcc=fourcc, fps=FPS,frameSize=(WIDTH,HEIGHT))
#
#     if not cap.isOpened():
#         print("Cannot open camera")
#         exit()
#     while True:
#         # 逐帧捕获
#         ret, frame = cap.read()
#         # 如果正确读取帧，ret为True
#         if not ret:
#             print("Can't receive frame (stream end?). Exiting ...")
#             break
#         frame = cv2.flip(frame, 1)  # 水平翻转
#         ret = out.write(frame)
#         gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
#         # 显示结果帧e
#         cv2.imshow('frame', frame)
#         if cv2.waitKey(1) == ord('q'):  break
#     # 完成所有操作后，释放捕获器
#     out.release()
#     cap.release()
#     cv2.destroyAllWindows()


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
            return repo.interval_background
        return repo.get_pic(int(id))


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
        repo.mark(pic_index, usertag, duration)
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
    def begin_image_test(self, username):
        """
        点击开始测试按钮触发此函数，保存当前时间、用户名，构建图片传递并保存至repo（TestImageProvider从那里取图片），调用api
        :param username: 用户输入的用户名
        """


        config.read_config()

        repo.username = username
        # config.read_config()
        # 构建并保存图片(根据设置选择图片源)
        repo.pics_with_mark = pic_reader.init_pics(*pic_nums(),
                                                   if_allowed_pics_dup=config.get_config("if_allowed_pics_dup")) \
            if config.get_config("if_use_en_pics") \
            else pic_builder.build_pics_consider_gender(
                *pic_nums(), if_allowed_pics_dup=config.get_config("if_allowed_pics_dup"),
                if_same_neu_pic_for_background=config.get_config("if_same_neu_pic_for_background"),
                if_same_neu_pic_for_neu=config.get_config("if_same_neu_pic_for_neu"))
        # 构建并保存背景
        repo.interval_background = pic_builder.build_background_pic(
            *(lambda x: [x.size(), x.format()])(repo.get_pic(0)), config.get_config("background_color"))
        # print(test_image_provider.requestImage("1",None,None))
        # 调用api
        if config.get_config("if_use_api"):
            api.start()

        # captureVideoFromCamera()

        video_source = 0  # 0 for webcam, or path to video file
        output_file = './results/' + str(repo.test_time).replace(' ', '_').replace(':',".") + '/图片测试视频.avi'
        self.capture_thread = VideoCaptureThread(video_source, output_file)
        self.capture_thread.setDaemon(True)
        self.capture_thread.start()




    @Slot()
    def end_image_test(self):
        """
        测试结束时触发此函数，调用服务将结果写入磁盘
        :rtype: object
        """
        result_saver.save_result(repo.username, repo.test_time.strftime('%Y-%m-%d %H:%M:%S'), repo.pics_with_mark,
                                 if_ch_contents=config.get_config("if_ch_contents"),
                                 if_ch_header=config.get_config("if_ch_headers"))
        self.capture_thread.flag = False


    @Slot()
    def begin_record_test(self):

        video_source = 0
        output_file = './results/' + str(repo.test_time).replace(' ', '_').replace(':',".") + "/录音视频.avi"
        # output_file = repo.currentPath
        self.capture_thread = VideoCaptureThread(video_source,output_file)
        self.capture_thread.setDaemon(True)
        self.capture_thread.start()

    @Slot()
    def end_record_test(self):
        self.capture_thread.flag = False

    @Slot(int)
    def begin_record(self, num):

        output_file = './results/' + str(repo.test_time).replace(' ', '_').replace(':',".") + "/ 录音" + str(num) + ".wav"
        self.recorder_thread = RecorderThread(output_file)
        self.recorder_thread.setDaemon(True)
        self.recorder_thread.start()

    @Slot()
    def end_record(self):
        self.recorder_thread.flag = False

    @Slot()
    def new_folder(self):
        # repo.test_time = datetime.datetime.now()
        repo.test_time  = datetime.datetime.now()
        repo.currentPath = "\\results\\" + str(repo.test_time).replace(' ', '_').replace(':',".") + "\\"
        repo.folder = str(repo.test_time).replace(' ', '_').replace(':',".")
        os.makedirs(r'%s%s'%(os.getcwd()+"\\results\\" ,str(repo.test_time).replace(' ', '_').replace(':',".")))



"""
ConfigController，用于响应与设置配置有关的前端请求
"""


class ConfigController(QObject):
    # @Slot(str, result="QString")
    # def get_confines(self):
    #     return pic_builder.get_confines(*pic_nums())

    @Slot(str, result="QVariant")
    def get_config(self, key):
        """
        测试时读取相应的单条设置，比如间隔、图片数等
        """
        return config.get_config(key)

    @Slot(str, result="QVariant")
    def get_question(self,key):

        return config.get_questions(key)

    @Slot(result="QString")
    def begin_edit(self):
        """
        点击设置按钮触发此函数，返回给前端当前设置
        :return: 当前设置，以json格式保存在string类型中
        """
        config.read_config()
        return json.dumps(config.get_configs())

    @Slot(str)
    def end_edit(self, edited_config):
        """
        点击保存设置触发此函数，保存前端传递来的设置
        :param edited_config: 前端传递来的设置，以json格式保存在string类型中
        """
        config.set_configs(json.loads(edited_config))
        config.save_config()




test_image_provider = TestImageProvider(QQmlImageProviderBase.Image)
test_controller = TestController()
config_controller = ConfigController()
