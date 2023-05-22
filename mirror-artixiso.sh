
SOURCE="rsync://mirror.nju.edu.cn/artixlinux-iso/"
DESTPATH="/home/fawks/mirror/artixlinux-iso"
RSYNC=/usr/bin/rsync
LOCKFILE=/tmp/rsync-artixiso.lock


synchronize() {
    $RSYNC -rtlvH --delete-after  --safe-links "$SOURCE" "$DESTPATH"
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

