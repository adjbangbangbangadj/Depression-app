from PySide6.QtCore import QObject, Slot
from PySide6.QtQml import QmlElement
import vars
from ..neuracle_lib.triggerBox import api
from ..service.image_utils import build_images_consider_gender, read_images, build_background_image
from ..service.result_writer import save_csv

@QmlElement
class ImageTestBridge(QObject):
    def __init__(self):
        self.conf = vars.conf['image_test']
        self.image_infos:list[dict] = []
        self.interval_background = ...
        self.image_nums = [int(self.conf[f]) for f in ["pos_image_num", "neu_image_num", "neg_image_num"]]

    @Slot(int, str, int)
    def user_answer(self, image_index, user_tag, duration):
        image = self.image_infos[image_index]
        image['user_tag'] = user_tag
        image['duration'] = duration
        if self.conf["if_use_api"]:
            api.mark(1)

    @Slot()
    def turn_start(self):
        """
        每轮图片开始的时候进行打标
        """
        if self.conf["if_use_api"]:
            api.mark(0)

    @Slot(str)
    def test_start(self):
        # 构建并保存图片(根据设置选择图片源)
        if self.conf['dataset'] == 'K': # TODO
            self.image_infos = read_images(*self.image_nums, if_allowed_images_dup=self.conf["if_allowed_images_dup"])
        elif self.conf['dataset'] == 'C': # TODO
            self.image_infos = read_images(*self.image_nums, build_images_consider_gender(
                *self.image_nums(), if_allowed_images_dup=self.conf["if_allowed_images_dup"],
                if_same_neu_image_for_background=self.conf["if_same_neu_image_for_background"],
                if_same_neu_image_for_neu=self.conf["if_same_neu_image_for_neu"]))

        x :dict = {}
        x.update
        # 构建并保存背景
        self.interval_background = build_background_image(
            *(lambda x: [x.size(), x.format()])(self.get_image(0)), self.conf["background_color"])

        # 调用api
        if self.conf["if_use_api"]:
            api.start()

        # captureVideoFromCamera()

        # video_source = 0  # 0 for webcam, or path to video file
        # output_file = 'output.avi'
        # capture_thread = VideoCaptureThread(video_source, output_file)
        # capture_thread.setDaemon(True)
        # capture_thread.start()

    @Slot()
    def test_end(self):
        """
        测试结束时触发此函数，调用服务将结果写入磁盘
        """
        test_result = []
        for i in self.image_infos:
            test_result.append(dict(name=i['name'],tag=i['tag'], user_tag=i['user_tag'], duration=i['duration']))
        save_csv(test_result, vars.test_info.result_dir)