import requests

from django.conf import settings
from django.core.mail.backends.base import BaseEmailBackend


class ResendEmailBackend(BaseEmailBackend):
    api_url = "https://api.resend.com/emails"

    def __init__(self, fail_silently=False, **kwargs):
        super().__init__(fail_silently=fail_silently, **kwargs)
        self.api_key = getattr(settings, "RESEND_API_KEY", "")
        self.from_email = getattr(settings, "RESEND_FROM_EMAIL", "") or getattr(
            settings,
            "DEFAULT_FROM_EMAIL",
            "webmaster@localhost",
        )
        self.timeout = float(getattr(settings, "EMAIL_REQUEST_TIMEOUT_SECONDS", 10))

    def send_messages(self, email_messages):
        if not email_messages:
            return 0

        if not self.api_key:
            error = RuntimeError("RESEND_API_KEY nao configurada.")
            if self.fail_silently:
                return 0
            raise error

        sent_count = 0
        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json",
            "Accept": "application/json",
        }

        for message in email_messages:
            recipients = [recipient for recipient in message.recipients() if recipient]
            if not recipients:
                continue

            payload = {
                "from": self.from_email,
                "to": recipients,
                "subject": message.subject or "",
                "text": message.body or "",
            }

            html_body = None
            for content, mimetype in getattr(message, "alternatives", []):
                if mimetype == "text/html":
                    html_body = content
                    break

            if html_body:
                payload["html"] = html_body

            print("[MAIL][resend] start", recipients, f"timeout={self.timeout}")

            try:
                response = requests.post(
                    self.api_url,
                    json=payload,
                    headers=headers,
                    timeout=self.timeout,
                )
                response.raise_for_status()
                sent_count += 1
                print("[MAIL][resend] ok", recipients, response.status_code)
            except requests.RequestException as exc:
                print(
                    "[MAIL][resend] failed",
                    recipients,
                    exc.__class__.__name__,
                    str(exc),
                )
                if not self.fail_silently:
                    raise

        return sent_count
