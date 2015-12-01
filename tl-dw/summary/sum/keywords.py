import nltk
import nltk.tokenize
from nltk.corpus import wordnet
from nltk.corpus import brown
from nltk.probability import *
from nltk.corpus import stopwords
import re

words = FreqDist()
for sentence in brown.sents():
    for word in sentence:
        words.inc(word.lower())
stop = stopwords.words('english')

def keywords(subject):
    subject = re.findall(r'\w+', subject,flags = re.UNICODE | re.LOCALE)
    unique = set()
    me = nltk.word_tokenize(" ".join(subject))
    for myword in me:
        if len(myword) >= 6 and (words.freq(myword.lower()) < 0.00001):
            unique.add(myword)
    return unique
