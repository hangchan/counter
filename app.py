import os
from flask import Flask, jsonify
from flask_redis import FlaskRedis

LOCAL_REDIS = 'redis://localhost:6379'

app = Flask(__name__)
app.config['REDIS_URL'] = os.environ.get("REDIS_URL", default=LOCAL_REDIS)
redis_store = FlaskRedis(app)


def get_counter_from_redis():
    cnt = redis_store.get('counter')
    return 0 if cnt is None else int(cnt)


def set_counter_in_redis(cnt):
    redis_store.set('counter', str(cnt))


@app.route('/api/counter')
def counter():
    return jsonify({'counter': get_counter_from_redis()})


@app.route('/api/counter/increment')
def increment():
    cnt = (get_counter_from_redis() + 1) % 10
    set_counter_in_redis(cnt)
    return jsonify({'counter': cnt})
