
# update and install packages
apt-get update
apt-get install  -y --no-install-recommends ca-certificates wget curl xz-utils cpanminus

# setup krona
wget https://github.com/marbl/Krona/releases/download/v2.7/KronaTools-2.7.tar -O ${INSTALL_DIR}/krona.tar
tar xvf ${INSTALL_DIR}/krona.tar --directory ${INSTALL_DIR}  --strip-components=1
perl -MCPAN -e 'install Pod::Usage.pm'
wget "http://krona.sourceforge.net/src/krona-2.0.js" -O /krona.js
cd ${INSTALL_DIR} && install.pl
