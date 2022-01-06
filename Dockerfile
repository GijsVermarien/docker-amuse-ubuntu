FROM ubuntu:20.04

# Pull AMUSE from Github
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y git wget build-essential curl g++ gfortran gettext zlib1g-dev screen python3-dev \
  mpich libmpich-dev \
  libgsl0-dev cmake libfftw3-3 libfftw3-dev \
  libgmp3-dev libmpfr-dev \
  libhdf5-serial-dev hdf5-tools \
  python3-nose python3-numpy python3-setuptools python3-docutils \
  python3-h5py python3-setuptools git openjdk-8-jdk python3-pip \ 
  libatlas-base-dev libblas-dev liblapack-dev

RUN --mount=type=ssh mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh git clone git@github.com:amusecode/amuse.git

# ensure we use a version of AMUSE that is a point release.
RUN cd amuse && git checkout v2021.7.0.2

RUN pip3 install cython scipy matplotlib mpi4py numpy pandas tqdm tables ipython

ENV FC gfortran
ENV F77 gfortran

RUN cd /amuse/ && pip3 install -e ./

RUN cd /amuse/ && python3 setup.py develop_build

ENV PATH /amuse/:${PATH}

# RUN ["ipython3"]
ENTRYPOINT ["tail", "-f", "/dev/null"]
