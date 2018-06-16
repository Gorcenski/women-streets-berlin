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
osmfilter berlin.osm --keep="highway=*" --ignore-dependencies --drop-relations --drop-nodes | osmconvert - --csv="@oname @id highway name" > berlin-streets.csv

echo "Extracting street names and performing gender correlation..."
python3 extract_street_names.py

echo "Street name extraction complete. Street-name-gender data is now stored in streets.json."
