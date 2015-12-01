photon 
======
   
http://photon-coin.com/
   
Boost Bitcoin Hackathon - bitcoin wallet identification system (iris recognition)

Uses the human eye as an identification tool to create a bitcoin wallet with an unique pair of public and private keys.

Techniques: machine learning (random forest), computer vision

Install:
```
sudo apt-get install yum python-opencv python-scipy python-numpy python-pygame python-setuptools python-pip
sudo yum install numpy scipy python-matplotlib ipython python-pandas sympy python-nose
sudo pip install nose pycoin argparse scikit-learn scikit-image pickledb
sudo pip install https://github.com/sightmachine/SimpleCV/zipball/develop
easy_install cython
```

To train the database for machine learning:
```
cd photon
bash run train
```

Identifying an image
```
bash run image input_test_image_here
```

Run the built-in tests:
```
bash run test
```
