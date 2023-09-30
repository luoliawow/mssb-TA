import librosa
import numpy as np

# def melfb_impl(p, n, fs):
#     """mel freq bank

#     Args:
#         p (int): number of filters in filterbank
#         n (int): length of fft
#         fs (int): sample rate in Hz
#     """

#     f0 = 700 / fs
#     fn2 = floor(n/2)
#     lr = log(1 + 0.5/f0) / (p + 1)

#     bl = n * (f0 * (np.exp(np.array([0, 1, p, p+1]) * lr) - 1))

#     b1, b2, b3, b4 = + \
#         floor(bl[0]) + 1, + \
#         ceil(bl[1]), + \
#         floor(bl[2]), + \
#         min(fn2, ceil(bl[3])) - 1
    
#     pf = np.log(1 + np.arange(b1,b4+1) / (n*f0)) / lr
#     fp = np.floor(pf)
#     pm = pf - fp
    
#     # r = np.concatenate((fp[b2 - b1:b4 - b1 + 1], fp[:b3 - b1 + 1] + 1))
#     # c = np.concatenate((np.arange(b2, b4 + 1), np.arange(b3 + 1))) - b1
#     # v = np.concatenate((2 * (1 - pm[b2 - b1:b4 - b1 + 1]), 2 * pm[:b3 - b1 + 1]))
#     r = np.concatenate([fp[b2-1:b4]-1, fp[:b3]])
#     c = np.concatenate([np.arange(b2, b4+1), np.arange(1,b3+1)])
#     v = 2 * np.concatenate([1-pm[b2-1:b4], pm[:b3]])
#     return csr_matrix((v, (r, c)), shape=(p, fn2))

# standard mel filter bank implement
def melfb(p, n, fs):
    return librosa.filters.mel(sr=fs, n_fft=n, n_mels=p,norm=None)

# self implement mel filter bank
def mel_filter_bank(n_mels, n_fft, sr):
    def hz_to_mel(hz):
        return 2595 * np.log10(1 + hz / 700)

    def mel_to_hz(mel):
        return 700 * (10**(mel / 2595) - 1)
    
    min_hz, max_hz = 0, sr / 2
    min_mel, max_mel = hz_to_mel(min_hz), hz_to_mel(max_hz)
    mels = np.linspace(min_mel, max_mel, n_mels + 2)
    hz = mel_to_hz(mels)
    bins = np.floor((n_fft + 1) * hz / sr).astype(int)
    filters = np.zeros((n_mels, n_fft // 2 + 1))
    for i in range(1, n_mels + 1):
        filters[i - 1, bins[i - 1]:bins[i]] = (np.arange(bins[i - 1], bins[i]) - bins[i - 1]) / (bins[i] - bins[i - 1])
        filters[i - 1, bins[i]:bins[i + 1]] = 1 - (np.arange(bins[i], bins[i + 1]) - bins[i]) / (bins[i + 1] - bins[i])
    return filters

