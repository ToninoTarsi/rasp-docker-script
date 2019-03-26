#!/bin/bash

mkdir /root/DRJACK/
export BASEDIR=/root/DRJACK/

yum -y update \
  && yum -y install netcdf-fortran libpng15 iproute-tc tcp_wrappers-libs sendmail procmail psmisc procps-ng mailx \
  findutils ImageMagick perl-CPAN ncl netcdf libpng libjpeg-turbo which perl-Tk.x86_64 patch perl-Env.noarch glibc.i686 libpng12.i686
  
  
(echo y;echo o conf prerequisites_policy follow;echo o conf commit) | cpan \
  && cpan install Proc/Background.pm

  
ln -s libnetcdff.so.6 /lib64/libnetcdff.so.5 \
  && ln -s libnetcdf.so.11 /lib64/libnetcdf.so.7


cd /root/

curl -SL http://www.drjack.info/RASP/DOWNLOAD/rasp_scripts.tar.gz | tar xC $BASEDIR
curl -SL http://www.drjack.info/RASP/DOWNLOAD/rasp_ncl.tar.gz | tar xC $BASEDIR
curl -SL http://www.drjack.info/RASP/DOWNLOAD/drjack_utils.tar.gz | tar xC $BASEDIR
curl -SL http://www.drjack.info/RASP/DOWNLOAD/wrf_execs.tar.gz | tar xC $BASEDIR
curl -SL http://www.drjack.info/RASP/DOWNLOAD/wrfsi_misc.tar.gz | tar xC $BASEDIR
curl -SL http://www.drjack.info/RASP/DOWNLOAD/wrfsi_gui.tar.gz | tar xC $BASEDIR
curl -SL http://www.drjack.info/RASP/DOWNLOAD/rasp_region.panoche.tar.gz | tar xC $BASEDIR  


cd $BASEDIR/WRF/wrfsi/extdata/GEOG


curl -SL ftp://aftp.fsl.noaa.gov/divisions/frd-laps/WRFSI/Geog_Data/albedo_ncep.tar.tgz | tar xz 
curl -SL ftp://aftp.fsl.noaa.gov/divisions/frd-laps/WRFSI/Geog_Data/greenfrac.tar.tgz | tar xz 
curl -SL ftp://aftp.fsl.noaa.gov/divisions/frd-laps/WRFSI/Geog_Data/islope.tar.tgz | tar xz 
curl -SL ftp://aftp.fsl.noaa.gov/divisions/frd-laps/WRFSI/Geog_Data/maxsnowalb.tar.tgz | tar xz 
curl -SL ftp://aftp.fsl.noaa.gov/divisions/frd-laps/WRFSI/Geog_Data/soiltemp_1deg.tar.tgz | tar xz 
curl -SL ftp://aftp.fsl.noaa.gov/divisions/frd-laps/WRFSI/Geog_Data/landuse_30s/landuse_30s.NW.tar.tgz | tar xz 
curl -SL ftp://aftp.fsl.noaa.gov/divisions/frd-laps/WRFSI/Geog_Data/soiltype_bot_30s/soiltype_bot_30s.NW.tar.tgz | tar xz 
curl -SL ftp://aftp.fsl.noaa.gov/divisions/frd-laps/WRFSI/Geog_Data/soiltype_top_30s/soiltype_top_30s.NW.tar.tgz | tar xz 
curl -SL ftp://aftp.fsl.noaa.gov/divisions/frd-laps/WRFSI/Geog_Data/topo_30s/topo_30s.NW.tar.tgz | tar xz

curl -SL ftp://aftp.fsl.noaa.gov/divisions/frd-laps/WRFSI/Geog_Data/landuse_30s/landuse_30s.NE.tar.tgz | tar xz 
curl -SL ftp://aftp.fsl.noaa.gov/divisions/frd-laps/WRFSI/Geog_Data/soiltype_bot_30s/soiltype_bot_30s.NE.tar.tgz | tar xz 
curl -SL ftp://aftp.fsl.noaa.gov/divisions/frd-laps/WRFSI/Geog_Data/soiltype_top_30s/soiltype_top_30s.NE.tar.tgz | tar xz 
curl -SL ftp://aftp.fsl.noaa.gov/divisions/frd-laps/WRFSI/Geog_Data/topo_30s/topo_30s.NE.tar.tgz | tar xz

cp $BASEDIR/WRF/wrfsi/extdata/static/grib_prep.nl.TEMPLATE $BASEDIR/WRF/wrfsi/extdata/static/grib_prep.nl \
  && perl -pi -w -e "\$bdir = \"$BASEDIR\"; s/\/home\/admin\/DRJACK/\$bdir/g;" $BASEDIR/WRF/wrfsi/extdata/static/grib_prep.nl \
  && cp $BASEDIR/WRF/NCL/rasp.ncl.region.data.TEMPLATE $BASEDIR/WRF/NCL/rasp.ncl.region.data \
  && mkdir -p $BASEDIR/WRF/wrfsi/domains/ $BASEDIR/WRF/wrfsi/templates/
  
  
cd $BASEDIR/WRF/NCL \
  && for i in *.TEMPLATE; do \cp -f $i ${i/.TEMPLATE/}; done

  
cd $BASEDIR/WRF/wrfsi/JACK \
  && ./edit.wrfsi_hardwired_basedirs.pl

ln -sf grib_prep.exe.eta $BASEDIR/WRF/wrfsi/bin/grib_prep.exe


cp wrfsi.patch /root/

cd $BASEDIR \
  && patch -p0 < ~/wrfsi.patch \
  && rm ~/wrfsi.patch
  
echo export BASEDIR=$BASEDIR >> /etc/bashrc \
  && echo export PATH+=:\$BASEDIR/bin >> /etc/bashrc \
  && echo export LD_LIBRARY_PATH=\$BASEDIR/UTIL/PGI >> /etc/bashrc

  
yum clean all

ln -s $BASEDIR/WRF/wrfsi/wrf_tools \
  && ln -s $BASEDIR/WRF/wrfsi/domains \
  && ln -s $BASEDIR/WRF/wrfsi/templates
  
  
  
  
  
  