/*

Cleaning data in SQL Queries

*/

SELECT *
FROM NashvilleTable
--------------------------------------------------------------------
--Standardize Date Format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM dbo.NashvilleTable

Update dbo.NashvilleTable
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE dbo.NashvilleTable
ADD SaleDateConverted Date;

Update dbo.NashvilleTable
SET SaleDateConverted = CONVERT(Date, SaleDate)

----------------------------------------------------------------------

--Populate Property Address data

SELECT PropertyAddress
FROM dbo.NashvilleTable
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, (ISNULL(a.PropertyAddress, b.PropertyAddress))
FROM NashvilleTable a
JOIN NashvilleTable b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleTable a
JOIN NashvilleTable b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

SELECT PropertyAddress
FROM NashvilleTable

-----------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertySplitAddress
FROM NashvilleTable
ORDER BY UniqueID

SELECT
--SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, (LEN PropertyAddress)) as Address,
FROM NashvilleTable

Update NashvilleTable
SET PropertySplitAddress = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, (LEN PropertyAddress)) as Address

Select *
From Portfolio.dbo.NashvilleHousing


Select OwnerAddress
From Portfolio.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress,',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress,',', '.') ,1)
From Portfolio.dbo.NashvilleHousing


ALTER TABLE Portfolio.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(225);

Update Portfolio.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.') ,3)

ALTER TABLE Portfolio.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(225);

Update Portfolio.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.') ,2)

ALTER TABLE Portfolio.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(225);

Update Portfolio.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.') ,1)



Select *
From Portfolio.dbo.NashvilleHousing



-----------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Portfolio.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2




Select SoldAsVacant
,	CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'NO'
		 ELSE SoldAsVacant
		 END
From Portfolio.dbo.NashvilleHousing



Update Portfolio.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'NO'
		 ELSE SoldAsVacant
		 END
