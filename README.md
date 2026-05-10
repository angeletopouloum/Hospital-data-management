# Hospital-data-management

PROJECT ASSUMPTIONS

1) Supervisors can supervise more than one doctor.
2) Hospital departments cannot be deleted.
3) If multiple departments of the same specialty exists (e.g. multiple Cardiology departments), we assume that their names contain
    letters corresponding to their numbering (e.g. "Cardiology A' ", "Cardiology B' " etc). Therefore, we treat them as seperate
    and unique table rows.
4) Beds cannot be deleted, rather they may only be updated.
5) According to E.164, phone numbers should have a maximum length of 15 digits, excluding country/area codes, as well as the "+" symbol.
    For the purposes of this project, we assume that phone numbers cannot have more than 20 digits.
6) In the 'Prescriptions' table, the 'end_date' attribute is allowed to be NULL, to account for chronic ailments.
7) The translations for staff ranks are according to the source:
    https://medinelingua.info/greek/gr_environment.php
    We assume that ranks are given in English, with only the first letter of each word capitalised.
8) We assume that a discharge date is only available to the database after the patient has been discharged.
9) Two shifts are considered to be consecutive, if the staff memeber works for two full 8-hour shifts. 
    We do not consider overtime to be an additional shift.
10) Shifts are registered based on their type (e.g. 'Morning'). The start and end times are automatically
    configured by the system.
11) For the shift types, seeing as the start time for a particular shift overlaps with the end time of the previous shift type,
    we assume that the shift begins at the designated hour plus one minute (e.g. morning shift: 07:01-15:00 instead of 07:00-15:00).+ 3).
12) Only future shifts can be logged.
13) Shift hours have values in the range [0, 23].