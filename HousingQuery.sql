SELECT *
FROM NashvilleHousing..HousingData;

---------------------------------------------------------------------------------------------------------------------
--Standardize Date Format

ALTER TABLE HousingData
ADD SaleDateConverted Date --add a new column

UPDATE HousingData
SET SaleDateConverted = CONVERT(Date,SaleDate); --populate said column with converted date values 

ALTER TABLE HousingData
DROP COLUMN SaleDate; --remove old SaleDate column

SELECT *
FROM NashvilleHousing..HousingData;

----------------------------------------------------------------------------------------------------------------------

--Populate Property Address Data
SELECT *
FROM HousingData
ORDER BY ParcelID;

--We need to take care of these NULL values. Let's do a self join on PropertyAddress and ParcelID to find what needs to fill these empty spaces

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM HousingData a
JOIN HousingData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

--Use update to fill in the NULL value columns with PropertyAddress Data
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM HousingData a
JOIN HousingData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

--We confirm that the NULLS were filled by running the below query
SELECT *
FROM HousingData

----------------------------------------------------------------------------------------------

--Break out Address into Invidual Columns (Address, City, State)
SELECT PropertyAddress
FROM HousingData

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS City 
FROM HousingData

--Now to add these as columns
ALTER TABLE HousingData
ADD Street nvarchar(255), City nvarchar(255)

UPDATE HousingData
SET Street = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) - 1),
City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress));

SELECT*
FROM HousingData;

--Change Yes and No in 'Sold As Vacant' field to Y and N


--Remove Duplicates


--Delete Unused Columns
