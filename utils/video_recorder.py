import cv2
import threading

class VideoCaptureThread(threading.Thread):
    def __init__(self, output_file, video_source = 0):
        super().__init__()
        self.setDaemon(True)
        self.flag = True
        self.output_file = output_file
        self.video_source = video_source
        self.capture = cv2.VideoCapture(self.video_source)
        self.fps = int(self.capture.get(cv2.CAP_PROP_FPS))
        self.width = int(self.capture.get(cv2.CAP_PROP_FRAME_WIDTH))
        self.height = int(self.capture.get(cv2.CAP_PROP_FRAME_HEIGHT))
        self.video_writer = cv2.VideoWriter(self.output_file, cv2.VideoWriter_fourcc(*'XVID'), self.fps, (self.width, self.height))

    def run(self):
        self.flag = True
        while self.flag:
            ret, frame = self.capture.read()
            frame = cv2.flip(frame, 1) #水平翻转
            if ret:
                self.video_writer.write(frame)
            else:
                break
        self.capture.release()
        self.video_writer.release()

    def end(self):
        self.flag = False


