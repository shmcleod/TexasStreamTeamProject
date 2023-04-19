-- Skills used: Create View, Window Functions,

-- Selecting All from Datamap

SELECT * FROM TST..Datamap

-- Selecting unique values for specific columns
-- Looking for errors (Data errors)

SELECT DISTINCT([Nitrate-Nitrogen (ppm or mg L)])
FROM TST..Datamap
ORDER BY [Nitrate-Nitrogen (ppm or mg L)] DESC


-- Removing Data Errors

SELECT * FROM TST..Datamap
WHERE [Conductivity (µs cm)] <> 'Data error'
AND pH <> 'Data error'
AND [Dissolved Oxygent (mg L)] <> 'Data error'
AND [Air Temperature (°C)] <> 'Data error'
AND [Water Temperature (°C)] <> 'Data error'
AND [Nitrate-Nitrogen (ppm or mg L)] <> 'Data error'
-- No Data Errors in Ecoli but adding for future
AND [E  Coli Average] <> 'Data error'
AND sample_date <> '1900-01-01'
ORDER BY sample_date ASC

-- Finding Errors

SELECT * FROM TST..Datamap
WHERE [Conductivity (µs cm)] = 'Data error'
OR pH = 'Data error'
OR [Dissolved Oxygent (mg L)] = 'Data error'
OR [Air Temperature (°C)] = 'Data error'
OR [Water Temperature (°C)] = 'Data error'
OR [Nitrate-Nitrogen (ppm or mg L)] = 'Data error'
-- No Data Errors in Ecoli but adding for future
OR [E  Coli Average] = 'Data error'

-- How many rows have errors? (Need to Fix these sites)

SELECT COUNT(*) as Num_Samples_With_Errors FROM TST..Datamap
WHERE [Conductivity (µs cm)] = 'Data error'
OR pH = 'Data error'
OR [Dissolved Oxygent (mg L)] = 'Data error'
OR [Air Temperature (°C)] = 'Data error'
OR [Water Temperature (°C)] = 'Data error'
OR [Nitrate-Nitrogen (ppm or mg L)] = 'Data error'
-- No Data Errors in Ecoli but adding for future
OR [E  Coli Average] = 'Data error'


-- Creating Rolling Average for Parameters by Basin

