#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python -p python3Packages.boto3

import asyncio
from concurrent.futures import ThreadPoolExecutor
import functools
from typing import Any, AsyncIterable, Awaitable, Callable, Optional, TypeVar, cast
from os import path
import datetime
import json

import boto3
from botocore.response import StreamingBody

ENDPOINT_URL: str = "https://cache.int.chir.rs"
BUCKET_NAME: str = "nix-cache"

yesterday = datetime.datetime.now().replace(
    tzinfo=datetime.timezone.utc) - datetime.timedelta(days=1)

executor: ThreadPoolExecutor = ThreadPoolExecutor()

F = TypeVar('F', bound=Callable[..., Any])
T = TypeVar('T')


def aio(f: Callable[..., T]) -> Callable[..., Awaitable[T]]:
    async def aio_wrapper(*args: Any, **kwargs: Any) -> T:
        f_bound: Callable[[], T] = functools.partial(f, *args, **kwargs)
        loop: asyncio.AbstractEventLoop = asyncio.get_running_loop()
        return await loop.run_in_executor(executor, f_bound)
    return aio_wrapper


@aio
def exists_locally(store_path: str) -> bool:
    return path.exists(store_path)


class NarInfo(object):
    def __init__(self, narinfo: str) -> None:
        self.compression = "bzip2"
        for narinfo_line in narinfo.splitlines():
            key, value = narinfo_line.split(": ", 1)
            if key == "StorePath":
                self.store_path = value
            elif key == "URL":
                self.url = value
            elif key == "Compression":
                self.compression = value
            elif key == "FileHash":
                self.file_hash = value
            elif key == "FileSize":
                self.file_size = int(value)
            elif key == "NarHash":
                self.nar_hash = value
            elif key == "NarSize":
                self.nar_size = int(value)
            elif key == "References":
                self.references = value.split()
            elif key == "Deriver":
                self.deriver = value
            elif key == "System":
                self.system = value
            elif key == "Sig":
                self.sig = value
            elif key == "CA":
                self.ca = value

    async def exists_locally(self) -> bool:
        return await exists_locally(self.store_path)


s3 = boto3.client("s3", endpoint_url=ENDPOINT_URL)


@aio
def get_object(Key: str) -> str:
    obj = s3.get_object(Bucket=BUCKET_NAME, Key=Key)
    if "Body" not in obj:
        raise Exception("No Body")
    if isinstance(obj["Body"], StreamingBody):
        return obj["Body"].read().decode("utf-8")
    raise Exception("Not StreamingBody")


async def list_old_cache_objects() -> AsyncIterable[str]:
    @aio
    def list_objects_v2(
        ContinuationToken: Optional[str]
    ) -> dict[str, Any]:
        if ContinuationToken != None:
            return s3.list_objects_v2(
                Prefix="realisations/",
                Bucket=BUCKET_NAME,
                ContinuationToken=ContinuationToken
            )
        else:
            return s3.list_objects_v2(
                Prefix="realisations/",
                Bucket=BUCKET_NAME
            )
    cont_token = None
    while True:
        objs = await list_objects_v2(cont_token)
        if "Contents" not in objs:
            raise Exception("No Contents")
        if isinstance(objs["Contents"], list):
            for obj in cast(list[Any], objs["Contents"]):
                if not isinstance(obj, dict):
                    raise Exception("Not dict")
                obj = cast(dict[str, Any], obj)
                if "LastModified" in obj and isinstance(obj["LastModified"], datetime.datetime):
                    if obj["LastModified"] < yesterday:
                        yield obj["Key"]

        if "NextContinuationToken" not in objs:
            break
        cont_token = objs["NextContinuationToken"]


@aio
def delete_object(key: str) -> None:
    s3.delete_object(Bucket=BUCKET_NAME, Key=key)


async def main() -> None:
    async for obj_key in list_old_cache_objects():
        if obj_key.endswith(".narinfo"):
            narinfo = await get_object(obj_key)
            narinfo = NarInfo(narinfo)
            if not await narinfo.exists_locally():
                print(f"Found unused NAR for {narinfo.store_path}")
                await delete_object(obj_key)
                await delete_object(narinfo.url)
        if obj_key.startswith("realisations/"):
            realisation = await get_object(obj_key)
            realisation = json.loads(realisation)
            if not isinstance(realisation, dict):
                continue
            if "outPath" not in realisation:
                continue
            if not await exists_locally("/nix/store/" + realisation["outPath"]):
                print(f"Found unused realisation for {realisation['outPath']}")
                await delete_object(obj_key)

if __name__ == "__main__":
    asyncio.get_event_loop().run_until_complete(main())
