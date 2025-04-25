from datetime import timedelta

# Let Saleor do its normal thing
try:
    from saleor.settings import *
except ImportError:
    raise RuntimeError("Failed to load base Saleor settings")

# Apply our override *after* everything else
JWT_TTL_ACCESS = timedelta(minutes=120)


# Don’t use saleor.wsgi.application for runserver (it mis-invokes the health-check wrapper on import)
WSGI_APPLICATION = ""


print("⚡ LOADED settings_patch.py — JWT_TTL_ACCESS:", JWT_TTL_ACCESS.total_seconds())
