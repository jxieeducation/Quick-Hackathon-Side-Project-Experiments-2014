def load_subtitles(os_dir):
	with open(os_dir + "0.srt", 'r') as f:
		read_data = f.readlines()
	return read_data

def extract_items(read_data):
	transcript = []
	passage = ""
	key = " "
	for line in read_data:
		if line == '\n':
			continue
		line = line[:len(line) - 1]
		if line.isdigit():
			continue
		if key == " " and line[0] == "0":
			key = line
		elif key != " ":
			temp = [key, line]
			transcript += [temp]
			passage += line
			passage += " "
			key = " "

	if passage.count('.') < 15:
		stash_count = 0
		passage = ""
		key = " "
		for line in read_data:
			if line == '\n':
				continue
			line = line[:len(line) - 1]
			if line.isdigit():
				continue
			if key == " " and line[0] == "0":
				key = line
			elif key != " ":
				passage += line
				if len(line.split()) > 7 and stash_count > 3:
					passage += ". "
					stash_count = 0
				else:
					passage += " "
					stash_count += 1
				key = " "
	return transcript, passage

def get_time_stamp(word, transcript):
	for time, sentence in transcript:
		if word in sentence:
			return int(time[0:2]) * 60 * 60 + int(time[3:5]) * 60 + int(time[6:8])

def get_time(list_of_sentences, transcript):
	list_of_time = []
	sum_track = 0
	stash = []
	for pair in transcript:
		time = pair[0]
		sentence = pair[1]
		word = list_of_sentences[sum_track].split()[-1]
		word = word[:len(word) - 1]
		# print word
		if word in sentence:
			for time_slot in stash:
				list_of_time += [time_slot]
			stash = []
			list_of_time += [time]
			sum_track += 1
			if sum_track == len(list_of_sentences):
				break
		elif "." not in sentence:
			stash += [time]
		elif "." in sentence:
			stash = []

	#the rest of the formatting is for youtube's javascript
	time_parse = []
	for time in list_of_time:
		time1 = int(time[0:2]) * 60 * 60 + int(time[3:5]) * 60 + int(time[6:8])
		time2 = int(time[-12:-10]) * 60 * 60 + int(time[-9:-7]) * 60 + int(time[-6:-4])
		time_parse += [(time1, time2)]

	#make sure that the segments are not broken
	time_clean = []
	time_clean += [time_parse[0]]
	for index in range(1, len(time_parse)):
		if abs(time_parse[len(time_clean) - 1][1] - time_parse[index][0]) < 4:
			time_clean += [(time_clean[len(time_clean) - 1][0], time_parse[index][1])]
			del time_clean[-2]
		else:
			time_clean += [time_parse[index]]

	for i in range(0, 55):
		time_parse = time_clean
		time_clean = []
		time_clean += [time_parse[0]]
		for index in range(1, len(time_parse)):
			if abs(time_parse[len(time_clean) - 1][1] - time_parse[index][0]) < 4:
				time_clean += [(time_clean[len(time_clean) - 1][0], time_parse[index][1])]
				del time_clean[-2]
			else:
				time_clean += [time_parse[index]]
	
	delete_list = []
	for time in time_clean:
		if abs(time[0] - time[1]) < 5:
			delete_list += [time]

	for time in delete_list:
		del time_clean[time_clean.index(time)]

	print time_clean

	time_final = []
	#convert this into return format
	for index in range(len(time_clean) + 1):
		if index == 0:
			time_final += [(0, time_clean[index][0])]
		elif index == len(time_clean):
			time_final += [(time_clean[index - 1][1], -99)]
		else:
			time_final += [(time_clean[index - 1][1], time_clean[index][0])]
	return time_final