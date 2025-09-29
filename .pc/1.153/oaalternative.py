#!/usr/bin/python3

default_tab=3

import sys
if len(sys.argv)!=2: exit(1)
import os
is_debug=os.environ.get("is_debug")

def ind_match(indt,b):
	global n,ps
	n=pos
	while True:
		while True:
			n-=1
			if n<0: exit(1)
			if data[n]=='\n': break
		ps=n+1
		while data[ps]==' ': ps+=1
		a=ps-n
		if a==indt: break
		if b:
			if a<indt: exit(1)
		elif a>indt: exit(1)

with open(sys.argv[1]) as f:
	if data:=f.read(): #\r\n is translated to \n also at windows msys2, else data=data.replace('\r','')
		start=0
		goto='§§goto(addr'
		while (pos:=data.find(goto,start))!=-1:
			start=pos

			while True:
				if pos==0: exit(1)
				pos-=1
				if data[pos]!=' ':
					break
			ind=start-pos
			if pos<1: exit(1)
			if data[pos]!='\n': exit(1)
			pos-=1
			if data[pos]!='}': exit(1)
			pos-=ind
			if pos<0: exit(1)
			if data[pos]!='\n': exit(1)

			ind_match(ind,True)
			if data[ps]!='{': exit(1)
			spos=n-1
			while data[spos]!='\n':
				spos-=1
				if spos<0: exit(1)                          #spos is A

			start+=len(goto)
			addr='addr'+data[start:start+4]+':'
			if is_debug:
				print(addr)
			start+=4
			if data[start:start+3]!=');\n': exit(1)
			start+=3                                          #start is D

			if (bpos:=data.find(addr,ps,pos))==-1: exit(1)
			apos=bpos-1
			while data[apos]!='\n': apos-=1
			ind2=bpos-apos
			ind3=ind2-default_tab
			ind_match(ind3,False)

			bpos+=len(addr)
			if data[bpos]!='\n': exit(1)
			mark=bpos                                         #mark is B
			while True: #here is expecting a lower ind
				cpos=bpos+1
				while data[cpos]==' ': cpos+=1
				indt=cpos-bpos
				if indt==ind3: break
				if indt<ind3: exit(1)
				bpos=cpos+1
				while data[bpos]!='\n': bpos+=1             #bpos is BB

			apos-=1
			if data[apos]!='{': exit(1)
			apos-=ind3
			if data[apos]!='\n': exit(1)
			apos-=4
			if data[apos:apos+4]!='else': exit(1)
			apos-=ind3
			if data[apos]!='\n': exit(1)
			apos-=1
			if data[apos]!='}': exit(1)
			apos-=ind3
			if data[apos]!='\n': exit(1)
			if apos<spos: exit(1)                             #apos is AA

			if data[cpos]!='}': exit(1)
			cpos+=1
			if data[cpos]!='\n': exit(1)                      #cpos is C

			if data[ps:ps+8]!='return;\n':
				while data[ps]!='\n': ps+=1
				n=ps                                        #n is CC

			# before modifications, ind<ind3<ind2 , default_tab between ind3 ind2
			ind-=1;ind3-=1;ind2-=1
			inddif2=ind3-ind      #for C rows
			ind3=ind+default_tab  #still can fit in ind2, B rows can be truncated
			inddif=ind2-ind3
			ind2+=default_tab     #for highest break
			maxind=' '*ind2       #same, and can go for rest of inds
			text=data[0:spos+1]
			text+=maxind[0:ind]+'while(true){\n'

			while spos!=apos:                                 #A-AA
				text+=maxind[0:default_tab]
				spos+=1
				a=spos
				while data[a]!='\n': a+=1
				text+=data[spos:a+1]
				spos=a
			text+=maxind[0:ind2]+'break;\n'

			while ind3<ind2: #multiple of default_tab is not checked
				ind2-=default_tab
				text+=maxind[0:ind2]+'}\n'

			while mark!=bpos:                                 #B-BB
				mark+=1+inddif
				a=mark
				while data[a]!='\n': a+=1
				text+=data[mark:a+1]
				mark=a
			text+=maxind[0:ind3]+'break;\n'
			text+=maxind[0:ind]+'}\n'

			while cpos!=n:                                    #C-CC
				cpos+=1+inddif2
				a=cpos
				while data[a]!='\n': a+=1
				text+=data[cpos:a+1]
				cpos=a

			a=len(text)
			text+=data[start:]
			data=text
			start=a

with open(sys.argv[1],"w") as f:
	f.write(data)

exit(0)
