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


## Data Structures

```
ons_output_area=# \d+ public.*
                                 Table "public.lower_super_output_areas"
        Column        | Type | Modifiers | Storage  |                     Description
----------------------+------+-----------+----------+-----------------------------------------------------
 lsoa_code_2001       | text |           | extended | LSOA01CD - 2001 lower layer super output area code
 lsoa_name_2001       | text |           | extended | LSOA01NM - 2001 lower layer super output area name
 lsoa_code            | text |           | extended | LSOA11CD - 2011 lower layer super output area code
 lsoa_name            | text |           | extended | LSOA11NM - 2011 lower layer super output area name
 change_ind           | text |           | extended | CHGIND - change indicator
 authority_code       | text |           | extended | LAD11CD - 2011 local authority district code
 authority_name       | text |           | extended | LAD11NM - 2011 local authority district name
 authority_welsh_name | text |           | extended | LAD11NMW - 2011 local authority district Welsh name
Has OIDs: no

                                 Table "public.middle_super_output_areas"
        Column        | Type | Modifiers | Storage  |                     Description
----------------------+------+-----------+----------+-----------------------------------------------------
 msoa_code_2001       | text |           | extended | MSOA01CD - 2001 middle layer super output area code
 msoa_name_2001       | text |           | extended | MSOA01NM - 2001 middl layer super output areaname
 msoa_code            | text |           | extended | MSOA11CD - 2011 middle layr super output area code
 msoa_name            | text |           | extended | MSOA11NM - 2011 middle layr super output area name
 change_ind           | text |           | extended | CHGIND - change indicator
 authority_code       | text |           | extended | LAD11CD - 2011 local authority district code
 authority_name       | text |           | extended | LAD11NM - 2011 local authority district name
 authority_welsh_name | text |           | extended | LAD11NMW - 2011 local authority district Welsh name
Has OIDs: no

                                         Table "public.output_areas"
        Column        | Type | Modifiers | Storage  |                       Description
----------------------+------+-----------+----------+---------------------------------------------------------
 oa_code_2001         | text |           | extended | OA01CD - 2001 output area nine character code
 oa_code_2001_old     | text |           | extended | OA01CDO - 2001 output area old style ten character code
 oa_code              | text |           | extended | OA11CD - 2011 output area nine character code
 change_ind           | text |           | extended | CHGIND - change indicator
 authority_code       | text |           | extended | LAD11CD - 2011 local authority district code
 authority_name       | text |           | extended | LAD11NM - 2011 local authority district names
 authority_welsh_name | text |           | extended | LAD11NMW - 2011 local authority district Welsh names
Has OIDs: no
```
