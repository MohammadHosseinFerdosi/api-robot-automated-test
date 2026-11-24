from flask import (
    Flask,
    render_template,
    request,
    jsonify,
)
import subprocess
import logging
import uuid
from threading import Lock
from threading import Thread
import os
import time
import webbrowser
import re
import sys
from werkzeug.middleware.proxy_fix import ProxyFix

import json
import mysql.connector
import mysql.connector.pooling
from redis.sentinel import Sentinel


PREFIX = "/cortex"

robot_path = os.path.join(sys.prefix, "Scripts" if os.name == "nt" else "bin", "robot")


class AutoPrefix:
    def __init__(self, app, default_prefix=PREFIX):
        self.app = app
        self.default_prefix = default_prefix
        self.log = logging.getLogger("AutoPrefix")

    def __call__(self, environ, start_response):
        path_info = environ.get("PATH_INFO", "") or "/"
        hdr_prefix = environ.get("HTTP_X_FORWARDED_PREFIX")
        prefix = hdr_prefix or self.default_prefix

        if prefix and path_info.startswith(prefix):
            environ["SCRIPT_NAME"] = prefix
            environ["PATH_INFO"] = path_info[len(prefix) :] or "/"
            self.log.debug(
                "Stripped prefix %r -> PATH_INFO=%r", prefix, environ["PATH_INFO"]
            )
        else:
            self.log.debug("No prefix strip applied. PATH_INFO=%r", path_info)

        return self.app(environ, start_response)


app = Flask(__name__)

app.wsgi_app = AutoPrefix(app.wsgi_app, default_prefix=PREFIX)
app.wsgi_app = ProxyFix(app.wsgi_app, x_prefix=1, x_proto=1, x_host=1)


# Setups

BASE_DIR = os.path.abspath(os.path.dirname(__file__))
ROBOT_SOURCE_PATH = os.path.join(BASE_DIR, "source", "scripts.robot")
ROBOT_PACKAGES_PATH = "src"
ROBOT_ENV_PATH = "src/config/environment-stage.yaml"

session_logs = {}
session_logs_lock = Lock()


## Settings: OTP Catcher

MYSQL_HOST = os.getenv("MYSQL_DB_DEFAULT_HOST", "10.198.111.65")
MYSQL_PORT = int(os.getenv("MYSQL_DB_DEFAULT_PORT", "3306"))
MYSQL_USER = os.getenv("MYSQL_DB_DEFAULT_USER", "user_user")
MYSQL_PASS = os.getenv("MYSQL_DB_DEFAULT_PASS", "123456")
MYSQL_DB = os.getenv("MYSQL_DB_DEFAULT_NAME", "user_db")

REDIS_OTP_SENTINEL_HOSTS = os.getenv(
    "REDIS_OTP_SENTINEL_HOSTS", "10.198.13.43,10.198.13.44,10.198.13.45"
).split(",")
REDIS_OTP_SENTINEL_PORT = int(os.getenv("REDIS_OTP_SENTINEL_PORT", "26379"))
REDIS_OTP_MASTER_NAME = os.getenv("REDIS_OTP_MASTER_NAME", "redis-new-master")

MYSQL_POOL_SIZE = int(os.getenv("MYSQL_POOL_SIZE", "12"))

mysql_pool = mysql.connector.pooling.MySQLConnectionPool(
    pool_name="otp_mysql_pool",
    pool_size=MYSQL_POOL_SIZE,
    host=MYSQL_HOST,
    port=MYSQL_PORT,
    user=MYSQL_USER,
    password=MYSQL_PASSWORD,
    database=MYSQL_DB,
    autocommit=True,
    connection_timeout=2,
)

