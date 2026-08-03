import os
import uuid
from urllib.parse import urljoin

import boto3
from botocore.exceptions import ClientError

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


ALLOWED_IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp"}


def upload_image_to_r2(file_obj, folder="perfis"):
    if not file_obj:
        return None

    original_name = getattr(file_obj, "name", "upload")
    ext = os.path.splitext(original_name)[1].lower()

    if ext not in ALLOWED_IMAGE_EXTENSIONS:
        raise ValueError(
            f"Extensão não permitida: {ext}. Use: {', '.join(sorted(ALLOWED_IMAGE_EXTENSIONS))}"
        )

    s3_client = boto3.client(
        "s3",
        region_name=settings.AWS_S3_REGION_NAME,
        endpoint_url=settings.AWS_S3_ENDPOINT_URL,
        aws_access_key_id=settings.AWS_S3_ACCESS_KEY_ID,
        aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
    )

    key = f"{folder.rstrip('/')}/{uuid.uuid4().hex}{ext}"

    s3_client.upload_fileobj(
        file_obj,
        settings.AWS_STORAGE_BUCKET_NAME,
        key,
        ExtraArgs={
            "ContentType": getattr(file_obj, "content_type", "application/octet-stream"),
            "ACL": "public-read",
        },
    )

    base_url = os.environ.get("R2_PUBLIC_URL", "")
    if base_url:
        return f"{base_url.rstrip('/')}/{key}"

    return f"{settings.AWS_S3_ENDPOINT_URL}/{settings.AWS_STORAGE_BUCKET_NAME}/{key}"
