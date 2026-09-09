-- Exploring every column to make sure they abide by similar rules. i.e. no extra spaces, remove possibly extraneous characters, necessary decimal places, groupings etc. Replaced company with other text fields for further exploration and diagnosing
SELECT DISTINCT company 
FROM layoffs_test
ORDER BY company;

-- Remove erroneous white spaces from either end of all text fields to be safe (i.e. '_E Inc.', '_Included Health')
UPDATE layoffs_test 
SET company = TRIM(company),
  location = TRIM(location),
	industry = TRIM(industry),
	stage = TRIM(stage),
	country = TRIM(country);

-- Industry would likely be a field good for categorization analysis, making sure to standardize- Crypto has 3 different entries. There are around 30 entries total with industry, I may make smaller categories later for more general analysis.
UPDATE layoffs_test
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Country has a case with a trailing period at the end which should be removed, seperate operation from the white space removal above
UPDATE layoffs_test 
SET country = TRIM(TRAILING '.' FROM country);

-- Update data types to fit the observed numbers, since we woudl expect a number from 0 to 1 for percentages and only 2 decimals are being shown, we can make this fit better ti take up less memory. 3 total digits (i.e. 1.00), 2 decimal places
ALTER TABLE layoffs_test
ALTER COLUMN percentage_laid_off TYPE NUMERIC(3,2);

-- Checking that the total laid off column doesn't need decimal places by comparing the original value to a 'rounded' version
SELECT total_laid_off
FROM layoffs_test
WHERE total_laid_off <> ROUND(total_laid_off);

-- Change to an Int instead since no rows returned
ALTER TABLE layoffs_test
ALTER COLUMN total_laid_off TYPE INTEGER;

-- While most are flat integers, some do have decimals (45), three of which have 2 or more. Largest number has 6 digits left of the decimal
SELECT funds_raised_millions
FROM layoffs_test
WHERE funds_raised_millions <> ROUND(funds_raised_millions,1);

SELECT DISTINCT  funds_raised_millions
FROM layoffs_test
ORDER BY funds_raised_millions DESC;

-- Removing 1 degree of accuracy from a 3 out of over 2k shouldn't have a massive impact for this project's purposes. Useful to remove in the testing dataset, but for note in the raw import. Numeric with 9 total digits (7 left, 2 right) should suffice.
ALTER TABLE layoffs_test
ALTER COLUMN funds_raised_millions TYPE NUMERIC(9,2);
