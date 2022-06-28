USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_UNREG_HOTEL_OF_INSERT]      
/*      
 USP_UNREG_HOTEL_OF_INSERT '', '', '', '', '', '', '', '', '', ''
*/      
      
@NAME VARCHAR(200),      
@ENG_NAME VARCHAR(200),      
@CITY_CODE INT,      
@CITY_NAME VARCHAR(100),      
@ADDRESS VARCHAR(200),      
@PHONE VARCHAR(50),      
@FAX VARCHAR(50),  
@LATITUDE VARCHAR(50),  
@LONGITUDE VARCHAR(50),
@CREATE_USER VARCHAR(100)      
      
AS      
      
       
DECLARE @HOTEL_CODE VARCHAR(MAX)      
SELECT @HOTEL_CODE = SUBSTRING(HOTEL_CODE, 3, 100000)+1 FROM HTL_INFO_MAST_HOTEL_OF ORDER BY CREATE_DATE ASC      
      
IF (@HOTEL_CODE) IS NULL      
BEGIN      
      
INSERT INTO HTL_INFO_MAST_HOTEL_OF      
(      
 HOTEL_CODE,      
 NAME,      
 ENG_NAME,      
 CITY_CODE,      
 CITY_NAME,      
 [ADDRESS],      
 PHONE,      
 FAX,      
 LATITUDE,  
 LONGITUDE,  
 CREATE_DATE,
 CREATE_USER
)      
VALUES      
(      
 'OF1',      
 @NAME,      
 @ENG_NAME,      
 @CITY_CODE,      
 @CITY_NAME,      
 @ADDRESS,      
 @PHONE,      
 @FAX,      
 @LATITUDE,  
 @LONGITUDE,  
 GETDATE(),
 @CREATE_USER      
)      
      
END      
      
ELSE      
      
BEGIN      
      
INSERT INTO HTL_INFO_MAST_HOTEL_OF      
(      
 HOTEL_CODE,      
 NAME,      
 ENG_NAME,      
 CITY_CODE,      
 CITY_NAME,      
 [ADDRESS],      
 PHONE,      
 FAX,      
 LATITUDE,  
 LONGITUDE,  
 CREATE_DATE,
 CREATE_USER      
)      
VALUES      
(      
 'OF'+@HOTEL_CODE,      
 @NAME,      
 @ENG_NAME,      
 @CITY_CODE,      
 @CITY_NAME,      
 @ADDRESS,      
 @PHONE,      
 @FAX,      
 @LATITUDE,  
 @LONGITUDE,  
 GETDATE(),
 @CREATE_USER      
)      
      
END


GO
