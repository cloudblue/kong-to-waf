from typing import Optional

from fastapi import FastAPI, Request, Response, status


app = FastAPI()


@app.get('/{full_path:path}')
async def mock(
    request: Request,
    response: Response,
    full_path: Optional[str] = '',
):
    print(request.headers)

    response.status_code = status.HTTP_200_OK

    if '.exe' in full_path:
        response.status_code = status.HTTP_403_FORBIDDEN

    return response.status_code
