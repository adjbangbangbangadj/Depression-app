import logging
import pyaudio
import wave
import threading


class AudioRecorderThread(threading.Thread):
    def __init__(self, output_file):
        super().__init__()
        self.setDaemon(True)
        self.flag = True
        self.chunk = 1024  # 缓冲区大小
        self.channels = 1  # 声道数
        self.sample_rate = 44100  # 采样率
        self.record_seconds = 5  # 录音时长
        self.output_file = str(output_file)  # 输出文件名
        self.audio = pyaudio.PyAudio()

    def run(self):
        # 打开音频流
        self.stream = self.audio.open(format=pyaudio.paInt16,
                                      channels=self.channels,
                                      rate=self.sample_rate,
                                      input=True,
                                      frames_per_buffer=self.chunk)

        # 录制音频
        self.frames = []
        # for i in range(0, int(self.sample_rate / self.chunk * self.record_seconds)):
        while self.flag:
            data = self.stream.read(self.chunk)
            self.frames.append(data)

    def end(self):
        self.flag = False

        # 关闭音频流
        self.stream.stop_stream()
        self.stream.close()
        self.audio.terminate()

        # 将音频写入WAV文件
        with wave.open(self.output_file, 'wb') as wf:
            wf.setnchannels(self.channels)
            wf.setsampwidth(self.audio.get_sample_size(pyaudio.paInt16))
            wf.setframerate(self.sample_rate)
            wf.writeframes(b''.join(self.frames))

        self.join(1)
        if self.is_alive():
            logging.warning("AudioRecorderThread not end unexpertedly")
