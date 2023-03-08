from typing import overload
from PySide6.QtGui import QImage
from PySide6.QtCore import QSize
from PySide6.QtGui import QImage, QColor, QPainter
from functools import partial
from itertools import chain
from pathlib import Path
import random
import root
# import logging

from root import DATA_DIR

LABELS = ['pos', 'neu', 'neg']
IMAGE_ROOT_DIR = DATA_DIR / Path('images/')
root.check_dir(IMAGE_ROOT_DIR)

def _construct_dirs(*paths):
    return {k: IMAGE_ROOT_DIR / Path(v) for k,v in zip(LABELS, paths)}

_image_dirs = _construct_dirs('KDEF/pos/', 'KDEF/neu/', 'images/KDEF/neg')
_female_image_dirs = _construct_dirs('CAPS/pos/female/','CAPS/neu/female/','CAPS/neg/female/')
_male_image_dirs = _construct_dirs('CAPS/pos/male/','CAPS/neu/male/','CAPS/neg/male/')


class ImageRecord:
    @overload
    def __init__(self, image_path:Path, label:str)-> None: ...

    @overload
    def __init__(self, qimage:QImage, name:dict, label:str)-> None: ...

    def __init__(self, arg_1:Path, arg_2, arg_3=None)-> None:
        if isinstance(arg_1, Path):
            self.image=QImage(str(arg_1))
            self.name=arg_1.name
            self.label=arg_2
        if isinstance(arg_1, QImage):
            self.image=arg_1
            self.name=arg_2
            self.label=arg_3
        self.user_tag = None
        self.duration = None


    def set_userinfo(self, user_tag, duration):
        self.user_tag = user_tag
        self.duration = duration

    def get_saveinfo(self)->dict():
        return


def ImageNums(pos_num: int, neu_num: int, neg_num: int)->dict:
    return {'pos': pos_num, 'neu': neu_num, 'neg': neg_num}

def multiple_rounds_sample(population:list, k: int):
    if not population:
        return []
    elif k <= len(population):
        return random.sample(population, k)
    else:
        return random.sample(population, len(population)) + multiple_rounds_sample(population, k - len(population))

_image_file_suffix = ['jpg', 'jpeg', 'png', 'gif']
_image_file_suffix.extend([i.upper() for i in _image_file_suffix])

def _get_image_path(image_dir: str) -> list[Path]:
    images = []
    for suffix in _image_file_suffix:
        images.extend(image_dir.glob('*.' + suffix))
    return images

def _get_image_paths(image_dirs: dict[str, str]) -> dict[str, list[Path]]:
    ''' 获取三个类别的对应文件夹下面可用格式的图片路径
    :param image_dirs: 三类图片的文件夹路径
    :return:三类图片的所有可用图片的路径
    '''
    return {k: _get_image_path(v) for k, v in image_dirs.items()}

def read_images(pos_num: int, neu_num: int, neg_num: int, *, if_allowed_images_dup: bool) -> list[dict]:
    image_nums = {'pos': pos_num, 'neu': neu_num, 'neg': neg_num}

    def read_a_kind_of_images(image_num, image_dir, label):
        a_kind_of_images =  _get_image_path(image_dir)
        if len(a_kind_of_images) < image_num and not if_allowed_images_dup:
            raise Exception(f'the number of requested images {image_num} is more than '
                            f'the number of available images {len(a_kind_of_images)} for the {label} image!')
        return [ImageRecord(p, label) for p in random.sample(a_kind_of_images, image_num)]

    temp = list(chain(*[read_a_kind_of_images(image_nums[label], image_dir, label)
                        for label, image_dir in _image_dirs.items()]))
    random.shuffle(temp)
    return temp


