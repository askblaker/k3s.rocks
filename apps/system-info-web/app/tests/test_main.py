from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_get_system_info():
    response = client.get("/")
    assert response.status_code == 200
    expected_keys = [
        "platform",
        "platform-release",
        "platform-version",
        "architecture",
        "hostname",
        "ip-address",
        "mac-address",
        "processor",
        "ram",
    ]
    assert set(expected_keys) == set(response.json().keys())
