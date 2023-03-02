from PySide6.QtGui import QImage
from PySide6.QtCore import QSize
from PySide6.QtGui import QImage, QColor, QPainter
from functools import reduce, partial
from itertools import chain
import random
import os


_pic_dirs = {"pos": "\\images\\en\\pos\\", "neu": "\\images\\en\\neu\\", "neg": "\\images\\en\\neg\\"}


def read_images(pos_num: int, neu_num: int, neg_num: int, *, if_allowed_pics_dup: bool) -> list[dict]:
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




"""
本文件为管道过滤器风格，所有函数都是无状态的。以下的全局变量不会被修改，不表示状态。
"""
_labels = ["pos", "neu", "neg"]
_female_pic_dirs = \
    {"pos": "\\images\\ch\\pos\\female\\", "neu": "\\images\\ch\\neu\\female\\", "neg": "\\images\\ch\\neg\\female\\"}
_male_pic_dirs = \
    {"pos": "\\images\\ch\\pos\\male\\", "neu": "\\images\\ch\\neu\\male\\", "neg": "\\images\\ch\\neg\\male\\"}


def _pic_nums(pos_num: int, neu_num: int, neg_num: int):
    return {"pos": pos_num, "neu": neu_num, "neg": neg_num}


def _get_pic_paths(pic_dirs: dict[str, str]):
    """ 获取三个类别的对应文件夹下面可用格式的图片路径
    :param pic_dirs: 三类图片的文件夹路径
    :return:三类图片的所有可用图片的路径
    """
    return {k: [p for p in os.listdir(path.executable_path + v) if p[-3:] in ["jpg", "png", "gif", "JPG", "PNG"]]
            for k, v in pic_dirs.items()}

    # def get_confine(self):
    #     confine = {}
    #     pic_nums = {k: len(v) for k, v in self._get_pic_paths().items()}
    #     if not self._if_allowed_pics_dup:
    #         confine["pos"], confine["neg"] = pic_nums["pos"], pic_nums["neg"]
    #         confine["neu"] = sum(pic_nums.values()) + (
    #             3 * pic_nums["neu"] if not self._if_same_neu_pic_for_background else 0)
    #     return confine

    # def check_confine(self, pic_nums, confine):


def _confined_nums_to_combined_need(confined_nums: dict, *, if_same_neu_pic_for_background: bool,
                                    if_same_neu_pic_for_neu: bool) -> dict:
    """
    将指定的（前端直接显示的的）拼接后4合1的图片的数量转化为实际上需要各类的图片的数量
    :param confined_nums: 拼接后的图片数量
    :param if_same_neu_pic_for_background: bool 是否在拼接后的积极或消极图片中使用同一张中性图片
    :param if_same_neu_pic_for_neu: 如果前一个参数为真，拼接后的中性图片是否使用同一张中性图片
    :return: 需要的用于拼接的图片数量
    """
    return {"pos": confined_nums["pos"], "neg": confined_nums["neg"],
            "neu": (sum(confined_nums.values()) + (0 if if_same_neu_pic_for_neu else confined_nums["neu"]))
            if if_same_neu_pic_for_background else 3 * sum(confined_nums.values()) + confined_nums["neu"]}


# def _combined_need_to_confined_nums(combined_need: dict, if_same_neu_pic_for_background: bool) -> dict:
#     neu = combined_need["neu"] - combined_need["pos"] - combined_need["neg"]
#     if not if_same_neu_pic_for_background:
#         neu = math.floor(neu / 4)
#     return {"pos": combined_need["pos"], "neg": combined_need["neg"], "neu": neu}


def _preprocess_pics(combined_needs: dict[str, int], pic_dirs: dict[str, str],
                     *, if_allowed_pics_dup: bool) -> dict[str, list[dict]]:
    """
    根据图片数量和路径，选择并读取图片
    :param combined_needs: dict[str, int] 需要的图片数量
    :param pic_dirs: dict[str, str] 各属性图片的文件夹的目录
    :param if_allowed_pics_dup: bool 是否允许图片重复
    :return: dict[str, list[dict]] 读取到的图片（图片及其信息是dict）按三种类别存储在dict当中
    """
    def _sample(population, k: int):
        if k <= len(population):
            return random.sample(population, k)
        else:
            return random.sample(population, len(population)) + _sample(population, k - population)

    pic_paths = _get_pic_paths(pic_dirs)
    if reduce(lambda x, y: x and y,
              [len(pic_path) < combined_needs[label] for label, pic_path in pic_paths.items()]):
        if not if_allowed_pics_dup:
            raise Exception("the number of requested images is more than the number of available images!")
    temp = {label: [{'pic': QImage(path.executable_path + pic_dirs[label] + p), 'name': p, 'label': label}
                    for p in _sample(pic_paths[label], combined_needs[label])]
            for label in _labels}
    # [print(path.executable_path + _pic_dirs[label] + p) for label in _labels
    #  for p in _sample(pic_paths[label], combined_needs[label])]
    return temp


