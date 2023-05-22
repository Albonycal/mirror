
SOURCE="rsync://95.156.230.141/cachy"
DESTPATH="/home/fawks/mirror/cachylinux"
RSYNC=/usr/bin/rsync
LOCKFILE=/tmp/rsync-cachy.lock


synchronize() {
    $RSYNC --port=8958 -rtlvH --delete-after --delay-updates --safe-links "$SOURCE" "$DESTPATH"
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

