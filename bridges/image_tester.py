import logging
from PySide6.QtCore import QObject, Slot
from csv import DictWriter
from pathlib import Path
from functools import partial
from utils.image_utils import ImageRecord, build_images_consider_gender, read_images, build_background_image
import root


class ImageTester(QObject):
    def __init__(self):
        super().__init__()
        self.conf = partial(root.configuration.get, 'image_test')
        self.image_nums = [int(self.conf(f)) for f in [
            "pos_image_num", "neu_image_num", "neg_image_num"]]

        # 构建并保存图片(根据设置选择图片源)
        self.image_infos: list[ImageRecord] = None
        if self.conf('image_dataset') == 'KDEF':
            self.image_infos = read_images(
                *self.image_nums, if_allowed_images_dup=self.conf("if_allowed_images_dup"))
        elif self.conf('image_dataset') == 'CAPS':
            self.image_infos = build_images_consider_gender(
                *self.image_nums, if_allowed_images_dup=self.conf("if_allowed_images_dup"),
                if_same_neu_image_for_background=self.conf(
                    "if_same_neu_image_for_background"),
                if_same_neu_image_for_neu=self.conf("if_same_neu_image_for_neu"))
        # 构建并保存背景
        sample = self.image_infos[0].image
        self.interval_background = build_background_image(
            sample.size(), sample.format(), self.conf("interval_background_color"))
        # push image to ImageProvider
        for index, item in enumerate(self.image_infos):
            root.image_provider.set_image(index, item.image)
        root.image_provider.set_image('background', self.interval_background)

    @Slot(int)
    def turn_start(self, current_turn):
        logging.debug(f'image test turn start:{current_turn}')
        # root.neuracle_trigger.mark(11000 + current_turn)
        root.neuracle_trigger.mark(0)

    @Slot(int, str, int)
    def answer(self, image_index, user_tag, duration):
        logging.debug('ImageTester collected the user answer: image_index=%s, user_tag=%s, duration=%s' %
                      (image_index, user_tag,duration))
        # root.neuracle_trigger.mark('image_' + str(image_index))
        # root.neuracle_trigger.mark(12000 + image_index)
        root.neuracle_trigger.mark(1)
        image:ImageRecord = self.image_infos[image_index]
        image.user_tag = user_tag
        image.duration = duration

    @Slot(result='int')
    def image_num(self):
        return sum(self.image_nums)

    @Slot()
    def save_result(self):
        test_result = []
        for i in self.image_infos:
            test_result.append(dict(
                name=i.name, label=i.label, user_tag=i.user_tag, duration=i.duration))
        csv_filename = root.test_info.result_dir / \
            Path(root.test_info.result_dir.name + '.csv')

        with open(csv_filename, 'w', encoding='utf-8-sig') as save_file:
            writer = DictWriter(
                save_file, fieldnames=test_result[0].keys(), lineterminator='\n')
            writer.writeheader()
            writer.writerows(test_result)