_redis_sentinel = Sentinel(
    [(host.strip(), REDIS_OTP_SENTINEL_PORT) for host in REDIS_OTP_SENTINEL_HOSTS],
    socket_connect_timeout=1.2,
    socket_timeout=1.2,
)
redis_client = _redis_sentinel.master_for(
    REDIS_OTP_MASTER_NAME, socket_timeout=1.2, decode_responses=False
)


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/closeStatus")
def status_page_close():
    return render_template("closeStatus.html")


@app.route("/allocationStatus")
def status_page_allocate():
    return render_template("allocationStatus.html")


logging.basicConfig(level=logging.INFO)


@app.route("/fa92b7e9c13d4b8d83a77d6e_secret_oasis_gateway_42f89c7a1d9e8f6")
def easter_egg():
    return render_template(
        "fa92b7e9c13d4b8d83a77d6e_secret_oasis_gateway_42f89c7a1d9e8f6.html"
    )


# Closing
@app.route("/submit-close", methods=["POST"])
def submit_close():
    data = request.json

    session_id = str(uuid.uuid4())

    with session_logs_lock:
        session_logs[session_id] = []

    with session_logs_lock:
        session_logs[session_id].append(f"Close Initiated: {data}")
    logging.info(f"Close Initiated: {data}")

    response = jsonify(
        {"status": "PASS", "message": "Task started", "session_id": session_id}
    )

    thread = Thread(target=run_robot_close_task, args=(data, session_id))
    thread.start()

    return response, 200


def run_robot_close_task(data, session_id):
    close_type = data.get("closeType")
    close_input = data.get("closeInput")

    if "*" in close_input:
        with session_logs_lock:
            session_logs[session_id].append("task execution failed.")
        logging.error("task execution failed.")
        return
    if not re.fullmatch(r"[a-zA-Z0-9-]+", close_input):
        with session_logs_lock:
            session_logs[session_id].append("task execution failed.")
        logging.error("task execution failed.")
        return

    if close_type == "cellNumber":
        with session_logs_lock:
            session_logs[session_id].append(
                f"Close via cellNumber going to start: {close_type}, {close_input}"
            )
        logging.info(
            f"Close via cellNumber going to start: {close_type}, {close_input}"
        )
        command = [
            robot_path,
            "--pythonpath",
            f"{ROBOT_PACKAGES_PATH}",
            "--variablefile",
            f"{ROBOT_ENV_PATH}",
            "--variable",
            f"cellNumber:{close_input}",
            "--task",
            "Close Account By Cell Number",
            ROBOT_SOURCE_PATH,
        ]
    elif close_type == "creditId":
        with session_logs_lock:
            session_logs[session_id].append(
                f"Close via creditId going to start: {close_type}, {close_input}"
            )
        logging.info(f"Close via creditId going to start: {close_type}, {close_input}")

        command = [
            robot_path,
            "--pythonpath",
            f"{ROBOT_PACKAGES_PATH}",
            "--variablefile",
            f"{ROBOT_ENV_PATH}",
            "--variable",
            f"creditId:{close_input}",
            "--task",
            "Close Account By Credit Id",
            ROBOT_SOURCE_PATH,
        ]
    else:
        with session_logs_lock:
            session_logs[session_id].append(
                f"Running Docker command to clean data {close_input}"
            )
        logging.warning(f"Running Docker command to clean data {close_input}")

        command = [
            robot_path,
            "--pythonpath",
            f"{ROBOT_PACKAGES_PATH}",
            "--variablefile",
            f"{ROBOT_ENV_PATH}",
            "--variable",
            f"bad_user_id:{close_input}",
            "--task",
            "Clean Bad Data",
            ROBOT_SOURCE_PATH,
        ]

    with session_logs_lock:
        session_logs[session_id].append(f"Executing command: {' '.join(command)}")
    logging.info(f"Executing command: {' '.join(command)}")

    try:
        result = subprocess.run(command, capture_output=True, text=True, check=False)

        full_output = f"STDOUT:\n{result.stdout}\n\nSTDERR:\n{result.stderr}"

        with session_logs_lock:
            session_logs[session_id].append(f"Full terminal output:\n{full_output}")

        with session_logs_lock:
            session_logs[session_id].append(result.stderr)
        logging.error(result.stderr)

        with session_logs_lock:
            session_logs[session_id].append(
                f"Executing Finished. Going to check return code"
            )
        logging.info(f"Executing Finished. Going to check return code")
        with session_logs_lock:
            session_logs[session_id].append(
                f"Execution return code is {result.returncode}"
            )
        logging.info(f"Execution return code is {result.returncode}")

        if result.returncode == 0:
            with session_logs_lock:
                session_logs[session_id].append("task executed successfully.")
            logging.info("task executed successfully.")
        else:
            with session_logs_lock:
                session_logs[session_id].append("task execution failed.")
            logging.error("task execution failed.")
    except Exception as e:
        with session_logs_lock:
            session_logs[session_id].append("Error while executing task.")
            session_logs[session_id].append(f"Error message : {str(e)}")
        logging.exception("Error while executing task.")


