for i in *; do
    if [[ ! -d "$i" ]]; then continue; fi

    from=$i
    to=$(echo "$i" |
          tr -cd '\11\12\15\40-\176' |
          sed -e 's/^[[:space:]]*//' |
          sed 's/ /-/g')

    echo "$from becomes $to"
    mv "$from" "$to"
done
