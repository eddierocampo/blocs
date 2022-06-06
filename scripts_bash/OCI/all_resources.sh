#!/bin/bash
compartmentId=ocid1.tenancy.oc1..aaaaaaaayiqcdpg5jxsk3jfldwj3nab7pm5d4t7kkrrihei6dahnveslxiqa
OUTPUT=all_resources.json
oci search resource structured-search — limit 1000 — query-text “query all resources where lifeCycleState != ‘DELETED’ && ($compartmentId)” >$OUTPUT
NEXT_PAGE=$(cat $OUTPUT | grep “opc-next-page” | awk -F ‘ ‘ ‘{print $2}’)
#NEXT_PAGE=$(get_next_page)
echo $NEXT_PAGE > key.out
sed -i ‘/\”opc-next-page\”: /d’ $OUTPUT
sed -i ‘s/\”//g’ key.out
while [ -f key.out ]
do
 head -n -3 $OUTPUT > ${OUTPUT}_1
 cat ${OUTPUT}_1 > $OUTPUT
 rm -f ${OUTPUT}_1
 echo ‘,’ >> $OUTPUT
 oci search resource structured-search — limit 1000 — query-text “query all resources where lifeCycleState != ‘DELETED’ && ($COMPARTMENTS)” — page “$(cat key.out)” >> ${OUTPUT}_1
 NEXT_PAGE=$(cat ${OUTPUT}_1 | grep “opc-next-page” | awk -F ‘ ‘ ‘{print $2}’)
 echo $NEXT_PAGE > key.out
 sed -i ‘/\”opc-next-page\”: /d’ ${OUTPUT}_1
 tail -n +4 ${OUTPUT}_1 > ${OUTPUT}_2
 cat ${OUTPUT}_2 >> ${OUTPUT}
 rm -f ${OUTPUT}_1 ${OUTPUT}_2
 sed -i ‘s/\”//g’ key.out
 a=$(wc -c key.out | awk -F ‘ ‘ ‘{print $1}’)
 b=1
 if [ “$a” -le “$b” ]
 then
 rm -f key.out
 fi
done
echo Done!