#!/bin/bash

export BASEDIR=/root/rasp/

mkdir $BASEDIR

# required packages
yum -y update 
yum -y install netcdf-fortran libpng15 iproute-tc tcp_wrappers-libs sendmail procmail psmisc procps-ng mailx findutils ImageMagick perl-CPAN ncl netcdf libpng libjpeg-turbo which patch vim less bzip2
  
# configure CPAN and install required modules
(echo y;echo o conf prerequisites_policy follow;echo o conf commit) | cpan  && cpan install Proc/Background.pm

# fix dependencies
ln -s libnetcdff.so.6 /lib64/libnetcdff.so.5 
ln -s libnetcdf.so.11 /lib64/libnetcdf.so.7


cd /root/

#
# Unpack software packages
# Assuming you have downloaded these files from here: http://rasp-uk.uk/SOFTWARE/WRFV3.x/
#

cd $BASEDIR
tar xz rangs.tgz 
tar xz PANOCHE.tgz 
# Unpack raspGM
tar xf rasp-gm-stable.tar --strip-components=1
rm rasp-gm-stable.tar



# POLAND

cd $BASEDIR
tar xz geog.tar.gz

cp -a $BASEDIR/region.TEMPLATE $BASEDIR/POLAND

cp POLAND/wrfsi.nl POLAND/rasp.run.parameters.POLAND $BASEDIR/POLAND/
cp POLAND/rasp.region_data.ncl $BASEDIR/GM/
cp POLAND/rasp.site.runenvironment $BASEDIR/

# initialize
cd $BASEDIR/POLAND/ 
wrfsi2wps.pl 
wps2input.pl 
geogrid.exe

# cleanup
#rm -rf $BASEDIR/geog

cd /root/rasp/

CMD ["runGM", "POLAND"]


#
# Set environment for interactive container shells
#
echo export BASEDIR=$BASEDIR >> /etc/bashrc 
echo export PATH+=:\$BASEDIR/bin >> /etc/bashrc


# cleanup 
RUN yum clean all

CMD ["bash"]
# CMD ["cd $BASEDIR ; runGM PANOCHE"]



  
  
  