def _confined_nums_to_combined_need(confined_nums: dict, *, if_same_neu_image_for_background: bool,
                                    if_same_neu_image_for_neu: bool) -> dict:
    '''
    将指定的（前端直接显示的的）拼接后4合1的图片的数量转化为实际上需要各类的图片的数量
    :param confined_nums: 拼接后的图片数量
    :param if_same_neu_image_for_background: bool 是否在拼接后的积极或消极图片中使用同一张中性图片
    :param if_same_neu_image_for_neu: 如果前一个参数为真，拼接后的中性图片是否使用同一张中性图片
    :return: 需要的用于拼接的图片数量
    '''
    return {'pos': confined_nums['pos'], 'neg': confined_nums['neg'],
            'neu': (sum(confined_nums.values()) + (0 if if_same_neu_image_for_neu else confined_nums['neu']))
            if if_same_neu_image_for_background else 3 * sum(confined_nums.values()) + confined_nums['neu']}


# def _combined_need_to_confined_nums(combined_need: dict, if_same_neu_image_for_background: bool) -> dict:
#     neu = combined_need['neu'] - combined_need['pos'] - combined_need['neg']
#     if not if_same_neu_image_for_background:
#         neu = math.floor(neu / 4)
#     return {'pos': combined_need['pos'], 'neg': combined_need['neg'], 'neu': neu}


def _preprocess_images(combined_needs: dict[str, int], image_dirs: dict[str, str],
                     *, if_allowed_images_dup: bool) -> dict[str, list[dict]]:
    '''
    根据图片数量和路径，选择并读取图片
    :param combined_needs: dict[str, int] 需要的图片数量
    :param image_dirs: dict[str, str] 各属性图片的文件夹的目录
    :param if_allowed_images_dup: bool 是否允许图片重复
    :return: dict[str, list[dict]] 读取到的图片（图片及其信息是dict）按三种类别存储在dict当中
    '''
    image_paths: dict[str, list[Path]] = _get_image_paths(image_dirs)
    if not if_allowed_images_dup:
        for label, image_path in image_paths.items():
            if len(image_path) < combined_needs[label]:
                raise Exception(f'the number of requested images {combined_needs[label]} '
                                f'is more than the number of available images {len(image_path)} for the {label} image!')

    return {label: [ImageRecord(path, label)
                    for path in multiple_rounds_sample(image_paths[label], combined_needs[label])] for label in LABELS}


def _build_images(original_images: dict[str, list], image_nums: dict[str, int], *, if_same_neu_image_for_background: bool,
                if_same_neu_image_for_neu: bool) -> list[dict]:
    '''
    根据需要拼接的图片数量和带拼接的图片，来拼接图片
    :param original_images: dict[str, list] 待拼接的图片(4张拼成1张)
    :param image_nums: dict[str, int] 需要的拼接后的各类图片的数量
    :param if_same_neu_image_for_background: bool 是否在拼接后的积极或消极图片中使用同一张中性图片
    :param if_same_neu_image_for_neu: 如果前一个参数为真，拼接后的中性图片是否使用同一张中性图片
    :return: 拼接后的图片，用于前端直接显示
    '''
    def _pre_combine_images(label: str) -> list:
        def _combine_images_with_mark(main_image:ImageRecord, background_images: list[ImageRecord]) -> ImageRecord:
            def _combine_images_drawing(image1: QImage, image2: QImage, image3: QImage, image4: QImage) -> QImage:
                '''
                    拼接图片的具体函数，使用QPainter实现
                '''
                height = image1.height()
                width = image1.width()
                # print(image1.isNull())
                _combined_image = QImage(width * 2, height * 2, image1.format())
                _combined_image.fill(QColor('black'))
                combined_painter = QPainter(_combined_image)
                combined_painter.drawImage(0, 0, image1)            # top left
                combined_painter.drawImage(width, 0, image2)        # top right
                combined_painter.drawImage(0, height, image3)       # bottom left
                combined_painter.drawImage(width, height, image4)   # bottom right
                # print(_combined_image.isNull())
                return _combined_image

            if len(background_images) == 0:
                _images = [main_image] * 4
            elif len(background_images) == 1:
                _images = [main_image] + background_images * 3
            elif len(background_images) == 3:
                _images = [main_image] + background_images
            else:
                raise Exception('argument pattern dismatched in combine_image function')

            random.shuffle(_images)
            _combined_image:QImage = _combine_images_drawing(*[i.image for i in _images])
            # name order is top-left, top-right, bottom-left, bottom-right
            _name = '+'.join([i.name for i in _images])
            return ImageRecord(_combined_image, _name, main_image.label)

        if label in ['pos', 'neg']:
            return [_combine_images_with_mark(original_images[label].pop(0),
                                            [original_images['neu'].pop(0)] if if_same_neu_image_for_background
                                            else [original_images['neu'].pop(0) for _ in range(3)])
                    for _ in range(image_nums[label])]
        elif label == 'neu':
            return [_combine_images_with_mark(original_images['neu'].pop(0),
                                            ([] if if_same_neu_image_for_neu else [original_images['neu'].pop(0)])
                                            if if_same_neu_image_for_background
                                            else [original_images['neu'].pop(0) for _ in range(3)])
                    for _ in range(image_nums['neu'])]

    # logging.debug('fn _build_images completed.\n' +
    #                '\n'.join([f'{label}:{len(original_images[label])}' for label in LABELS]))
    temp = list(chain(*[_pre_combine_images(label) for label in LABELS]))
    random.shuffle(temp)
    return temp


