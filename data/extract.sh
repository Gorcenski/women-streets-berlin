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
osmfilter berlin.osm --keep="addr:country= and addr:city= and addr:street=" --ignore-dependencies --drop-relations --drop-ways |osmconvert - --csv="@oname @id @lon @lat addr:country addr:city addr:street" > berlin-streets.csv

