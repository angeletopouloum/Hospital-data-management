# Hospital-data-management

PROJECT ASSUMPTIONS

1) Supervisors can supervise more than one doctor.
2) Hospital departments cannot be deleted.
3) If multiple departments of the same specialty exist (e.g. multiple Cardiology departments), we assume that their names contain
    letters corresponding to their numbering (e.g. "Cardiology A' ", "Cardiology B' " etc). Therefore, we treat them as seperate
    and unique table rows.
4) Beds cannot be deleted, they may only be updated.
5) According to E.164, phone numbers should have a maximum length of 15 digits, excluding country/area codes, as well as the "+" symbol.
    For the purposes of this project, we assume that phone numbers cannot have more than 20 digits.
6) In the 'Prescriptions' table, the 'end_date' attribute is allowed to be NULL, to account for chronic ailments.
7) The translations for staff ranks are according to the source:
    https://medinelingua.info/greek/gr_environment.php
    We assume that ranks are given in English, with only the first letter of each word capitalised.
8) We assume that a discharge date is only available to the database after the patient has been discharged. To accomondate this assumption,
    we allow NULL values for the 'discharge_date' attribute of the Hospitilization table. We expect this attribute to be assigned a NULL
    value upon insertion, while its final value is expected to be assigned via an UPDATE operation on the table.
9) Two shifts are considered to be consecutive, if the staff memeber works for two full 8-hour shifts. 
    We do not consider overtime to be an additional shift.
10) Shifts are registered based on their start and end times. If the values given are valid based on the Hospital's predetermined shifts,
    the shift type ('Morning', 'Afternoon', 'Night') is automatically configured by the system.
11) For the shift types, seeing as the start time for a particular shift overlaps with the end time of the previous shift type,
    we assume that the shift begins at the designated hour plus one minute (e.g. morning shift: 07:01-15:00 instead of 07:00-15:00).
12) Only future shifts can be logged.
13) Shift hours have values in the range [0, 23].
14) If a shift is deleted, we assume the staff member did not complete it.
15) Certain KEN codes in the given file, either appeared as duplicate or had errors. To accomondate this, we cross-checked the erroneous 
    codes using the source: https://www.moh.gov.gr/articles/health/domes-kai-draseis-gia-thn-ygeia/kwdikopoihseis/kleista-enopoihmena-noshlia/713-kwdikopoihseis?fdl=3300
    from the Greek Ministry of Health.