# Allocating
@app.route("/submit-allocation", methods=["POST"])
def submit_allocation():
    data = request.json

    session_id = str(uuid.uuid4())

    with session_logs_lock:
        session_logs[session_id] = []

    with session_logs_lock:
        session_logs[session_id].append(f"Allocation Initiated: {data}")
    logging.info(f"Allocation Initiated: {data}")

    response = jsonify(
        {"status": "PASS", "message": "Task started", "session_id": session_id}
    )

    thread = Thread(target=run_robot_allocation_task, args=(data, session_id))
    thread.start()

    return response, 200


def run_robot_allocation_task(data, session_id):
    cell_number = data.get("cellNumber")
    national_code = data.get("nationalCode")

    with session_logs_lock:
        session_logs[session_id].append(
            f"Allocation is going to start: {cell_number}, {national_code}"
        )
        logging.info(f"Allocation is going to start: {cell_number}, {national_code}")
        python_dict_string = str(data).replace('"', "'")
        command = [
            robot_path,
            "--pythonpath",
            f"{ROBOT_PACKAGES_PATH}",
            "--variablefile",
            f"{ROBOT_ENV_PATH}",
            "--variable",
            f"allocationConfig:{python_dict_string}",
            "--task",
            "Allocate Account",
            ROBOT_SOURCE_PATH,
        ]

    with session_logs_lock:
        session_logs[session_id].append(f"Executing command: {' '.join(command)}")
    logging.info(f"Executing command: {' '.join(command)}")

    try:
        result = subprocess.run(command, capture_output=True, text=True, check=False)

        full_output = f"STDOUT:\n{result.stdout}\n\nSTDERR:\n{result.stderr}"

        with session_logs_lock:
            session_logs[session_id].append(f"Full terminal output:\n{full_output}")

        with session_logs_lock:
            session_logs[session_id].append(result.stderr)
        logging.error(result.stderr)

        with session_logs_lock:
            session_logs[session_id].append(
                f"Executing Finished. Going to check return code"
            )
        logging.info(f"Executing Finished. Going to check return code")
        with session_logs_lock:
            session_logs[session_id].append(
                f"Execution return code is {result.returncode}"
            )
        logging.info(f"Execution return code is {result.returncode}")

        if result.returncode == 0:
            with session_logs_lock:
                session_logs[session_id].append("task executed successfully.")
            logging.info("task executed successfully.")
        else:
            with session_logs_lock:
                session_logs[session_id].append("task execution failed.")
            logging.error("task execution failed.")
    except Exception as e:
        with session_logs_lock:
            session_logs[session_id].append("Error while executing task.")
            session_logs[session_id].append(f"Error message : {str(e)}")
        logging.exception("Error while executing task.")


# Getting the logs
@app.route("/get-logs", methods=["GET"])
def get_logs():
    session_id = request.args.get("session_id")

    with session_logs_lock:
        if session_id in session_logs:
            return jsonify({"logs": session_logs[session_id]})
        else:
            return jsonify({"logs": ["No logs found for this session."]})


