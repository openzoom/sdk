import deepzoom
import glob
import os.path
import shutil

if not os.path.exists("images/suitcases"):
    os.mkdir("images/suitcases")

images = glob.glob("assets/suitcases/*-content.png")
creator = deepzoom.ImageCreator(tile_format="png")

for image in images:
    output = "images/suitcases/" + os.path.splitext(os.path.basename(image))[0] + "/image.dzi"
    creator.create(image, output)

#shutil.copytree("assets/buttons/", "images/buttons")

print "Done."