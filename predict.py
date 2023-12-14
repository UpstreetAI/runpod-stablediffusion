# Prediction interface for Cog ⚙️
# https://github.com/replicate/cog/blob/main/docs/python.md

from cog import BasePredictor, Input, Path
from typing import Any
import os 
from handler.rp_handler import wait_for_service, run_inference
import json

class Predictor(BasePredictor):
    def setup(self) -> None:
        """Load the model into memory to make running multiple predictions efficient"""
        # self.model = torch.load("./weights.pth")
        os.system("chmod +x /src/handler/start.sh && sh /src/handler/start.sh")
        wait_for_service()

    def predict(
        self,
        type: str = Input(description="GET or POST"),
        url: str = Input(description="sdapi/v1/txt2img"),
        inference_request: str = Input(description="json string request of SDAPI")
    ) -> Path:
        inference_request = json.loads(inference_request)
        return run_inference(type, url, inference_request)
        """Run a single prediction on the model"""
        # processed_input = preprocess(image)
        # output = self.model(processed_image, scale)
        # return postprocess(output)
