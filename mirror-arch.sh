SOURCE="rsync://arch.mirror.constant.com/archlinux/"
DESTPATH="/home/fawks/mirror/archlinux"
RSYNC=/usr/bin/rsync
LOCKFILE=/tmp/rsync-arch.lock


synchronize() {
    $RSYNC -rtlvH --delete-after --delay-updates --safe-links "$SOURCE" "$DESTPATH"
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

