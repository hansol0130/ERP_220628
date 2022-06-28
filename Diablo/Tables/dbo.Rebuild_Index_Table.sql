USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rebuild_Index_Table](
	[ObjectName] [char](255) NULL,
	[ObjectId] [int] NULL,
	[IndexName] [char](255) NULL,
	[IndexId] [int] NULL,
	[Lvl] [int] NULL,
	[CountPages] [int] NULL,
	[CountRows] [int] NULL,
	[MinRecSize] [int] NULL,
	[MaxRecSize] [int] NULL,
	[AvgRecSize] [int] NULL,
	[ForRecCount] [int] NULL,
	[Extents] [int] NULL,
	[ExtentSwitches] [int] NULL,
	[AvgFreeBytes] [int] NULL,
	[AvgPageDensity] [int] NULL,
	[ScanDensity] [decimal](18, 0) NULL,
	[BestCount] [int] NULL,
	[ActualCount] [int] NULL,
	[LogicalFrag] [decimal](18, 0) NULL,
	[ExtentFrag] [decimal](18, 0) NULL
) ON [PRIMARY]
GO
