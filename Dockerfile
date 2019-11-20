FROM python:3.8.0-slim as builder
RUN apt-get update \
&& apt-get install gcc -y \
&& apt-get clean
COPY requirements.txt /app/requirements.txt
WORKDIR app
RUN pip install --user -r requirements.txt
COPY . /app

FROM python:3.8.0-slim as app
COPY --from=builder /root/.local /root/.local
COPY --from=builder /app/main.py /app/main.py
WORKDIR app
ENV PATH=/root/.local/bin:$PATH
ENTRYPOINT uvicorn main:app --reload --host 0.0.0.0 --port 1234