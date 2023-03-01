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

--Break out Address into Invidual Columns (PropertyStreet,PropertyCity, PropertyState)
--Now to add these as columns
ALTER TABLE HousingData
ADD OwnerStreet nvarchar(255), OwnerCity nvarchar(255), OwnerState nvarchar(255);

--We can use PARSENAME by replacing the period with a , as the delimiter 
UPDATE HousingData
SET OwnerStreet = PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

SELECT*
FROM HousingData;

----------------------------------------------------------------------------------------------
--Change Y and N in 'Sold As Vacant' field to Yes and No

SELECT DISTINCT SoldAsVacant, COUNT(*)
FROM HousingData
GROUP BY SoldAsVacant;

--case statement

SELECT SoldAsVacant,
	CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant --keep it as same
	END
FROM HousingData;

--ADD TO TABLE
UPDATE HousingData
SET SoldAsVacant = (CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant --keep it as same
	END)


----------------------------------------------------------------------------------------------
--Remove Duplicates


----------------------------------------------------------------------------------------------
--Delete Unused Columns
