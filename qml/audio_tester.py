from PySide6.QtCore import QObject, Slot
from PySide6.QtQml import QmlElement
from pathlib import Path
import vars

@QmlElement
class AudioTestBridge(QObject):
    @Slot()
    def record_start():
        ...

    @Slot
    def record_end():
        ...

    @Slot
    def


import pyaudio
import wave
import threading


class RecorderThread(threading.Thread):

    def __init__(self, output_file, flag=True):
        threading.Thread.__init__(self)
        # 定义音频参数
        self.chunk = 1024  # 缓冲区大小
        self.channels = 1  # 声道数
        self.sample_rate = 44100  # 采样率
        self.record_seconds = 5  # 录音时长
        self.output_file = output_file  # 输出文件名
        self.flag = flag
        # 初始化PyAudio
        self.audio = pyaudio.PyAudio()

    def run(self):
        # 打开音频流
        stream = self.audio.open(format=pyaudio.paInt16,
                            channels=self.channels,
                            rate=self.sample_rate,
                            input=True,
                            frames_per_buffer=self.chunk)

        print("Recording...")

        # 录制音频
        frames = []
        # for i in range(0, int(self.sample_rate / self.chunk * self.record_seconds)):
        while True:
            if self.flag:
                data = stream.read(self.chunk)
                frames.append(data)
            else:
                break

        print("Finished recording.")

        # 关闭音频流
        stream.stop_stream()
        stream.close()
        self.audio.terminate()

        # 将音频写入WAV文件
        with wave.open(self.output_file, 'wb') as wf:
            wf.setnchannels(self.channels)
            wf.setsampwidth(self.audio.get_sample_size(pyaudio.paInt16))
            wf.setframerate(self.sample_rate)
            wf.writeframes(b''.join(frames))

        print("WAV file saved as", self.output_file)





