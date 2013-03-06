# ONS's 2001--2011 Output Area Lookup Files: PostgreSQL Importer

This is an investigatory project aiming to quickly make available some of the spatial data available from the Office of National Statistics. In particular the [2001--20011 Census Output Area Lookup files](http://www.ons.gov.uk/ons/guide-method/geography/products/census/lookup/2001-2011/index.html).

Some further information on this data is available in [the beginners guide](http://www.ons.gov.uk/ons/guide-method/geography/beginner-s-guide/census/output-area--oas-/index.html).


## Prerequisites

* Postgres: `psql`, `createdb`
* `wget`, `unzip`, `iconv`

Most of these should be satisfied on any dev laptop. If you're missing Postgres and want to get set up really quickly on OS X, check out [Postgres.app](http://postgresapp.com/).


## Usage

Paste the following command into your terminal to clone this repository, run the project (downloads the data and creates and imports the database) and open an interactive shell to the database with which you can inspect the data.

    git clone git@github.com:icio/ons-output-area.git &&
        cd ons-output-area &&
        make && 
        psql ons_output_area

You can import the data using `./build.sh [DATABASE_NAME]` or simply `make` to use the default `ons_output_area` database (created if it doesn't already exist). The build script drops any of the tables which already exists and imports them afresh with the data available.

The data archives are never downloaded from the internet if they already exist, nor are files unzipped if the extract target already exists. The makefile makes available a utility for removing all of the locally downloaded data:

    make clean
