#!/usr/bin/python3
import sys
if len(sys.argv) > 1:
	source = sys.argv[1]
	protocol = []
	url = []
	dupe_line = []

	with open(source) as fp:
		for line in fp:
			protocol.append(line.split("://")[0])
			url.append(line.split("://")[1].replace("\n",""))
	def dupe(lst, item):
		hasil = [i for i, x in enumerate(lst) if x == item]
		if len(hasil) >= 2:
			return hasil
	for i in url: 
		if dupe(url, i) not in dupe_line and dupe(url, i) != None:
			dupe_line.append(dupe(url, i))
	for l in dupe_line:
		url[l[1]] = None
		protocol[l[1]] = None
		protocol[l[0]] = "https"

	url = [i for i in url if i is not None]
	protocol = [i for i in protocol if i is not None]
	for a in range(len(url)):
		print(protocol[a]+"://"+url[a])
else:
	print("Usage : "+sys.argv[0]+" filename")
