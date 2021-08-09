import platform
from fastapi import FastAPI
import platform, socket, re, uuid, psutil

app = FastAPI()


def get_system_info():
    info = {}
    info["platform"] = platform.system()
    info["platform-release"] = platform.release()
    info["platform-version"] = platform.version()
    info["architecture"] = platform.machine()
    info["hostname"] = socket.gethostname()
    info["ip-address"] = socket.gethostbyname(socket.gethostname())
    info["mac-address"] = ":".join(re.findall("..", "%012x" % uuid.getnode()))
    info["processor"] = platform.processor()
    info["ram"] = str(round(psutil.virtual_memory().total / (1024.0 ** 3))) + " GB"
    return info


@app.get("/")
def read_root():
    return get_system_info()
