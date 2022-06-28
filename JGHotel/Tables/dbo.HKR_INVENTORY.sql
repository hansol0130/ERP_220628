USE [JGHotel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HKR_INVENTORY](
	[Hotel_CD] [nvarchar](255) NULL,
	[Nation_CD] [nvarchar](255) NULL,
	[Nation_Nm_EN] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[City_CD] [nvarchar](255) NULL,
	[City_Nm_EN] [nvarchar](255) NULL,
	[Hotel_Nm_EN] [nvarchar](255) NULL,
	[Grade] [nvarchar](255) NULL,
	[Hotel_Tel] [nvarchar](255) NULL,
	[Hotel_Fax] [nvarchar](255) NULL,
	[Hotel_Addr] [nvarchar](255) NULL,
	[Latitude] [nvarchar](255) NULL,
	[Longitude] [nvarchar](255) NULL,
	[WebSite] [nvarchar](255) NULL,
	[HBD_REF_CD] [nvarchar](255) NULL,
	[Key_Product] [nvarchar](255) NULL,
	[Top_Selling] [nvarchar](255) NULL,
	[REG_DATE] [nvarchar](255) NULL,
	[Item_Status] [nvarchar](255) NULL
) ON [PRIMARY]
GO
