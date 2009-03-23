import deepzoom

# Create Deep Zoom Image creator with weird parameters
creator = deepzoom.ImageCreator(tile_size=512, tile_overlap=2, tile_format="png",
                                image_quality=0.8, resize_filter="bicubic")
creator.create("helloworld.jpg", "helloworld.dzi")