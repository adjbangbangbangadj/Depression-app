from PySide6.QtCore import QObject, Slot
import conf
from ..neuracle_lib.triggerBox import api

class ImageTestBridge(QObject):
    def __init__(self):
        self.image_infos = {}

    @Slot(int, str, int)
    def mark(self, image_index, userlabel, duration):
        image = self.image_infos[image_index]
        image['user_label'] = userlabel
        image['duration'] = duration
        if conf.get_config("if_use_api"):
            api.mark(1)

    @Slot()
    def turn_start(self):
        """
        每轮图片开始的时候进行打标
        """
        if conf.get_config("if_use_api"):
            api.mark(0)

    @Slot(str)
    def begin_test(self, username):
        """
        点击开始测试按钮触发此函数，保存当前时间、用户名，构建图片传递并保存至repo（TestImageProvider从那里取图片），调用api
        :param username: 用户输入的用户名
        """
        conf.read_config()
        repo.test_time = datetime.datetime.now()
        repo.username = username
        # config.read_config()
        # 构建并保存图片(根据设置选择图片源)
        repo.pics_with_mark = pic_reader.read_images(*pic_nums(),
                                                   if_allowed_pics_dup=conf.get_config("if_allowed_pics_dup")) \
            if conf.get_config("if_use_en_pics") \
            else pic_builder.build_pics_consider_gender(
                *pic_nums(), if_allowed_pics_dup=conf.get_config("if_allowed_pics_dup"),
                if_same_neu_pic_for_background=conf.get_config("if_same_neu_pic_for_background"),
                if_same_neu_pic_for_neu=conf.get_config("if_same_neu_pic_for_neu"))
        # 构建并保存背景
        repo.interval_background = pic_builder.build_background_pic(
            *(lambda x: [x.size(), x.format()])(repo.get_pic(0)), conf.get_config("background_color"))
        # print(test_image_provider.requestImage("1",None,None))
        # 调用api
        if conf.get_config("if_use_api"):
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
        result_saver.save_result(repo.username, repo.test_time.strftime('%Y-%m-%d %H:%M:%S'), repo.pics_with_mark,
                                 if_ch_contents=conf.get_config("if_ch_contents"),
                                 if_ch_header=conf.get_config("if_ch_headers"))
