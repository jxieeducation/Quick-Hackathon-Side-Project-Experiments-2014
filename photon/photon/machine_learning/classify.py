import sys
from argparse import ArgumentParser
from iris import *
from skimage.util import img_as_ubyte
from skimage.data import imread
from svm import SVM, load
from features import FeatureExtractor
from hashme import *
from data import *
import subprocess
import os
from train import *
from wallet import *

parser = ArgumentParser()

parser.add_argument('path')
parser.add_argument('pin')

def machine_learning(path, pin, let_pass = False):
    vector = feature(path, FeatureExtractor(set(['daisy', 'hog', 'raw'])))
    classifier = load('rf')
    prediction = classifier.predict(vector)
    # print abs(prediction[2][0] - prediction[2][1])
    root_os = "/root/photon/photon/"
    import subprocess
    if let_pass == False and abs(prediction[2][0] - prediction[2][1]) <= 0.05:
        f = path.split('/')[-1]
        name = f.split('-')[0]
        import pickledb
        db = pickledb.load("train.db", False)
        w = db.lgetall("character")
        if len(w) == 0:
            newval = 1
        else:
            last_dict = w[len(w) - 1]
            newval = last_dict[last_dict.keys()[0]] + 1
        db.ladd("character", {name: newval})
        db.dump()
        #so first move all the pics to the train directory
        subprocess.call("mv " + root_os + "bin/* " + root_os + "train/", shell=True)
        #then re-train all the data #and finally done!
        subprocess.call("mv " + root_os + "model/* " + root_os + "trashcan/", shell=True)
        subprocess.call("python " + root_os + "machine_learning/train.py " + root_os + "train", shell=True)
        #we output a key nonetheless
        #aka re-run
        machine_learning(root_os + "train/" + name + "-0.jpg", pin, True)
        exit(-1)
    #print prediction[1].split('/')[-1]
    final_vector = feature(prediction[1], FeatureExtractor(set(['daisy', 'hog', 'raw'])))
    subprocess.call("rm " + root_os + "bin/*", shell = True)
    key_info =  hashing(final_vector, pin)
    print correction(key_info[0])
    print key_info[1]
    print key_info[2]

    #write_to_file(prediction[1].split('/')[-1])

if __name__ == "__main__":
    clear_file()
    args = parser.parse_args()
    machine_learning(args.path, int(args.pin))
