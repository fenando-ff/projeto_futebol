from urllib.parse import urljoin

from django.conf import settings
from django.templatetags.static import static


def build_public_image_url(image_path, public_base_url=None):
    if not image_path:
        return None

    value = str(image_path).strip()
    if not value:
        return None

    if value.startswith(("http://", "https://", "//")):
        return value

    normalized_path = value.lstrip("/")
    base_url = public_base_url or getattr(settings, "R2_PUBLIC_URL", "") or ""

    if base_url:
        return urljoin(f"{base_url.rstrip('/')}/", normalized_path)

    return static(normalized_path)
