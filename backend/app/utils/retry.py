"""
Retry utilities with exponential backoff.
"""
from tenacity import (
    retry,
    stop_after_attempt,
    wait_exponential,
    retry_if_exception_type,
)
from openai import APIError, RateLimitError, APIConnectionError


# Retry decorator for OpenAI API calls
# Retries 3 times with exponential backoff: 2s, 4s, 8s
retry_openai = retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=2, min=2, max=8),
    retry=retry_if_exception_type((APIError, RateLimitError, APIConnectionError)),
    reraise=True,
)
