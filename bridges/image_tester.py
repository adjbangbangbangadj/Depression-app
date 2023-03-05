from PySide6.QtCore import QObject, Slot
from csv import DictWriter
from pathlib import Path
from functools import partial
from utils.image_utils import build_images_consider_gender, read_images, build_background_image
import vars

class ImageTester(QObject):
    def __init__(self):
        super().__init__()
        self.conf = partial(vars.configuration.get, 'image_test')
        self.image_nums = [int(self.conf(f)) for f in ["pos_image_num", "neu_image_num", "neg_image_num"]]

        # 构建并保存图片(根据设置选择图片源)
        self.image_infos:list[dict] = None
        if self.conf('image_dataset') == 'KDEF':
            self.image_infos = read_images(*self.image_nums, if_allowed_images_dup=self.conf("if_allowed_images_dup"))
        elif self.conf('image_dataset') == 'CAPS':
            self.image_infos = build_images_consider_gender(
                *self.image_nums, if_allowed_images_dup=self.conf("if_allowed_images_dup"),
                if_same_neu_image_for_background=self.conf("if_same_neu_image_for_background"),
                if_same_neu_image_for_neu=self.conf("if_same_neu_image_for_neu"))
        # 构建并保存背景
        sample = self.image_infos[0]['image']
        self.interval_background = build_background_image(sample.size(), sample.format(), self.conf("background_color"))
        # push image to ImageProvider
        for index, item in enumerate(self.image_infos):
            vars.image_provider.set_image(index, item['image'])
        vars.image_provider.set_image('background', self.interval_background)

    @Slot(int, str, int)
    def answer(self, image_index, user_tag, duration):
        image = self.image_infos[image_index]
        image['user_tag'] = user_tag
        image['duration'] = duration

    @Slot()
    def save_image_test_result(self):
        test_result = []
        for i in self.image_infos:
            test_result.append(dict(name=i['name'], label=i['label'], user_tag=i['user_tag'], duration=i['duration']))
        csv_filename = vars.test_info.result_dir / Path(vars.test_info.result_dir.name + '.csv')

        with open(csv_filename, 'w', encoding='utf-8-sig') as save_file:
            writer = DictWriter(save_file, fieldnames=test_result[0].keys(), lineterminator='\n')
            writer.writeheader()
            writer.writerows(test_result)

