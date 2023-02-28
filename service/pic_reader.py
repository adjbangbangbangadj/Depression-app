from PySide2.QtGui import QImage
from itertools import chain
import random
import os
import path

_pic_dirs = {"pos": "\\images\\en\\pos\\", "neu": "\\images\\en\\neu\\", "neg": "\\images\\en\\neg\\"}


def init_pics(pos_num: int, neu_num: int, neg_num: int, *, if_allowed_pics_dup: bool) -> list[dict]:
    pic_nums = {"pos": pos_num, "neu": neu_num, "neg": neg_num}

    def read_a_kind_of_pics(pic_num, pic_path, tag):
        a_kind_of_pics = list(
            filter(lambda x: x[-3:] in ["jpg", "png", "JPG", "PNG"], [p for p in os.listdir(pic_path)]))
        if len(a_kind_of_pics) < pic_num and not if_allowed_pics_dup:
            raise Exception("the number of requested images is more than the number of available images!")
        return [{'pic': QImage(pic_path + p), 'name': p, 'tag': tag}
                for p in random.sample(a_kind_of_pics, pic_num)]

    temp = list(chain(*[read_a_kind_of_pics(pic_nums[label], path.executable_path + pic_dir, label)
                        for label, pic_dir in _pic_dirs.items()]))
    random.shuffle(temp)
    return temp
