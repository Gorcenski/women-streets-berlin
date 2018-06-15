#!/bin/bash

if [ ! -f berlin-latest.osm.pbf ]
then
    echo "ERROR! Cannot find berlin-latest.osm.pbf. Please download the file and try again."
    exit 1
fi

if [ ! -f berlin.poly ]
then
    echo "ERROR! Cannot find berlin.poly. Please download the file and try again."
    exit 1
fi

echo "Generating osm file. This will take several minutes..."
osmosis --read-pbf-fast berlin-latest.osm.pbf file="berlin-latest.osm.pbf" --bounding-polygon file="berlin.poly" --write-xml file="berlin.osm"

echo "Generating csv file..."
osmfilter berlin.osm --keep="highway=*" --ignore-dependencies | osmconvert - --csv="@oname @id @lat @lon highway name" > berlin-streets.csv

