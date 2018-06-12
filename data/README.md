## Obtaining Source Data

The source data for this project uses OpenStreetMap and its associated tools. Because the source data are very large, this README is provided to allow the user to obtain the data themselves and execute the pipeline locally.

The data acquisition process is as follows:

1. [Obtain OSMC Tools](#install-osmc-tools)
2. [Download .pbf data for Germany](#download-pbf-data-for-germany)
3. [Download poly data for Berlin](#download-poly-data-for-berlin)
4. [Process data to generate a .osm file](#process-data-to-generate-osm-file)
5. Filter data and output to a .csv file

Detailed instructions are presented below. These instructions were adapted from [this post of the OSM forums](https://help.openstreetmap.org/questions/9816/the-best-way-to-extract-street-list).

This process can likely be greatly simplified. However, until I test whether the simplification works I'm going to post instructions for what I know works.

### Install OSMC Tools

First, we have to install [OSMC Tools](https://github.com/ramunasd/osmctools).

To install from Github, do the following:

```sh
git clone https://github.com/ramunasd/osmctools.git
cd osmctools
autoreconf --install
make install
```

Alternatively, on Ubuntu you can simply `apt-get osmctools`.

Instructions for MacOS and Windows will follow.

### Download pbf data for Germany

Download the OpenStreetMap .osm.pbf data file for Germany from [the European Geofabrik page](http://download.geofabrik.de/europe.html).

### Download poly data for Berlin

Download [the raw .poly file for Berlin](https://github.com/JamesChevalier/cities/blob/master/germany/berlin/berlin_berlin.poly) from James Chevalier's Github repository.

### Process data to generate osm file

Run the following command:

```sh
osmosis --read-pbf-fast germany-latest.osm.pbf file="germany-latest.osm.pbf" --bounding-polygon file="berlin.poly" --write-xml file="berlin.osm"
```

### Filter data and output to csv file

Run the following command:

```sh
osmfilter berlin.osm --keep="addr:country= and addr:city= and addr:street=" --ignore-depemdencies --drop-relations --dro
p-ways |osmconvert - --csv="@oname @id @lon @lat addr:country addr:city addr:street" > berlin-streets.csv
```

You should now have a .csv file with all the streets of Berlin.
