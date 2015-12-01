from nose.tools import with_setup
import subprocess
import sys

class TestML:
    def test_train_match(self):
        with open("../result.txt") as f:
            content = f.readline()
            f.close()
            content = content[0:64]
            assert len(content) == 64
            for i in content:
                if i.isdigit():
                    if int(i) < 0 or int(i) > 9:
                        assert False
                elif i != ' ':
                    if i < 'A' or i > 'Z':
                        assert False
    
    def test_all_train_cases(self):
        print "machine_learning test is not activated yet"
        # d = Dataset("../train", '.jpg')
        # X = np.array([])
        # y = np.array([])
        # files = {}
        # for img_path in d.images:
        #     machine_learning(img_path)
        #     name = img_path.split('/')[-1].split('-')[0]
        #     with open("../result.txt") as f:
        #         content = f.readlines()[1]
        #         if content.contains('Doubt'):
        #             assert False
        #         if not content.contains(name):
        #             assert False
    