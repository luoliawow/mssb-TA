import numpy as np
import matplotlib.pyplot as plt
import util
from scipy.fft import dct
import librosa

def mfcc(x:np.ndarray, fs:int, n_fft:int, n_shift:int, n_mel:int) -> np.ndarray:

    # pre-processing
    N, M = n_fft, n_shift
    num_windows = (x.size - N) // M + 1
    frames = np.lib.stride_tricks.sliding_window_view(x, N)[::M][:num_windows]

    # windowing
    xn = np.arange(0, N)
    wn = 0.54 - 0.46 * np.cos(2 * np.pi * xn / (N - 1))
    windowed_frames = frames * wn

    # fft to retrieve PSD
    F = np.fft.rfft(windowed_frames, axis=1)
    PSD = np.abs(F) ** 2

    # mel spectrogram
    melfb = librosa.filters.mel(sr=fs, n_fft=n_fft, n_mels=n_mel, norm=None)
    melspec = melfb @ PSD.T

    mfcc = dct(np.log(melspec), axis=0, norm='ortho')
    return mfcc

def vq(d, k, e=1e-2):
    e, k = 1e-2, 16
    # init codebook with centroids of d
    r = np.mean(d, axis=1).reshape(-1,1)
    for i in range(1,int(np.log2(k))):
        # split each centroid into two
        r = np.hstack((r*(1-e), r*(1+e)))
        dpr = 1e5

        while True:
            # calculate each point's distance to each centroid
            z = np.concatenate([np.linalg.norm(d-r[:,j].reshape(-1,1),axis=0).reshape(1,-1) for j in range(r.shape[1])], axis=0)
            ind = np.argmin(z, axis=0)
            t = 0
            for j in range(2**i):
                # update centroids
                r[:,j] = np.mean(d[:,ind==j], axis=1)
                dists = np.linalg.norm(d[:,ind==j]-r[:,j].reshape(-1,1), axis=0)
                t += sum(dists)

            if (dpr - t)/t < e:
                break
            else:
                dpr = t
    return r