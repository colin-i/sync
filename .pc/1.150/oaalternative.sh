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
		if [ -n "${scripts}" ]; then
			cp ${v} $2 "${scripts}/$3" || exit 1
		fi
	}
	doaction () {
		find -path ./scripts/$2"*"$3 | while read var; do #if not this way, having problems with exported sprites with spaces
			f=`echo "${var}" | grep -o frame_.*/`   #/ is important to stop the search
			f=$(expr substr ${f} 1 $(echo $(echo -n ${f} | wc -m)-1 | bc))
			#f=${f::-1}
			f=$(expr substr ${f} 7 $(echo $(echo -n ${f} | wc -m)-6 | bc))
			#f=${1}_${f:6}
			move "${var}" ../"${out}"/${1}_${f} "$5"_$4_$f
			#touch oaalternative_touch # export f=1 is not visible outside of this scope: echo q | while read var; do done
		done || exit 1 # same reason like export
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
	ainits_ar_set () {
		ainits_ar_key="${ainits_ar_key} $1"
	}
	ainits_ar_get () {
		i=0
		for a in ${ainits_ar_key}; do
			if [ $a = $s ]; then
				return 1
			fi
			i=$((i+1))
		done
		return 0 #no ainits
	}
	ainits_counter=1
	ainit_anonymous () {
		if [ ${ainits_counter} != 1 ]; then
			ainits_file=_${ainits_counter}.as
		else
			ainits_file=.as
		fi
		#f=`find -name DoInitAction${ainits_file}`
		move scripts/DoInitAction${ainits_file} ../"${out}"/$1 _$2
		ainits_counter=$((ainits_counter+1))
	}
	ainit_exported () {
		move scripts/"$2.as" ../"${out}"/$1 "$2"_$3
	}

	s= #id
	while read p; do
		if [ -z "${s}" ]; then
			new_tag
		else
			if [ -z "${t}" ]; then
				if [ -z "${p}" ]; then
					t=1 #can be show/done/export
				else #action
					number_expected
					at=${p}
					if [ -n "${is_debug}" ]; then echo at = ${at}; fi
					if [ ${at} = 1 ]; then
						ainits_ar_set ${s}
					fi
					s=
				fi
			elif [ ${t} = 1 ]; then
				if [ -z "${p}" ]; then #show/export
					t=2
				else
				#done
					number_expected
					if [ -n "${is_debug}" ]; then echo finalId = ${p}; fi

					if [ -n "${remember_pre}" ]; then
						ainit_anonymous ${remember_pre} ${remember_id}
						remember_pre=
					fi

					fn=`echo scripts/DefineSprite_${p}_*`
					if [ -e "${fn}" ]; then
						doaction ${s} DefineSprite_${p}_ '/frame_*/DoAction.as' ${p} "$(echo "${fn}" | grep -o [^_]*$)" #exported sprite
						sprite_type=0
					elif [ -e scripts/DefineSprite_${p} ]; then
						doaction ${s} DefineSprite_${p}/frame_ /DoAction.as ${p} # "" anonymous sprite
						sprite_type=1
					else  #undecided, and if having inits and is a sprite, must make a decision
						sprite_type=2
					fi

					ainits_ar_get; if [ $? = 1 ]; then #button action or DoInitAction sprite
						f=
						if [ ${sprite_type} = 2 ]; then #can be a button
							f=scripts/DefineButton2_${p}_* #exported button
							if [ ! -e ${f} ]; then # "" will write only *
								f=scripts/DefineButton2_${p} #anonymous button
								if [ ! -e ${f} ]; then
									f=
								else
									expo=
								fi
							else
								expo=`echo $f`
								expo="$(echo "${expo}" | grep -o [^_]*$)"
							fi
							if [ -n "${f}" ]; then #is a button
								f=`echo ${f}`/BUTTONCONDACTION' 'on'('release')'.as
								d=../"${out}"/${s}
								move "${f}" "${d}" "${expo}"_$p
								sed -e '1d' -e '$d' -i "${d}"  #delete on(release){ ... }
							fi #f=`find -name BUTTONCONDACTION' 'on'('release')'.as | grep -P DefineButton2_"${p}(/|_)"` #anonymous/exported button with action
						fi
						if [ -z "${f}" ]; then #DoInitAction sprite
							if [ ${sprite_type} = 0 ]; then #exported sprite with action_init
								f=`echo scripts/DefineSprite_${p}_*`
								f="$(echo "${f}" | grep -o [^_]*$)"
								ainit_exported $s "$f" $p
							elif [ ${sprite_type} = 1 ]; then #anonymous sprite init
								ainit_anonymous $s $p
							else # if [ ${sprite_type} = 2 ]; then #undecided, next must be the export and if not, say is anonym
								remember_pre=$s
								remember_id=$p  #and for anonym
							fi
						fi
					fi
					s=
				fi
			else #show/export
				if [ -z "${p}" ]; then
					if [ -n "${is_debug}" ]; then
						echo show
					fi
				else #export
					if [ -n "${is_debug}" ]; then echo $s is exported as "$p"; fi
					if [ "${sprite_type}" = 2 ]; then
						if [ -n "${remember_pre}" ]; then
							if [ -n "${is_debug}" ]; then echo $s '->' ${remember_pre} at export; fi
							ainit_exported ${remember_pre} "$p" $s
							remember_pre=
						fi
					fi
				fi
				s=
			fi
		fi
	done <../"${log}"

	if [ -n "${remember_pre}" ]; then #unclosed sprite
		ainit_anonymous ${remember_pre} ${remember_id} #remember_pre=
	fi

	doaction 0 frame_ /DoAction.as 0 # ""
	cd ..
fi
#part 2
if [ -n "${2}" ]; then
	set -e #at alternative there are return 1 returns
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
	if [ -z "${no_clean}" ]; then
		rm -r ${v} "${out}"
		rm -r ${v} "${folder}"
		rm "${bname}".orig
	fi
fi
