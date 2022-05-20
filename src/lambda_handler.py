"""Simple AWS Lambda handler to verify functionality."""

# Standard Python Libraries
from datetime import datetime, timezone
import logging
from typing import Optional

# Third-Party Libraries
import cowsay
import cowsay.characters

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context) -> dict[str, Optional[str]]:
    """Accept a character and message to generate a cowsay output string.

    :param event: The event dict that contains the parameters sent when the function
                  is invoked.
    :param context: The context in which the function is called.
    :return: The result of the action.
    """
    response: dict[str, Optional[str]] = {"timestamp": str(datetime.now(timezone.utc))}
    character: str = event.get("character", "beavis")
    message: str = event.get("contents", "Hello, World!")

    result: Optional[str]
    if character not in cowsay.characters.CHARS.keys():
        logging.error('Character "%s" is not valid.', character)
        result = None
    else:
        logger.info('Creating output using "%s" with contents "%s"', character, message)
        result = cowsay.get_output_string(character, message)
        logger.debug(result)
    response["message"] = result

    return response
