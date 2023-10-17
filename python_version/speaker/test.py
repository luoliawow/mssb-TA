import pathlib
import speaker_recogonizer as sr
import soundfile as sf
import numpy as np

ROOT = pathlib.Path(r'D:\Code\python\mssb\python_version\speaker\data')
train, test = ROOT / 'train', ROOT / 'test'

code_book = np.array([sr.code(audio) for audio in train.iterdir()])

for audio in test.iterdir():
    x, fs = sf.read(audio)
    mfcc = sr.mfcc(x, fs, 256, 100, 20)[1:]
    dists = []
    for code in code_book:
        d = np.concatenate([np.linalg.norm(mfcc[:,i].reshape(-1,1)-code, axis=0).reshape(1,-1) for i in range(mfcc.shape[1])],axis=0)
        dist = np.sum(np.min(d, axis=1))
        dists.append(dist)
    print(audio, np.argmin(dists)+1)

