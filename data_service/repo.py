
pics_with_mark = {}
interval_background = None
test_time = None
username = None
# currentPath = "\\results\\" + test_time + "\\"
currentPath = None

def mark(pic_index, usertag, duration):
    pics_with_mark[pic_index]['user-label'] = usertag
    pics_with_mark[pic_index]['duration'] = duration


def get_pic(pic_index):
    return pics_with_mark[pic_index]['pic']
