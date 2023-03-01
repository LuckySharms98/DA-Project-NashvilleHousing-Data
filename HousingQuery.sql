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

--In the original dataset, some rows that have different UniqueID fields have duplicate ParcelID values, and thus duplicates in every other field
SELECT ParcelID, COUNT(*) AS dup_count
FROM HousingData
GROUP BY ParcelID
HAVING COUNT(*) > 1
ORDER BY ParcelID;

--We can do a simple join with this table on our original table to uniquely identify these duplicates 

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL
FROM HousingData a
JOIN HousingData b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ];






--Break out Address into Invidual Columns (Address, City, State)


--Change Yes and No in 'Sold As Vacant' field to Y and N


--Remove Duplicates


--Delete Unused Columns
