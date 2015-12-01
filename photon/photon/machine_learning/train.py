from argparse import ArgumentParser
from data import Dataset
from iris import feature
from svm import SVM, save
from nearest_neightbor import nearest_neightbor
from rf import RF
from features import Collection, FeatureExtractor
import numpy as np
import sys

parser = ArgumentParser()
parser.add_argument('path')

classes = {}

import pickledb
db = pickledb.load("train.db", False)
w = db.lgetall("character")
for i in w:
    classes[i.keys()[0]] = i[i.keys()[0]]

if __name__ == "__main__":
    args = parser.parse_args()
    path = args.path
    d = Dataset(path, '.jpg')
    X = np.array([])
    y = np.array([])
    files = {}
    for img_path in d.images:
        f = img_path.split('/')[-1]
        name = f.split('-')[0]
        c = classes[name]
        vector = feature(img_path, FeatureExtractor(set(['daisy', 'hog', 'raw'])))
        if X.shape[0] == 0:
            X = vector
        else:
            X = np.vstack([X, vector])

        if y.shape[0] == 0:
            y = np.array([c])
        else:
            y = np.vstack([y, c])
        if c not in files:
            files[c] = []
        files[c].append(img_path)
    X = np.matrix(X)
    y = np.matrix(y)
    data = Collection(X, y)

    classifier = RF(50, files)
    classifier.train(data)
    save(classifier, 'rf')