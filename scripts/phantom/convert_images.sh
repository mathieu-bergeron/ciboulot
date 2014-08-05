pushd static/example/images
for i in *.base64;
do
    if [ "$i" != "*.base64" ]
    then
        new_i=`echo $i | sed s/.base64/.png/`
        echo converting images/$new_i
        base64 -d $i > $new_i
        echo deleting images/$i
        rm $i
        echo compressing images/$new_i
        optipng $new_i 1>/dev/null
    fi

done

popd
