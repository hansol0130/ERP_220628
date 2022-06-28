USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		이규식
-- Create date: 2010-2-15
-- Description:	GTA Static Data 이미지 정보를 DB에 입력한다.
-- =============================================
CREATE PROCEDURE [dbo].[SP_HTL_GTA_IMAGE_INSERT]
	@XML Nvarchar(max)
AS
BEGIN

DECLARE @docHandle int

-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

EXEC sp_xml_preparedocument @docHandle OUTPUT, @xml;

-- CITY, ITEM, TYPE, THUMBNAIL IMAGE WIDTH HEIGHT

WITH Hotel (CITY, ITEM, TYPE, THUMBNAIL, IMAGE, WIDTH, HEIGHT) AS
(
	SELECT 
		*
	FROM OPENXML(@DOCHANDLE, N'/Response/ResponseDetails/SearchLinkResponse/LinkDetails/LinkDetail/Links/ImageLinks/ImageLink', 0)
	WITH
	(
		CITY	varchar(50)	'../../../City/@Code',
		ITEM	varchar(50) '../../../Item/@Code',
		TYPE	varchar(50) './Text',
		THUMBNAIL varchar(1000) './ThumbNail',
		IMAGE varchar(1000) './Image',
		WIDTH INT	'./@Width',
		HEIGHT INT './@Height'
	)
)
INSERT INTO GTA_IMAGELINK_20100215(CITY, ITEM, TYPE, THUMBNAIL, IMAGE, WIDTH, HEIGHT)
SELECT 
	*
FROM HOTEL A

EXEC sp_xml_removedocument @docHandle 	

END






GO
