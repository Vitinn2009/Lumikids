from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

from routes.auth import auth_bp

app.register_blueprint(auth_bp)

if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=5000,
        debug=True
    )