def get_confines(pos_num: int, neu_num: int, neg_num: int, if_same_neu_image_for_background: bool,
                 if_same_neu_image_for_neu: bool):
    return _confined_nums_to_combined_need(ImageNums(pos_num, neu_num, neg_num),
                                           if_same_neu_image_for_background=if_same_neu_image_for_background,
                                           if_same_neu_image_for_neu=if_same_neu_image_for_neu)


def build_images(pos_num: int, neu_num: int, neg_num: int, *, image_dirs, if_same_neu_image_for_background: bool = True,
               if_same_neu_image_for_neu: bool = True, if_allowed_images_dup: bool = False) -> list:
    '''
    将上面各个过滤器组合起来，从指定的拼接后的图片数量和图片目录的路径以及各项设置，得到最终的拼接后的图片结果
    '''
    image_nums = ImageNums(pos_num, neu_num, neg_num)
    build_images_filter = partial(_build_images,
                                if_same_neu_image_for_background=if_same_neu_image_for_background,
                                if_same_neu_image_for_neu=if_same_neu_image_for_neu)
    preprocess_images_filter = partial(_preprocess_images, image_dirs=image_dirs, if_allowed_images_dup=if_allowed_images_dup)
    to_combined_nums_filter = partial(_confined_nums_to_combined_need,
                                      if_same_neu_image_for_background=if_same_neu_image_for_background,
                                      if_same_neu_image_for_neu=if_same_neu_image_for_neu)
    return build_images_filter(preprocess_images_filter(to_combined_nums_filter(image_nums)), image_nums)


def build_images_consider_gender(pos_num: int, neu_num: int, neg_num: int, **kargs) -> list[dict]:
    image_nums = ImageNums(pos_num, neu_num, neg_num)
    '''
    在上一个函数build_images的基础上，考虑了图片由两种性别组成。将从指定的拼接后的图片数量分半，分别调用上一个函数build_images
    '''
    female_num = {k: v // 2 + random.randint(0, 1) if v % 2 == 1 else 0 for k, v in image_nums.items()}
    male_num = {k: v - female_num[k] for k, v in image_nums.items()}
    temp = build_images(*female_num.values(), image_dirs=_female_image_dirs, **kargs) + \
        build_images(*male_num.values(), image_dirs=_male_image_dirs, **kargs)
    random.shuffle(temp)
    return temp


def build_background_image(size: QSize, qformat: QImage.Format, interval_background_color: str) -> QImage:
    '''
    构建两张测试图片之间的背景（默认是黑色）
    '''
    background = QImage(size, qformat)
    if not interval_background_color:
        interval_background_color = 'white'
    background.fill(QColor(interval_background_color))
    return background

# if_same_neu_image_for_background, if_same_neu_image_for_neu = True, False
# print(f'if_same_neu_image_for_background: {if_same_neu_image_for_background}')
# print(f'if_same_neu_image_for_neu: {if_same_neu_image_for_neu}')
# build_images(2, 6, 2, image_dirs=_male_image_dirs, if_same_neu_image_for_neu=if_same_neu_image_for_neu,
#            if_allowed_images_dup=False, if_same_neu_image_for_background=if_same_neu_image_for_background)
