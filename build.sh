#!/usr/bin/env bash
cd $(dirname $0)

export DB=${@:-ons_output_area}

function main() {
    createdb $DB
    prepare_oa &
    prepare_msoa &
    prepare_lsoa &
    wait
}

function prepare_archive() {
    # Download the archive if it does not aleady exist
    DATA_URL=$2
    DATA_ARCHIVE=$(basename $DATA_URL)
    echo Preparing $2
    wget --quiet --no-clobber $DATA_URL 2>&1

    # Unzip the data file, overwriting nothing
    DATA_DIR=$(echo $DATA_ARCHIVE | sed 's/_csv.zip$//')
    DATA_FILE=$(pwd)/$DATA_DIR/$DATA_DIR
    unzip -qq -n $DATA_ARCHIVE -d $DATA_DIR

    # Convering data file to UTF8
    iconv -f latin1 -t utf-8 $DATA_FILE.csv > $DATA_FILE.utf8.csv

    # Store the absolute path of the data file in the named variable ($1)
    eval $1=$DATA_FILE.utf8.csv
}

function prepare_oa() {
    prepare_archive OA_DATA_FILE 'http://data.statistics.gov.uk/ONSGeography/CensusGeography/Lookups/2011/OA/OA01_OA11_LAD11_EW_LU_csv.zip'
    echo Importing $OA_DATA_FILE
    psql $DB <<SQL
        DROP TABLE IF EXISTS output_areas;

        CREATE TABLE output_areas (
            oa_code_2001 text,
            oa_code_2001_old text,
            oa_code text,
            change_ind text,
            authority_code text,
            authority_name text,
            authority_welsh_name text);

        COMMENT ON COLUMN output_areas.oa_code_2001 IS 'OA01CD - 2001 output area nine character code';
        COMMENT ON COLUMN output_areas.oa_code_2001_old IS 'OA01CDO - 2001 output area old style ten character code';
        COMMENT ON COLUMN output_areas.oa_code IS 'OA11CD - 2011 output area nine character code';
        COMMENT ON COLUMN output_areas.change_ind IS 'CHGIND - change indicator';
        COMMENT ON COLUMN output_areas.authority_code IS 'LAD11CD - 2011 local authority district code';
        COMMENT ON COLUMN output_areas.authority_name IS 'LAD11NM - 2011 local authority district names';
        COMMENT ON COLUMN output_areas.authority_welsh_name IS 'LAD11NMW - 2011 local authority district Welsh names';

        COPY output_areas FROM '$OA_DATA_FILE' WITH (FORMAT CSV, HEADER TRUE);
SQL
}

function prepare_lsoa() {
    prepare_archive LSOA_DATA_FILE 'http://data.statistics.gov.uk/ONSGeography/CensusGeography/Lookups/2011/Other/LSOA01_LSOA11_LAD11_EW_LU_csv.zip'
    echo Importing $LSOA_DATA_FILE
    psql $DB <<SQL
        DROP TABLE IF EXISTS lower_super_output_areas;

        CREATE TABLE lower_super_output_areas (
            lsoa_code_2001 text,
            lsoa_name_2001 text,
            lsoa_code text,
            lsoa_name text,
            change_ind text,
            authority_code text,
            authority_name text,
            authority_welsh_name text);

        COMMENT ON COLUMN lower_super_output_areas.lsoa_code_2001 IS 'LSOA01CD - 2001 lower layer super output area code';
        COMMENT ON COLUMN lower_super_output_areas.lsoa_name_2001 IS 'LSOA01NM - 2001 lower layer super output area name';
        COMMENT ON COLUMN lower_super_output_areas.lsoa_code IS 'LSOA11CD - 2011 lower layer super output area code';
        COMMENT ON COLUMN lower_super_output_areas.lsoa_name IS 'LSOA11NM - 2011 lower layer super output area name';
        COMMENT ON COLUMN lower_super_output_areas.change_ind IS 'CHGIND - change indicator';
        COMMENT ON COLUMN lower_super_output_areas.authority_code IS 'LAD11CD - 2011 local authority district code';
        COMMENT ON COLUMN lower_super_output_areas.authority_name IS 'LAD11NM - 2011 local authority district name';
        COMMENT ON COLUMN lower_super_output_areas.authority_welsh_name IS 'LAD11NMW - 2011 local authority district Welsh name';

        COPY lower_super_output_areas FROM '$LSOA_DATA_FILE' WITH (FORMAT CSV, HEADER TRUE);
SQL
}

function prepare_msoa() {
    prepare_archive MSOA_DATA_FILE 'http://data.statistics.gov.uk/ONSGeography/CensusGeography/Lookups/2011/Other/MSOA01_MSOA11_LAD11_EW_LU_csv.zip'
    echo Importing $MSOA_DATA_FILE
    psql $DB <<SQL
        DROP TABLE IF EXISTS middle_super_output_areas;

        CREATE TABLE middle_super_output_areas (
            msoa_code_2001 text,
            msoa_name_2001 text,
            msoa_code text,
            msoa_name text,
            change_ind text,
            authority_code text,
            authority_name text,
            authority_welsh_name text);

        COMMENT ON COLUMN middle_super_output_areas.msoa_code_2001 IS 'MSOA01CD - 2001 middle layer super output area code';
        COMMENT ON COLUMN middle_super_output_areas.msoa_name_2001 IS 'MSOA01NM - 2001 middl layer super output areaname';
        COMMENT ON COLUMN middle_super_output_areas.msoa_code IS 'MSOA11CD - 2011 middle layr super output area code';
        COMMENT ON COLUMN middle_super_output_areas.msoa_name IS 'MSOA11NM - 2011 middle layr super output area name';
        COMMENT ON COLUMN middle_super_output_areas.change_ind IS 'CHGIND - change indicator';
        COMMENT ON COLUMN middle_super_output_areas.authority_code IS 'LAD11CD - 2011 local authority district code';
        COMMENT ON COLUMN middle_super_output_areas.authority_name IS 'LAD11NM - 2011 local authority district name';
        COMMENT ON COLUMN middle_super_output_areas.authority_welsh_name IS 'LAD11NMW - 2011 local authority district Welsh name';

        COPY middle_super_output_areas FROM '$MSOA_DATA_FILE' WITH (FORMAT CSV, HEADER TRUE);
SQL
}

main
