import Image

def run(img):
    im = Image.fromarray(img)
    im.save("../bin/your_file.jpg")