import cv2
import threading

class VideoCaptureThread(threading.Thread):
    def __init__(self, video_source, output_file, flag = True):
        threading.Thread.__init__(self)
        self.video_source = video_source
        self.output_file = output_file
        self.capture = cv2.VideoCapture(self.video_source)
        self.flag = flag
        self.fps = int(self.capture.get(cv2.CAP_PROP_FPS))
        self.width = int(self.capture.get(cv2.CAP_PROP_FRAME_WIDTH))
        self.height = int(self.capture.get(cv2.CAP_PROP_FRAME_HEIGHT))
        self.video_writer = cv2.VideoWriter(self.output_file, cv2.VideoWriter_fourcc(*'XVID'), self.fps, (self.width, self.height))

    def run(self):
        while True:
            ret, frame = self.capture.read()
            frame = cv2.flip(frame, 1) #水平翻转
            if ret and self.flag:
                self.video_writer.write(frame)
            else:
                break
        self.capture.release()
        self.video_writer.release()

# if __name__ == '__main__':
#     video_source = 0  # 0 for webcam, or path to video file
#     output_file = 'output.avi'
#     capture_thread = VideoCaptureThread(video_source, output_file)
#     capture_thread.start()
