#!/bin/bas

#vars
list_pods=/home/ibmapply/oc.311/list_pods_reinicio
ns=pdn-salud
# generar logs
for i in $(cat $list_pods);
do
oc logs $i -n $ns > $i.log
done



########
oc delete pod contexto-dp-59d9d7bb6d-5m9wm -n pdn-salud

oc delete pod contexto-dp-59d9d7bb6d-vbfpr -n pdn-salud
oc delete pod contratistas-dp-586ccdf554-q95r7 -n pdn-salud
oc delete pod contratistas-dp-586ccdf554-rjskt -n pdn-salud
oc delete pod gestionpagosprevencionapi-dp-58f8bfc868-7wt26 -n pdn-salud
oc delete pod gestionpagosprevencionapi-dp-58f8bfc868-hxwd5 -n pdn-salud
oc delete pod matriceslegales-dp-669954d4c-ft485 -n pdn-salud
oc delete pod matriceslegales-dp-669954d4c-lvb95 -n pdn-salud
oc delete pod mediadorapi-dp-77f997fb88-4rrg5 -n pdn-salud
oc delete pod mediadorapi-dp-77f997fb88-bf8fl -n pdn-salud
oc delete pod mediadorapi-dp-77f997fb88-c4ps7 -n pdn-salud
oc delete pod reservasjuridicasarl-dp-674596b5-52zcm -n pdn-salud
oc delete pod reservasjuridicasarl-dp-674596b5-w274d -n pdn-salud
oc delete pod salud-pbs-eventsincroni-ms-dp-5fd4f7bcd4-4b2zq -n pdn-salud
oc delete pod salud-pbs-eventsincroni-ms-dp-5fd4f7bcd4-vtvrh -n pdn-salud
oc delete pod salud-pbs-servconsultas-ms-dp-65cdd98bff-7hrrk -n pdn-salud
oc delete pod salud-pbs-servconsultas-ms-dp-65cdd98bff-np9zf -n pdn-salud