#! /system/bin/sh
PLAY_FILE="/system/media/audio/music_play.wav"
RECORD_FILE="/mnt/sdcard/Music/music_record.wav"

echo "play music-20s begin !!"
tinyplay ${PLAY_FILE} > /dev/null &
PLAY_ID=$!
sleep 1
tinymix 26 1
wait ${PLAY_ID}
echo ""
echo "play music-20s end !!"

sleep 1

if [ -f ${RECORD_FILE} ]; then
	rm -f ${RECORD_FILE}
fi

echo ""
echo "record sound-25s begin!!"
tinycap ${RECORD_FILE} > /dev/null
echo "record file:${RECORD_FILE}"
echo "record sound-25s end!!"

echo ""
echo "play record file-25s begin !!"
tinyplay ${RECORD_FILE} > /dev/null &
PLAY_ID=$!
sleep 1
tinymix 26 1
wait ${PLAY_ID}
echo "play record file-25s end !!"

exit 0
