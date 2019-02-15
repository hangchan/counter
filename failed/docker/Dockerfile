FROM python:3.7-alpine

# Setup flask application
RUN mkdir -p /deploy/app
COPY app /deploy/app
RUN pip install --upgrade pip
RUN pip install gunicorn
RUN pip install -r /deploy/app/requirements.txt
WORKDIR /deploy/app

EXPOSE 8000

# Start gunicorn
CMD ["gunicorn", "--bind 0.0.0.0:8000", "app:app"]
