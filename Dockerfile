FROM fedora:35

RUN  dnf install -y         \
      python3               \
      python3-pip           \
  && pip3 install --upgrade \
      pip                   \
  && pip3 install --upgrade \
      jupyterlab            \
      matplotlib            \
      numpy                 \
      pandas                \
      seaborn

WORKDIR /data
ENTRYPOINT ["jupyter-lab", "--allow-root", "--no-browser"]