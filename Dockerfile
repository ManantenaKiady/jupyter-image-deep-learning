FROM nvidia/cuda

ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV NB_USER kiady
ENV NB_UID 1000

RUN apt-get update && \
    apt-get install -y wget git libhdf5-dev g++ graphviz

RUN mkdir -p $CONDA_DIR && \
	echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh && \
	wget --quiet --output-document=anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh && \
	/bin/bash /anaconda.sh -f -b -p $CONDA_DIR && \
	rm anaconda.sh

RUN useradd -ms /bin/bash -N -u $NB_UID $NB_USER

RUN mkdir -p $CONDA_DIR && \
	chown kiady $CONDA_DIR -R && \
	mkdir -p /src && \
	chown kiady /src

RUN pip install --upgrade pip && \
	pip install tensorflow-gpu==2.0.0-rc1 && \ 
	conda install --yes pandas matplotlib jupyterlab && \
	pip install cairocffi editdistance scikit-image opencv-python pillow && \ 
	pip install keras bokeh dask scikit-learn scikit-surprise xgboost && \
	conda install --yes -c anaconda pytorch-gpu &&\
	conda clean -yt

VOLUME ["/src"]
USER kiady
WORKDIR /src
EXPOSE 8888
CMD jupyter lab --port=8888 --ip=0.0.0.0

