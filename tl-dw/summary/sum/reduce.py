# -*- coding: utf-8 -*-
from collections import defaultdict
import re

MAX_SUMMARY_SIZE = 600

def tokenize(text):
    return text.split()

def split_to_sentences(text):
    sentences = []
    start = 0
    #regex train
    for match in re.finditer('(\s*[.!?]\s*)|(\n{2,})', text):
        sentences.append(text[start:match.end()].strip())
        start = match.end()
    if start < len(text):
        sentences.append(text[start:].strip())
    return sentences

def token_frequency(text):
    frequencies = defaultdict(int)
    for token in tokenize(text):
        frequencies[token] += 1
    return frequencies

def sentence_score(sentence, frequencies, keywords = None):
    score = sum((frequencies[token] for token in tokenize(sentence)))
    if keywords != None:
        for word in keywords:
            if word in sentence:
                score += 2
    return score

def create_summary(sentences, original_sentences, max_length, keywords = None):
    summary = []
    size = 0
    for sentence in sentences:
        summary.append(sentence)
        size += len(sentence)
        if size >= max_length:
            break
    summary = summary[:max_length]

    #basically puts everything in order
    for index in range(len(summary)):
        iSmall = index
        for i in range(index,len(summary)):
            if original_sentences.index(summary[iSmall]) > original_sentences.index(summary[i]):
                iSmall = i
        summary[index], summary[iSmall] = summary[iSmall], summary[index]
    return '\n'.join(summary)


def summarize(text, max_summary_size=None, keywords = None):
    if max_summary_size == None:
        size = len(text) / 5
    frequencies = token_frequency(text)
    sentences = split_to_sentences(text)
    original_sentences = ""
    for sentence in sentences:
        original_sentences += sentence 
    sentences.sort(key=lambda s: sentence_score(s, frequencies), reverse=1)
    summary = create_summary(sentences, original_sentences, max_summary_size)
    return summary


def test(size=MAX_SUMMARY_SIZE):
    text = '''
    A city councillor is calling on mayoral candidates to change the formula used to assess the value of older homes.

Mynarski's Ross Eadie said some residents in his ward in the inner city are losing their homes as the assessed value of their homes skyrockets, hitting them with big property tax bills.

Eadie said homeowners in older, less affluent neighbourhoods have seen reassessments triggering property tax bills as much as 53 per cent higher since 2009.

He said Winnipeggers who own new homes in the suburbs, who aren't seeing drastic changes in their reassessments, aren't paying their fair share of property taxes.

"What I am saying is these suburbs right now, like Sage Creek, they are paying less," he said. "They are paying less of the property tax. But we have to provide services to [them], [like] bus service, fire service, all this stuff."

Eadie said some people are losing their homes because they can't afford the property taxes and it should be a major issue in the coming municipal election.

"The value of those homes are really increasing a lot," he said. "More than they would have been able to afford based on the income in which they purchased it. So they are asset-wealthy and they are cash-poor."

Eadie also took aim at property taxes on commercial properties, saying they should be higher. 

He said one way to address the inequity would be to base property taxes on the average value of a home.

Below is a City of Winnipeg document Eadie used to explain his comments.
    '''
    size = len(text) / 6
    print(summarize(text, size))