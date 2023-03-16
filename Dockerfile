FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-devel

WORKDIR /workspace

RUN apt-get update
RUN apt-get install -y git espeak-ng cmake

RUN pip install torchaudio --extra-index-url https://download.pytorch.org/whl/cu116
RUN pip install torchmetrics==0.11.1
RUN pip install librosa==0.8.1
RUN pip install phonemizer

# for dataset preparation
RUN pip install matplot
RUN pip install h5py


RUN pip install git+https://github.com/lhotse-speech/lhotse@62cd1842e719d7e33616f5ca75874d215545399e


RUN git clone https://github.com/k2-fsa/k2.git && \
    cd k2 && \
    git checkout 9acf87444c3997a21b715ea6c7fca8325dfa8eb8 -b temp && \
    # git checkout v1.23.4 -b temp && \
    export K2_MAKE_ARGS="-j12" && \
    export K2_CMAKE_ARGS="-DK2_WITH_CUDA=OFF" && \
    # pip install git+https://github.com/k2-fsa/k2.git@9acf87444c3997a21b715ea6c7fca8325dfa8eb8 && \
    pip install .


RUN git clone https://github.com/k2-fsa/icefall && \
    cd icefall && \
    git checkout f5de2e90c6672a843d5e94166fbd60f339cb6b9b -b temp && \
    pip install .

ENV PYTHONPATH=/workspace/icefall:${PYTHONPATH}

## Devel
RUN git clone https://github.com/lifeiteng/valle.git && \
    cd valle && \
    pip install -e .
