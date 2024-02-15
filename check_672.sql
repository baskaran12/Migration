-------------672
WITH VQ_672 AS (
SELECT DISTINCT LEGACY_CUST_ID,
A.SOURCE_SYSTEM,
  LEGACY_CONTACT_ID,
  legacy_sub_no,
  c.legacy_site_id,
  c.LEGACY_ADDRESS_ID,
  ELOC_LOCATION_ID
FROM migration_10.uf_address a,
  migration_10.uf_con_roles c,
  migration_10.uf_subscriber s
WHERE a.LEGACY_ADDRESS_ID = c.LEGACY_ADDRESS_ID
AND c.LEGACY_ENTITY_ID    = s.LEGACY_SUB_NO
AND((ELOC_LOCATION_ID    IS NULL
OR ELOC_LOCATION_ID       =0))
AND s.access_provider     ='Comcast'
AND c.RECORD_LEVEL        = 'S')

SELECT DISTINCT LEGACY_CUST_ID,HIER.FINAL_SCHEMA,LEGACY_ADDRESS_ID,
CASE WHEN HIER.FINAL_SCHEMA='ME' AND LEGACY_ADDRESS_ID  IN 
(select locationid from APP_2.APP_CLIPS_ADDRESS_ELOC_SUCESS  where modify_dts is null AND STD_ELOC_LOCATION_ID IS NOT NULL
AND EPID IN (SELECT  IDENTIFIER FROM migration_6.STG_SRC_SUBSCRIBER_LOB)
)
THEN 'NEED TO CHECK-MIGHT BE ONE NULL AND ONE VALID ELOC IN SRC'
WHEN HIER.FINAL_SCHEMA='AV' AND LEGACY_ADDRESS_ID  IN 
(select locationid from APP_2.APP_CLIPS_ADDRESS_ELOC_SUCESS  where modify_dts is null AND STD_ELOC_LOCATION_ID IS NOT NULL
AND EPID IN (SELECT  IDENTIFIER FROM migration_8.STG_SRC_SUBSCRIBER_LOB)
)
THEN 'NEED TO CHECK-MIGHT BE ONE NULL AND ONE VALID ELOC IN SRC'
WHEN HIER.FINAL_SCHEMA='BCV' AND LEGACY_ADDRESS_ID  IN 
(select locationid from APP_2.APP_CLIPS_ADDRESS_ELOC_SUCESS  where modify_dts is null AND STD_ELOC_LOCATION_ID IS NOT NULL
AND EPID IN (SELECT  IDENTIFIER FROM migration_9.STG_SRC_SUBSCRIBER_LOB)
)
THEN 'NEED TO CHECK-MIGHT BE ONE NULL AND ONE VALID ELOC IN SRC'
WHEN SOURCE_SYSTEM='CSG'
THEN 'NEED TO CHECK IN CSG SRC'
ELSE 'ELOC NULL IN SRC' END AS RCA
FROM 
VQ_672 VQ,APP_2.CUST_HIERARCHY HIER WHERE VQ.LEGACY_CUST_ID=HIER.ACCOUNT_NAME;