# OTP CATCHER
def _extract_latest_otp(payload: dict):
    otp_codes = payload.get("otpCodes")
    values = []

    if isinstance(otp_codes, list):
        for group in otp_codes:
            if isinstance(group, list):
                for item in group:
                    if isinstance(item, dict) and item.get("value") is not None:
                        values.append(str(item["value"]))
            elif isinstance(group, dict) and group.get("value") is not None:
                values.append(str(group["value"]))
    elif isinstance(otp_codes, dict):
        for v in otp_codes.values():
            if isinstance(v, dict) and v.get("value") is not None:
                values.append(str(v["value"]))
            elif isinstance(v, list):
                for item in v:
                    if isinstance(item, dict) and item.get("value") is not None:
                        values.append(str(item["value"]))

    return values[-1] if values else None


def fast_find_otp(cell_number: str):
    conn = None
    cursor = None
    try:
        conn = mysql_pool.get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(
            "SELECT user_id FROM users WHERE cell_number=%s LIMIT 1",
            (cell_number,),
        )
        row = cursor.fetchone()
    finally:
        try:
            if cursor:
                cursor.close()
        except Exception:
            pass
        try:
            if conn:
                conn.close()
        except Exception:
            pass

    if not row or not row.get("user_id"):
        return {"status": "PASS", "message": "No OTP found (user not found).", "otp": None}

    user_id = row["user_id"]

    key = f"auth_otp_{user_id}"
    raw = redis_client.get(key)
    if not raw:
        return {"status": "PASS", "message": "No OTP found (no active OTP in Redis).", "otp": None}

    try:
        s = raw.decode("utf-8", errors="replace")
        if not s or s == "null":
            return {"status": "PASS", "message": "No OTP found (empty payload).", "otp": None}
        payload = json.loads(s)
    except Exception:
        return {"status": "PASS", "message": "No OTP found (unreadable payload).", "otp": None}

    otp = _extract_latest_otp(payload)
    if not otp:
        return {"status": "PASS", "message": "No OTP found (no otpCodes).", "otp": None}

    return {"status": "PASS", "message": "OTP fetched.", "otp": otp}


@app.route("/otp-catcher", methods=["GET"])
def otp_catcher_page():
    return render_template("otpCatcher.html")


@app.route("/otp-catcher/fetch", methods=["GET"])
def otp_catcher_fetch():
    cell_number = (request.args.get("cell_number") or "").strip()
    if not re.fullmatch(r"\+?\d{8,15}", cell_number):
        return jsonify(
            {
                "status": "FAIL",
                "message": "Invalid cell number format. Use digits only (optionally starting with +).",
                "otp": None,
            }
        ), 200

    try:
        data = fast_find_otp(cell_number)

        if data.get("otp"):
            logging.info("OTP fetch cell=%s -> otp=%s", cell_number, data.get("otp"))
        else:
            logging.info("OTP fetch cell=%s -> %s", cell_number, data.get("message"))

        resp = jsonify(data)
        resp.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
        resp.headers["Pragma"] = "no-cache"
        return resp, 200

    except Exception:
        logging.exception("OTP fetch failed unexpectedly.")
        resp = jsonify({"status": "FAIL", "message": "Service error while fetching OTP.", "otp": None})
        resp.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
        resp.headers["Pragma"] = "no-cache"
        return resp, 200

def open_browser(host, port):
    time.sleep(1)
    webbrowser.open_new(f"http://{host}:{port}")


if __name__ == "__main__":
    host = os.getenv("APP_HOST", "0.0.0.0")
    port = int(os.getenv("APP_PORT", "8000"))
    if os.getenv("OPEN_BROWSER", "false").lower() == "true":
        Thread(target=open_browser, args=("localhost", port)).start()
    app.run(host=host, port=port, debug=False)
