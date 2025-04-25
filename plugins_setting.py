import os

ENABLED_PLUGINS = os.environ.get("ENABLED_PLUGINS", "").split(",") if os.environ.get("ENABLED_PLUGINS") else []
