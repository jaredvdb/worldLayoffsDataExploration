-- Investigating which columns have null or blank values, repeat similarly for other columns
SELECT * 
FROM layoffs_test
WHERE industry IS NULL
OR industry = '';

-- First blank value shown is Airbnb, so we explore if other rows may have a value in industry
SELECT * 
FROM layoffs_test
WHERE company LIKE 'Airbnb';

-- Found there is a Private Equity stage row that is set to Travel, so it's possible other companies encounter a similar issue. Using Company + Location as a 'key'
SELECT L1.company AS L1company, L1.location, L1.industry, L2.company AS L2company, L2.location, L2.industry
FROM layoffs_test AS L1
JOIN layoffs_test AS L2
  ON L1.company = L2.company
  AND L1.location = L2.location
WHERE (L1.industry IS NULL OR L1.industry = '')
AND (L2.industry IS NOT NULL AND L2.industry <> '');

-- Update any rows with a matching company/location with the non-null industry
UPDATE layoffs_test AS L1
SET industry = L2.industry
FROM layoffs_test AS L2
WHERE L1.company = L2.company
	AND L1.location = L2.location
	AND (L1.industry IS NULL OR L1.industry = '')
	AND (L2.industry IS NOT NULL AND L2.industry <> '');
