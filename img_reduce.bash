
#!/bin/bash
# IMG REDUCE
#----------------------------
# by http://twitter.com/c0l2e
#    ronartos@gmail.com
# modified by StayerX
#============================
# converts images with resolution higher than maxsize to lower at least 50% or original
# input: a directory containig all the images, the file type {JPG, PNG} and the size
# produces a subdirectory with the name reduced_${size} which contains the images reduced

if [ "$#" -ne 3 ]; then
        echo "Usage: ./$0 location filetype maxsize"
        exit 1;
fi


LOCATION=$1
FileType=$2
maxsize=$3

TARGET_FILES=`find "$LOCATION" -iname "*.$FileType" | sed 's/ /|/g'`

for file in $TARGET_FILES; do

        TEST1=`echo $file | sed 's/|/ /g'`  #$TESTFILE
        extension=`file "$TEST1" -b | awk '{print $1}'`
        bak="${file}.bak";

        if  [[ ( $file == *"reduced"* || $file == *"bak"* )]]; then
                continue;
        fi

        if [[ ("$extension" = "JPEG" || "$extension" = "PNG" ) ]]; then

                if [ ! -f ${bak} ]; then
                        cp ${file} ${bak};
                fi
                #continue;
                CHECKSIZE=`file "$file" -b | sed 's/ //g' | sed 's/,/ /g' | awk  '{print $2}' | sed 's/x/ /g' | awk '{print $1}'`
                while [ $CHECKSIZE -ge  ${maxsize}  ]; do
                        convert  "$file" -resize 50% "$file"
                        CHECKSIZE=`file "${file}" -b | sed 's/ //g' | sed 's/,/ /g' | awk  '{print $2}' | sed 's/x/ /g' | awk '{print $1}'`
                done
                DIR=$(dirname "${file}")
                basefile=$(basename "${file}")
                mkdir -p "${DIR}/reduced_${maxsize}/"
                mv "${file}" "${DIR}/reduced_${maxsize}/${basefile}"
                mv "${bak}" "${file}"
        fi

done
