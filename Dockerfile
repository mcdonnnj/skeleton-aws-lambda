ARG PY_VERSION=3.9

FROM amazon/aws-lambda-python:$PY_VERSION

# Declare it a second time so it's brought into this scope.
ARG PY_VERSION=3.9
# Get the output file name base from the command line if provided
ARG FILE_NAME=skeleton-aws-lambda

# For a list of pre-defined annotation keys and value types see:
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
# Note: Additional labels are added by the build workflow.
LABEL org.opencontainers.image.authors="nicholas.mcdonnell@cisa.dhs.gov"
LABEL org.opencontainers.image.vendor="Cyber and Infrastructure Security Agency"

# Bring the command line ARGs into the ENV so they are available in the
# generated image.
ENV BUILD_PY_VERSION=$PY_VERSION
ENV BUILD_FILE_NAME=$FILE_NAME

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
