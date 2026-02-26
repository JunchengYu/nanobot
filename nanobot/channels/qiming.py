"""Qiming channel implementation using FastAPI to receive webhook requests."""

import asyncio

from loguru import logger

from nanobot.config.schema import QimingConfig

try:
    # Import packages required for receive qiming webhook requests
    from fastapi import FastAPI, Request

    QIMING_AVAILABLE = True
except ImportError:
    QIMING_AVAILABLE = False
    pass


class QimingChannel(Channel):
    """Qiming channel implementation."""

    name = "qiming"

    def __init__(self, name: str, config: dict):
        super().__init__(name, config)
        self.config: QimingConfig = config

    async def start(self) -> None:
        """Start the Qiming FastAPI server."""
        if not QIMING_AVAILABLE:
            logger.error("Qiming FastAPI not installed. Run: pip install -r requirements.txt")
            return
        
        # @TODO: Unfinished
