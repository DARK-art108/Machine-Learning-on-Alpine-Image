FROM alpine:3.7

ENV MAIN_PKGS="\
        tini curl ca-certificates python3 py3-numpy \
        py3-numpy-f2py freetype jpeg libpng libstdc++ \
        libgomp graphviz font-noto openssl" \
    BUILD_PKGS="\
        build-base linux-headers python3-dev cython-dev py-setuptools git \
        cmake jpeg-dev libffi-dev gfortran openblas-dev \
        py-numpy-dev freetype-dev libpng-dev libexecinfo-dev" \
    PIP_PKGS="\
        pyyaml pymkl cffi scikit-learn pandas \
        matplotlib ipywidgets notebook requests \
        pillow graphviz seaborn" \
    CONF_DIR="~/.ipython/profile_default/startup"

RUN set -ex; \
    apk update; \
    apk upgrade; \
    echo http://dl-cdn.alpinelinux.org/alpine/edge/main | tee /etc/apk/repositories; \
    echo http://dl-cdn.alpinelinux.org/alpine/edge/testing | tee -a /etc/apk/repositories; \
    echo http://dl-cdn.alpinelinux.org/alpine/edge/community | tee -a /etc/apk/repositories; \
    apk add --no-cache ${MAIN_PKGS}; \
    python3 -m ensurepip; \
    rm -r /usr/lib/python*/ensurepip; \
    pip3 --no-cache-dir install --upgrade pip setuptools wheel; \
    apk add --no-cache --virtual=.build-deps ${BUILD_PKGS}; \
    pip install -U --no-cache-dir ${PIP_PKGS}; \
    ln -sf pip3 /usr/bin/pip; \
    ln -sf /usr/bin/python3 /usr/bin/python; \
    ln -s locale.h /usr/include/xlocale.h; \
    mkdir /opt && cd /opt; \
    git clone --recursive https://github.com/dmlc/xgboost; \
    sed -i '/#define DMLC_LOG_STACK_TRACE 1/d' /opt/xgboost/dmlc-core/include/dmlc/base.h; \
    sed -i '/#define DMLC_LOG_STACK_TRACE 1/d' /opt/xgboost/rabit/include/dmlc/base.h; \
    cd /opt/xgboost; make -j4; \
    cd /opt/xgboost/python-package; \
    python setup.py install; \
    apk del .build-deps; \
    rm /usr/include/xlocale.h; \
    rm -rf /root/.cache; \
    rm -rf /root/.[acpw]*; \
    rm -rf /var/cache/apk/*; \
    find /usr/lib/python3.6 -name __pycache__ | xargs rm -r; \
    jupyter nbextension enable --py widgetsnbextension; \
    mkdir -p ${CONF_DIR}/; \
    echo "import warnings" | tee ${CONF_DIR}/config.py; \
    echo "warnings.filterwarnings('ignore')" | tee -a ${CONF_DIR}/config.py; \
    echo "c.NotebookApp.token = u''" | tee -a ${CONF_DIR}/config.py

WORKDIR /notebooks

EXPOSE 8888

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["jupyter", "notebook", "--port=8888", "--no-browser", \
    "--allow-root", "--ip=0.0.0.0", "--NotebookApp.token="]
