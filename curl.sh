#!/bin/bash
echo 'Trying to connect to whoami service...'
for i in {1..240}
    do
        res=$(curl -s --show-error http://localhost:40000/foo)
        print=$?
        if test "$print" != "0" || test "$res" == "404 page not found"
        then
            echo "the curl command failed with: $print or $res "
        else 
            echo "Success!"
            exit 0
        fi
        sleep 1
done
echo "FAILED!"
exit 1