
FROM python:3.7-stretch
# ffmpeg for matplotlib anim 
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends ffmpeg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]
RUN useradd -m -s /bin/bash nbuser
USER nbuser
ENV PYTHON /usr/local/bin/python
WORKDIR /home/nbuser/notebooks
COPY src .

CMD ["jupyter", "notebook","--ip='*'","--no-browser",  "--NotebookApp.password=''","--NotebookApp.token=''"]

