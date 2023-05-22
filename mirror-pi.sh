
SOURCE="archive.raspbian.org::archive"
DESTPATH="/mnt/HDD/pi/raspbian"
RSYNC=/usr/bin/rsync
LOCKFILE=/tmp/rsync-pi.lock


synchronize() {
    $RSYNC -rtlvH --archive --delete-after --delay-updates --safe-links "$SOURCE" "$DESTPATH"
}


if [ ! -e "$LOCKFILE" ]
then
    echo $$ >"$LOCKFILE"
    synchronize
else
    PID=$(cat "$LOCKFILE")
    if kill -0 "$PID" >&/dev/null
    then
        echo "Rsync - Synchronization still running"
        exit 0
    else
        echo $$ >"$LOCKFILE"
        echo "Warning: previous synchronization appears not to have finished correctly"
        synchronize
    fi
fi

rm -f "$LOCKFILE"

