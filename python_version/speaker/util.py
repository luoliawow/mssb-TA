import librosa
import numpy as np

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

