This project uses data of two basic types: Geo data for the streets in Berlin, and name-gender correlation data to loosely identify whether a public space recognizes a woman. When possible, data are replicated in this repo so you can get right to work; however, this repository should NOT be considered the most up-to-date source of information, so instructions for obtaining the source data are included.

## Obtaining Source Geo Data

The source data for this project uses OpenStreetMap and its associated tools. Because the source data are large, this README is provided to allow the user to obtain the data themselves and execute the pipeline locally, or to adapt the process for your own city, if desired.

The data acquisition process is as follows:

1. [Obtain OSMC Tools](#install-osmc-tools)
2. [Download .pbf data for Germany](#download-pbf-data-for-germany)
3. [Download poly data for Berlin](#download-poly-data-for-berlin)

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

Download the OpenStreetMap .osm.pbf data file for Berlin from [the Germany Geofabrik page](http://download.geofabrik.de/europe/germany.html).

### Download poly data for Berlin

Download [the raw .poly file for Berlin](https://github.com/JamesChevalier/cities/blob/master/germany/berlin/berlin_berlin.poly) from James Chevalier's Github repository.

## Obtain name-gender correlation data

**A note on name-gender correlation**

We explicitly acknowledge that using first names to ascertain gender is problematic and erases non-binary people and trans people in general. As a non-binary transgender woman, I find it necessary to use this technique nevertheless for the following reasons:

1. This list is used to identify _specific people_ in history, and is not used as a broad classifier for _all people_ for some future use. In other words, these correlations are used to apply to _only these specific people_;
2. This project _explicitly_ includes human review, so every entry will be reviewed by a human who will be able to determine whether the classification was correct, and to fix any issues or add any context;
3. This project reflects historical figures in a Western nation rooted in the Christian tradition. As such, these correlations are likely to be accurate to first-order given the historical contexts in which the people lived and is accordingly suitable for the specific purposes of this project.

Gender, and the language surrounding gender, is very much relative to time and place. With hope, the potential harm caused by using this list as a first-order simplification will be more-than-corrected by the controls built into the project.

### Download the first name database

There are several name-gender correlation databases available, but this project uses the one found in Matthias Winklemann's repository, which you can [download here](https://github.com/MatthiasWinkelmann/firstname-database/blob/master/firstnames.csv). This file contains likelihood measures and is broken down by country. This offers a degree of accuracy and scalability not found in similar lists.

## Processing the data to a workable format

Once the data are downloaded, either by cloning this repo, or downloading the files manually, they must be processed to extract street information. A pipeline script is presently in the works. For the time being, the manual steps are as follows.

1. [Process data to generate a .osm file](#process-data-to-generate-osm-file)
2. [Filter data and output to a .csv file](#filter-data-and-output-to-csv-file)

### Process data to generate osm file

Run the following command:

```sh
osmosis --read-pbf-fast berlin-latest.osm.pbf file="berlin-latest.osm.pbf" --bounding-polygon file="berlin.poly" --write-xml file="berlin.osm"
```

### Filter data and output to csv file

Run the following command:

```sh
osmfilter berlin.osm --keep="addr:country= and addr:city= and addr:street=" --ignore-dependencies --drop-relations --drop-ways |osmconvert - --csv="@oname @id @lon @lat addr:country addr:city addr:street" > berlin-streets.csv
```

You should now have a .csv file with all the streets of Berlin.
