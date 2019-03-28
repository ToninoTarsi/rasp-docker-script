FROM yavalek/drjack-wrf3:latest

ENV BASEDIR=/root/rasp/

WORKDIR /root/

ADD geog.tar.gz $BASEDIR

RUN cp -a $BASEDIR/region.TEMPLATE $BASEDIR/CUCCO

COPY CUCCO/wrfsi.nl CUCCO/rasp.run.parameters.CUCCO $BASEDIR/CUCCO/
COPY CUCCO/rasp.region_data.ncl $BASEDIR/GM/
COPY CUCCO/rasp.site.runenvironment $BASEDIR/

ENV PATH="${BASEDIR}/bin:${PATH}"

# initialize
RUN cd $BASEDIR/CUCCO/ \
  && wrfsi2wps.pl \
  && wps2input.pl \
  && geogrid.exe

# cleanup
RUN rm -rf $BASEDIR/geog

WORKDIR /root/rasp/

VOLUME ["/root/rasp/CUCCO/OUT/", "/root/rasp/CUCCO/LOG/"]

CMD ["runGM", "CUCCO"]
