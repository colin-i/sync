#!/bin/sh

#1 file.swf  2 what to call (ex: ./a.out ...) or nothing to skip part 2
#is_debug no_clean
#skip_ffdec ffdec
#skip_alternative no_number_check
#scripts

if [ -z "${1}" ]; then echo file path required; exit 1; fi

dname=`dirname ${1}`
if [ -n "${scripts}" ]; then
	scripts=`readlink -f "${scripts}"`
fi
bname=`basename ${1}`

at_start=`pwd`
cd "${dname}" || exit 1

log="${bname}".log.log
if [ ! -e "${log}" ]; then
	log="${bname}".log
	if [ ! -e "${log}" ]; then echo no log; exit 1; fi
fi

folder="${bname%.*}"
if [ -n "${is_debug}" ]; then echo "${folder}"; fi
out="${folder}".dbg

v=
if [ -n "${is_debug}" ]; then v=-v; fi #; set -x

if [ -z "${skip_ffdec}" ]; then
	if [ -z "${ffdec}" ]; then
		ffdec=ffdec
	fi
	if [ -z "${is_debug}" ]; then
		"${ffdec}" -export script "${folder}" "${bname}" > /dev/null || exit 1
	else
		echo ${ffdec} -export script "${folder}" "${bname}"
		"${ffdec}" -export script "${folder}" "${bname}" || exit 1
	fi
fi
mover () {
	if [ -z "${no_clean}" ]; then
		mv ${v} "${@}" || exit 1
	else
		cp ${v} "${@}" || exit 1
	fi
}
if [ -z "${skip_alternative}" ]; then
	mkdir -p "${out}"

	cd "${folder}"

	move () {
		mover "${1}" $2
		if [ -n "${is_debug}" ]; then
			cat ${2}
		fi
	}
	doaction () {
		to=${1}
		shift
		if [ ${#@} = 0 ]; then
			return #is empty
		fi
		for var in "${@}"; do
			f=`echo ${var} | grep -o frame_.*/`   #/ is important to stop the search
			f=$(expr substr ${f} 1 $(echo $(echo -n ${f} | wc -m)-1 | bc))
			#f=${f::-1}
			f=${to}_$(expr substr ${f} 7 $(echo $(echo -n ${f} | wc -m)-6 | bc))
			#f=${to}_${f:6}
			move ${var} ../"${out}"/${f}
		done
	}
	number_expected () {
		if [ -z "${no_number_check}" ]; then
			case ${p} in
				''|*[!0-9]*) echo error: Not a number; exit 1 ;;
			esac #This rejects empty strings and strings containing non-digits
		fi
	}
	new_tag () {
		number_expected
		s=${p}
		t= #type
		if [ -n "${is_debug}" ]; then echo id = ${s}; fi
	}

	ainits_ar_key=
	ainits_ar_val=
	ainits_ar_set () {
		ainits_ar_key="${ainits_ar_key} $1"
		ainits_ar_val="${ainits_ar_val} $2"
	}
	ainits_ar_get () {
		i=0
		for a in ${ainits_ar_key}; do
			if [ $a = $s ]; then
				break
			fi
			i=$((i+1))
		done
		j=0
		for a in ${ainits_ar_val}; do
			if [ $j = $i ]; then
				return $a
			fi
			j=$((j+1))
		done
	}
	#ainits=( )
	ainits_counter=1
	s= #id
	while read p; do
		if [ -z "${s}" ]; then
			new_tag
		else
			if [ -z "${t}" ]; then
				if [ -z "${p}" ]; then
					t=1 #can be show or done
				else
					number_expected
					t=2 #action
					at=${p}
					if [ -n "${is_debug}" ]; then echo at = ${at}; fi
					ainits_ar_set ${s} ${at}
					#ainits[${s}]=${at}
				fi
			elif [ ${t} = 1 ]; then
				if [ -z "${p}" ]; then
					if [ -n "${is_debug}" ]; then
						echo show
					fi
				else
				#done
					number_expected
					if [ -n "${is_debug}" ]; then echo finalId = ${p}; fi
					ainits_ar_get ${s}; if [ $? = 1 ]; then #button or DoInitAction sprite
					#if [ "${ainits[${s}]}" = 1 ]; then #button or DoInitAction sprite
						f=`find -name BUTTONCONDACTION' 'on'('release')'.as | grep "DefineButton2_${p}"`
						if [ -n "${f}" ]; then #is a button
							d=../"${out}"/${s}
							move "${f}" ${d}
							sed -e '1d' -e '$d' -i ${d}  #remove on(release){ ... }
						else #sprite init
							if [ ${ainits_counter} != 1 ]; then
								ainits_file=_${ainits_counter}.as
							else
								ainits_file=.as
							fi
							f=`find -name DoInitAction${ainits_file}`
							move ${f} ../"${out}"/${s}
							ainits_counter=$((ainits_counter+1))
						fi
					fi
					doaction ${s} `find -name DoAction.as | grep DefineSprite_"${p}".*/`  #else is empty #note that only exported sprites are ...${p}_name/
				fi
				s=
			else
				new_tag
			fi
		fi
	done <../"${log}"

	doaction 0 `find -maxdepth 3 -name DoAction.as`
	cd ..
fi
#part 2
if [ -n "${2}" ]; then
	set -e #at alternative there are return 1 and !=0 grep returns
	mv ${v} "${bname}" "${bname}".orig
	cd "${at_start}"
	${2} || {
		cd "${dname}"
		if [ ! -e "${bname}" ]; then
			mv ${v} "${bname}".orig "${bname}"
		fi
		exit 1
	}
	cd "${dname}"
	diff "${bname}" "${bname}".orig
	if [ -n "${scripts}" ]; then
		mover "${out}"/* "${scripts}"
	fi
	if [ -z "${no_clean}" ]; then
		rm -r ${v} "${out}"  #or rmdir if -n scripts
		rm -r ${v} "${folder}"
		rm "${bname}".orig
	fi
fi
