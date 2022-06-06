Oracle Cloud Infrastructure Reporting Tool
https://github.com/oracle/oci-python-sdk/blob/master/examples/showoci/step_by_step_installation.md

Abrir la consola de OCI y luego el Cloud Shell

Paso 1: Instalar python
pip3 install --user oci

Paso 2: Descargar el reposistorio de la herramienta
git clone https://github.com/oracle/oci-python-sdk

Paso 3: Ir a la carpeta donde se descargo el repositorio
cd oci-python-sdk/examples/showoci

Paso 4: Ejecutar la herramienta
python3 showoci.py -ani -dt -csv <prefijo de los archivos>

arguments:
  -h, --help           show this help message and exit
  -a                   Print All Resources
  -ani                 Print All Resources but identity
  -an                  Print Announcements
  -api                 Print API Gateways
  -b                   Print Budgets
  -c                   Print Compute
  -cn                  Print Containers
  -d                   Print Database
  -e                   Print EMail
  -edge                Print Edge, DNS Services and WAAS policies
  -f                   Print File Storage
  -fun                 Print Functions
  -i                   Print Identity
  -ic                  Print Identity Compartments only
  -isc                 Skip Identity User Credential extract
  -l                   Print Load Balancer
  -lq                  Print Limits and Quotas
  -m                   Print Monitoring, Notifications and Events
  -n                   Print Network
  -o                   Print Object Storage
  -paas                Print PaaS Platform Services - OIC OAC OCE
  -dataai              Print - D.Science, D.Catalog, D.Flow, ODA and BDS
  -rm                  Print Resource management
  -s                   Print Streams
  -sec                 Print Security and Logging
  -nobackups           Do not process backups
  -so                  Print Summary Only
  -mc                  exclude ManagedCompartmentForPaaS
  -nr                  Not include root compartment
  -ip                  Use Instance Principals for Authentication
  -dt                  Use Delegation Token (Cloud shell)
  -t PROFILE           Config file section to use (tenancy profile)
  -p PROXY             Set Proxy (i.e. www-proxy-server.com:80)
  -rg REGION           Filter by Region
  -cp COMPART          Filter by Compartment Name or OCID
  -cpr COMPART_RECUR   Filter by Comp Name Recursive
  -cpath COMPARTPATH   Filter by Compartment path ,(i.e. -cpath "Adi / Sub"
  -tenantid TENANTID   Override confile file tenancy_id
  -cf CONFIG           Config File (~/.oci/config)
  -csv CSV             Output to CSV files, Input as file header
  -jf JOUTFILE         Output to file (JSON format)
  -js                  Output to screen (JSON format)
  -sjf SJOUTFILE       Output to screen (nice format) and JSON File
  -cachef SERVICEFILE  Output Cache to file (JSON format)
  -caches              Output Cache to screen (JSON format)
  --version            show program's version number and exit

Paso 5: Verificar que los archivos esten en la carpeta donde se ejecuto el comando
ls -la

Paso 6: Enviar la información al bucket de obcjet storage
oci os object put -ns idjd9gydvutg -bn os-zfrbucket --file ZFR_

arguments:
-ns namespaces bucket
-bn bucket name



yum upgrade python-setuptools
yum install python3
pip3 install --upgrade pip
pip3 install --user oci
yum install git
yum -y groupinstall "Development Tools"
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"

[DEFAULT]
user=ocid1.user.oc1..aaaaaaaarmpk5scecig7l3tm2jts42gqfp7kbbuqdb6d4taq7pskosxizioa
fingerprint=b2:fd:30:e7:71:f3:82:e9:55:1f:e4:dd:1f:a5:e4:32
key_file=/root/.oci/oci_api_key_eddi.pem
tenancy=ocid1.tenancy.oc1..aaaaaaaayiqcdpg5jxsk3jfldwj3nab7pm5d4t7kkrrihei6dahnveslxiqa
region=us-ashburn-1

http://6bcf.example.opentlc.com/
https://aap2.demoredhat.com/exercises/ansible_rhel/
https://aap2.demoredhat.com/exercises/ansible_rhel/1.1-setup/
http://6bcf.example.opentlc.com/

python3 showoci.py -cf /root/.oci/config -csv prueba -i