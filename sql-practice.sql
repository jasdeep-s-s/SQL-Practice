-- For each doctor, display their id, full name, and the first and last admission date they attended.
SELECT
  concat(
    doctors.first_name,
    ' ',
    doctors.last_name
  ) AS full_name,
  doctors.doctor_id,
  min(admission_date) AS first_admission_date,
  max(admission_date) AS last_admission_date
FROM admissions
  JOIN doctors ON admissions.attending_doctor_id = doctors.doctor_id
GROUP BY attending_doctor_id

-- For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.
SELECT
  concat(
    patients.first_name,
    ' ',
    patients.last_name
  ) AS patient_name,
  admissions.diagnosis,
  concat(
    doctors.first_name,
    ' ',
    doctors.last_name
  ) AS doctor_name
FROM patients
  JOIN admissions ON admissions.patient_id = patients.patient_id
  JOIN doctors ON admissions.attending_doctor_id = doctors.doctor_id

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

-- Display patient's full name, height in the units feet rounded to 1 decimal, weight in the unit pounds rounded to 0 decimals, birth_date and gender non abbreviated.
-- Convert CM to feet by dividing by 30.48.
-- Convert KG to pounds by multiplying by 2.205.
SELECT
  concat(first_name, ' ', last_name) AS patient_name,
  round(height / 30.48, 1),
  round(weight * 2.205),
  birth_date,
  CASE
    WHEN gender = 'M' THEN 'MALE'
    WHEN gender = 'F' THEN 'FEMALE'
  END AS gender_type
FROM patients

-- Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. 
-- (Their patient_id does not exist in any admissions.patient_id rows.)
SELECT
  patients.patient_id,
  first_name,
  last_name
FROM patients
  LEFT JOIN admissions ON patients.patient_id = admissions.patient_id
WHERE admissions.patient_id IS NULL
