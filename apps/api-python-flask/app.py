from flask import Flask, jsonify
app = Flask(__name__)

@app.route("/healthz")
def health():
    return jsonify(status="ok")

@app.route("/")
def index():
    return jsonify(msg="Hello from secure Flask API")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
