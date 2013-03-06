.PHONY: all install clean

all: install

install:
	./build.sh

clean:
	rm LSOA01_LSOA11_LAD11_EW_LU_csv.zip MSOA01_MSOA11_LAD11_EW_LU_csv.zip OA01_OA11_LAD11_EW_LU_csv.zip
	rm -rf LSOA01_LSOA11_LAD11_EW_LU MSOA01_MSOA11_LAD11_EW_LU OA01_OA11_LAD11_EW_LU