SELECT sample_date, Basin,
[Conductivity (µs cm)],
AVG(NULLIF(CAST([Conductivity (µs cm)] AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as Cond_Average,
pH,
AVG(NULLIF(CAST(pH AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as pH_Average,
[Dissolved Oxygent (mg L)],
AVG(NULLIF(CAST([Dissolved Oxygent (mg L)] AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as DO_Average,
[Air Temperature (°C)],
AVG(NULLIF(CAST([Air Temperature (°C)] AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as Air_temp_Average,
[Water Temperature (°C)],
AVG(NULLIF(CAST([Water Temperature (°C)] AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as Water_temp_Average,
[E  Coli Average],
AVG(NULLIF(CAST([E  Coli Average] AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as E_coli_Average,
[Nitrate-Nitrogen (ppm or mg L)],
AVG(NULLIF(CAST([Nitrate-Nitrogen (ppm or mg L)] AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as Nitrate_Average
FROM TST..Datamap
WHERE [Conductivity (µs cm)] <> 'Data error'
AND pH <> 'Data error'
AND [Dissolved Oxygent (mg L)] <> 'Data error'
AND [Air Temperature (°C)] <> 'Data error'
AND [Water Temperature (°C)] <> 'Data error'
AND [Nitrate-Nitrogen (ppm or mg L)] <> 'Data error'
-- No Data Errors in Ecoli but adding for future
AND [E  Coli Average] <> 'Data error'
AND sample_date <> '1900-01-01'
ORDER BY Basin, sample_date ASC

-- Creating Rolling Average for parameters by Site_id

SELECT sample_date, site_id, Basin,
[Conductivity (µs cm)],
AVG(NULLIF(CAST([Conductivity (µs cm)] AS float),0)) OVER (PARTITION BY site_id ORDER BY sample_date, site_id) as Cond_Average,
pH,
AVG(NULLIF(CAST(pH AS float),0)) OVER (PARTITION BY site_id ORDER BY sample_date, site_id) as pH_Average,
[Dissolved Oxygent (mg L)],
AVG(NULLIF(CAST([Dissolved Oxygent (mg L)] AS float),0)) OVER (PARTITION BY site_id  ORDER BY sample_date, site_id) as DO_Average,
[Air Temperature (°C)],
AVG(NULLIF(CAST([Air Temperature (°C)] AS float),0)) OVER (PARTITION BY site_id  ORDER BY sample_date, site_id) as Air_temp_Average,
[Water Temperature (°C)],
AVG(NULLIF(CAST([Water Temperature (°C)] AS float),0)) OVER (PARTITION BY site_id  ORDER BY sample_date, site_id) as Water_temp_Average,
[E  Coli Average],
AVG(NULLIF(CAST([E  Coli Average] AS float),0)) OVER (PARTITION BY site_id  ORDER BY sample_date, site_id) as E_coli_Average,
[Nitrate-Nitrogen (ppm or mg L)],
AVG(NULLIF(CAST([Nitrate-Nitrogen (ppm or mg L)] AS float),0)) OVER (PARTITION BY site_id  ORDER BY sample_date, site_id) as Nitrate_Average
FROM TST..Datamap
WHERE [Conductivity (µs cm)] <> 'Data error'
AND pH <> 'Data error'
AND [Dissolved Oxygent (mg L)] <> 'Data error'
AND [Air Temperature (°C)] <> 'Data error'
AND [Water Temperature (°C)] <> 'Data error'
AND [Nitrate-Nitrogen (ppm or mg L)] <> 'Data error'
-- No Data Errors in Ecoli but adding for future
AND [E  Coli Average] <> 'Data error'
AND sample_date <> '1900-01-01'
ORDER BY site_id, sample_date, Basin ASC


-- Date is 1900 and this is inaccurate, need to fix
SELECT Basin, site_id, sample_date
FROM TST..Datamap
WHERE sample_date < '1980-01-01'

-- Creating View

CREATE VIEW Rolling_Avg_Per_Basin AS
SELECT sample_date, Basin,
[Conductivity (µs cm)],
AVG(NULLIF(CAST([Conductivity (µs cm)] AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as Cond_Average,
pH,
AVG(NULLIF(CAST(pH AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as pH_Average,
[Dissolved Oxygent (mg L)],
AVG(NULLIF(CAST([Dissolved Oxygent (mg L)] AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as DO_Average,
[Air Temperature (°C)],
AVG(NULLIF(CAST([Air Temperature (°C)] AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as Air_temp_Average,
[Water Temperature (°C)],
AVG(NULLIF(CAST([Water Temperature (°C)] AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as Water_temp_Average,
[E  Coli Average],
AVG(NULLIF(CAST([E  Coli Average] AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as E_coli_Average,
[Nitrate-Nitrogen (ppm or mg L)],
AVG(NULLIF(CAST([Nitrate-Nitrogen (ppm or mg L)] AS float),0)) OVER (PARTITION BY Basin ORDER BY sample_date, Basin) as Nitrate_Average
FROM TST..Datamap
WHERE [Conductivity (µs cm)] <> 'Data error'
AND pH <> 'Data error'
AND [Dissolved Oxygent (mg L)] <> 'Data error'
AND [Air Temperature (°C)] <> 'Data error'
AND [Water Temperature (°C)] <> 'Data error'
AND [Nitrate-Nitrogen (ppm or mg L)] <> 'Data error'
-- No Data Errors in Ecoli but adding for future
AND [E  Coli Average] <> 'Data error'
AND sample_date <> '1900-01-01'
AND [Conductivity (µs cm)] IS NOT NULL

SELECT * FROM Rolling_Avg_Per_Basin
ORDER BY Basin, sample_date ASC

