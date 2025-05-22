-- Show first name, last name, and the full province name of each patient.
-- Example: 'Ontario' instead of 'ON'
SELECT
  patients.first_name,
  patients.last_name,
  province_names.province_name AS province
FROM patients
  JOIN province_names ON province_names.province_id = patients.province_id  

-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
SELECT
  patient_id,
  first_name
FROM patients
WHERE
  first_name LIKE "s%s"
  AND length(first_name) >= 6

-- Show the total amount of male patients and the total amount of female patients in the patients table.
-- Display the two results in the same row.
SELECT
  COUNT(
    CASE
      WHEN gender = 'M' THEN 1
    END
  ) AS male_count,
  COUNT(
    CASE
      WHEN gender = 'F' THEN 1
    END
  ) AS female_count
FROM patients

-- Show the city and the total number of patients in the city.
-- Order from most to least patients and then by city name ascending.
SELECT
  city,
  COUNT(*) AS num_patients
FROM patients
GROUP BY(city)
ORDER BY
  num_patients DESC,
  city ASC

-- Show first name, last name and role of every person that is either patient or doctor.
-- The roles are either "Patient" or "Doctor"
SELECT
  first_name,
  last_name,
  'Patient' AS ROLE
FROM patients
UNION ALL
SELECT
  first_name,
  last_name,
  'Doctor' AS ROLE
FROM doctors

-- Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria:
-- 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19.
-- 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.
  SELECT
  patient_id,
  attending_doctor_id,
  diagnosis
FROM admissions
WHERE
  (
    attending_doctor_id IN (1, 5, 19)
    AND patient_id % 2 != 0
  )
  OR (
    attending_doctor_id LIKE '%2%'
    AND len(patient_id) = 3
  )

-- Show all columns for patient_id 542's most recent admission_date.
SELECT *
FROM admissions
WHERE patient_id = 542 AND admission_date = (
    SELECT max(admission_date)
    FROM admissions
    WHERE patient_id = 542
  )

-- Show first_name, last_name, and the total number of admissions attended for each doctor.
-- Every admission has been attended by a doctor.
SELECT
  doctors.first_name,
  doctors.last_name,
  COUNT(*) AS admissions_total
FROM admissions
  JOIN doctors ON admissions.attending_doctor_id = doctors.doctor_id
GROUP BY attending_doctor_id
