from src.hello import add


def test_BasicAddition() -> None:
    assert add(2, 3) == 5