def _build_pics(original_pics: dict[str, list], pic_nums: dict[str, int], *, if_same_neu_pic_for_background: bool,
                if_same_neu_pic_for_neu: bool) -> list[dict]:
    """
    根据需要拼接的图片数量和带拼接的图片，来拼接图片
    :param original_pics: dict[str, list] 待拼接的图片(4张拼成1张)
    :param pic_nums: dict[str, int] 需要的拼接后的各类图片的数量
    :param if_same_neu_pic_for_background: bool 是否在拼接后的积极或消极图片中使用同一张中性图片
    :param if_same_neu_pic_for_neu: 如果前一个参数为真，拼接后的中性图片是否使用同一张中性图片
    :return: 拼接后的图片，用于前端直接显示
    """
    def _pre_combine_pics(label: str) -> list:
        def _combine_pics_with_mark(main_pic: QImage, background_pics: list[QImage]) -> dict:
            def _combine_pics_drawing(pic1: QImage, pic2: QImage, pic3: QImage, pic4: QImage) -> QImage:
                """
                    拼接图片的具体函数，使用QPainter实现
                """
                height = pic1.height()
                width = pic1.width()
                # print(pic1.isNull())
                # _combined_pic = pic1
                _combined_pic = QImage(width * 2, height * 2, pic1.format())
                _combined_pic.fill(QColor("black"))
                combined_painter = QPainter(_combined_pic)
                combined_painter.drawImage(0, 0, pic1)
                combined_painter.drawImage(0, height, pic2)
                combined_painter.drawImage(width, 0, pic3)
                combined_painter.drawImage(width, height, pic4)
                # print(_combined_pic.isNull())
                return _combined_pic

            if len(background_pics) == 0:
                _pics = [main_pic] * 4
            elif len(background_pics) == 1:
                _pics = [main_pic] + background_pics * 3
            elif len(background_pics) == 3:
                _pics = [main_pic] + background_pics
            else:
                raise Exception("argument error in combine_pic function")
            return {"pic": _combine_pics_drawing(*(random.sample([p["pic"] for p in _pics], 4))),
                    "label": main_pic["label"],
                    "main_image_name": main_pic["name"],
                    "neu_image1_name": _pics[0]["name"],
                    "neu_image2_name": _pics[1]["name"],
                    "neu_image3_name": _pics[2]["name"]}

        if label in ["pos", "neg"]:
            return [_combine_pics_with_mark(original_pics[label].pop(0),
                                            [original_pics["neu"].pop(0)] if if_same_neu_pic_for_background
                                            else [original_pics["neu"].pop(0) for _ in range(3)])
                    for _ in range(pic_nums[label])]
        elif label == "neu":
            return [_combine_pics_with_mark(original_pics["neu"].pop(0),
                                            ([] if if_same_neu_pic_for_neu else [original_pics["neu"].pop(0)])
                                            if if_same_neu_pic_for_background
                                            else [original_pics["neu"].pop(0) for _ in range(3)])
                    for _ in range(pic_nums["neu"])]

    # ([print(f"{label}:{len(original_pics[label])}") for label in _labels])
    temp = list(chain(*[_pre_combine_pics(label) for label in _labels]))
    random.shuffle(temp)
    return temp


def get_confines(pos_num: int, neu_num: int, neg_num: int, if_same_neu_pic_for_background: bool,
                 if_same_neu_pic_for_neu: bool):
    return _confined_nums_to_combined_need(_pic_nums(pos_num, neu_num, neg_num),
                                           if_same_neu_pic_for_background=if_same_neu_pic_for_background,
                                           if_same_neu_pic_for_neu=if_same_neu_pic_for_neu)


def build_pics(pos_num: int, neu_num: int, neg_num: int, *, pic_dirs, if_same_neu_pic_for_background: bool = True,
               if_same_neu_pic_for_neu: bool = True, if_allowed_pics_dup: bool = False) -> list:
    """
    将上面各个过滤器组合起来，从指定的拼接后的图片数量和图片目录的路径以及各项设置，得到最终的拼接后的图片结果
    """
    pic_nums = _pic_nums(pos_num, neu_num, neg_num)
    build_pics_filter = partial(_build_pics,
                                if_same_neu_pic_for_background=if_same_neu_pic_for_background,
                                if_same_neu_pic_for_neu=if_same_neu_pic_for_neu)
    preprocess_pics_filter = partial(_preprocess_pics, pic_dirs=pic_dirs, if_allowed_pics_dup=if_allowed_pics_dup)
    to_combined_nums_filter = partial(_confined_nums_to_combined_need,
                                      if_same_neu_pic_for_background=if_same_neu_pic_for_background,
                                      if_same_neu_pic_for_neu=if_same_neu_pic_for_neu)
    return build_pics_filter(preprocess_pics_filter(to_combined_nums_filter(pic_nums)), pic_nums)


def build_pics_consider_gender(pos_num: int, neu_num: int, neg_num: int, **kargs) -> list:
    pic_nums = _pic_nums(pos_num, neu_num, neg_num)
    """
    在上一个函数build_pics的基础上，考虑了图片由两种性别组成。将从指定的拼接后的图片数量分半，分别调用上一个函数build_pics
    """
    female_num = {k: v // 2 + random.randint(0, 1) if v % 2 == 1 else 0 for k, v in pic_nums.items()}
    male_num = {k: v - female_num[k] for k, v in pic_nums.items()}
    temp = build_pics(*female_num.values(), pic_dirs=_female_pic_dirs, **kargs) + \
        build_pics(*male_num.values(), pic_dirs=_male_pic_dirs, **kargs)
    random.shuffle(temp)
    return temp


def build_background_pic(size: QSize, qformat: QImage.Format, background_color: str) -> QImage:
    """
    构建两张测试图片之间的背景（默认是黑色）
    """
    background = QImage(size, qformat)
    if not background_color:
        background_color = "white"
    background.fill(QColor(background_color))
    return background

# if_same_neu_pic_for_background, if_same_neu_pic_for_neu = True, False
# print(f"if_same_neu_pic_for_background: {if_same_neu_pic_for_background}")
# print(f"if_same_neu_pic_for_neu: {if_same_neu_pic_for_neu}")
# build_pics(2, 6, 2, pic_dirs=_male_pic_dirs, if_same_neu_pic_for_neu=if_same_neu_pic_for_neu,
#            if_allowed_pics_dup=False, if_same_neu_pic_for_background=if_same_neu_pic_for_background)
