ARG PY_VERSION="3.9"
FROM amazon/aws-lambda-python:$PY_VERSION

WORKDIR /var/task
RUN mkdir build output
WORKDIR build

RUN yum install -y zip

RUN python3 -m pip install --no-cache-dir --upgrade \
  pip \
  setuptools \
  wheel
RUN python3 -m pip install --no-cache-dir --upgrade pipenv

COPY src/build_artifact.sh build_artifact.sh
COPY src/Pipfile.lock Pipfile.lock
COPY src/lambda_handler.py lambda_handler.py
RUN pipenv install --ignore-pipfile --site-packages

ENTRYPOINT ["./build_artifact.sh"]
