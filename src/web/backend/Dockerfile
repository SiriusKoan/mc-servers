FROM python:3.8-alpine
WORKDIR /app
ADD requirements.txt /app/
RUN pip install -r requirements.txt
CMD ["flask", "run", "--host", "0.0.0.0"]
