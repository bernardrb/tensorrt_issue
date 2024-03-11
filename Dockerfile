# syntax=docker/dockerfile:1

ARG BASE_IMAGE

FROM ${BASE_IMAGE} as base

WORKDIR /app

ARG UID
ARG GID

ENV CUDA_MODULE_LOADING=LAZY
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update
RUN apt-get install -y cmake build-essential libgl1-mesa-glx



RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/home/appuser" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser


RUN groupmod -g ${GID} appuser

COPY ./libs/efficientvit-0.1.0-py2.py3-none-any.whl /app/libs/efficientvit-0.1.0-py2.py3-none-any.whl

RUN --mount=type=bind,source=requirements.txt,target=requirements.txt \
    python -m pip install -r requirements.txt

COPY . .

RUN  chown ${UID}  /app/scripts/quantize.sh
RUN  chown ${UID}  /app/scripts/inference.sh
