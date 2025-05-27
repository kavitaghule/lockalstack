from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/hello')
def hello():
    return jsonify(message="Hello from Flask on port 3000")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)
