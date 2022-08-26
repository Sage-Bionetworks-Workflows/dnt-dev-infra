import asyncio
import os

from prefect import flow
from prefect.filesystems import S3

s3_block = S3.load("s3-test-block")

@flow
async def test_s3_block():
    response = s3_block.write_path("hello-world.txt", b"Hello, World!")
    await response
