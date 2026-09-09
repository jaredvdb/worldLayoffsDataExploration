-- Create temp column to look at any duplicate values
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS dupl_count
FROM layoffs_test;

-- While I could search the column manually, filtering by only those who are more than 1 row count will reveal any true duplicates
WITH duplicate_layoffs AS (
	SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS dupl_count
	FROM layoffs_test
)
SELECT * 
FROM duplicate_layoffs
WHERE dupl_count > 1;

-- This gets the following companies, which I'll check each- ordering by the company name
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS dupl_count
FROM layoffs_test
WHERE company = 'Casper' OR company = 'Cazoo' OR company = 'Hibob' OR company = 'Wildlife Studios' OR company = 'Yahoo'
ORDER BY company;

-- I was able to see some, i.e. Casper had 3 entries with the last 2 entries being complete duplicates. I'll move to keep one of each duplicate instance, by first officially adding in the column
ALTER TABLE layoffs_test ADD COLUMN dupl_count INT;

-- Utilize the hidden ctid as the unique identifier to update the new dupl_count
WITH duplicate_layoffs AS (
    SELECT 
        ctid,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
            ORDER BY ctid
        ) AS dupl_count
    FROM layoffs_test
)
UPDATE layoffs_test
SET dupl_count = duplicate_layoffs.dupl_count
FROM duplicate_layoffs
WHERE layoffs_test.ctid = duplicate_layoffs.ctid;

-- I can now see the duplicate values easier, I'll move to drop them (reusing the first query here after the second shows no more values of 2, confirming the deletion)
SELECT * 
FROM layoffs_test
WHERE dupl_count > 1;

DELETE
FROM layoffs_test
WHERE dupl_count > 1;

-- Remove the duplicate count column
ALTER TABLE layoffs_test DROP COLUMN dupl_count;
