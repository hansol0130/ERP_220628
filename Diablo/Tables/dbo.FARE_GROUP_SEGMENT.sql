USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FARE_GROUP_SEGMENT](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[SEG_NO] [int] NOT NULL,
	[DEP_AIRPORT_CODE] [dbo].[AIRPORT_CODE] NULL,
	[ARR_AIRPORT_CODE] [dbo].[AIRPORT_CODE] NULL,
	[AIRLINE_CODE] [dbo].[AIRLINE_CODE] NULL,
	[FLIGHT] [varchar](20) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[DEP_DATE] [datetime] NULL,
	[ARR_DATE] [datetime] NULL,
	[SEAT_STATUS] [char](2) NULL,
 CONSTRAINT [PK_FARE_GROUP_SEGMENT] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[SEG_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FARE_GROUP_SEGMENT]  WITH CHECK ADD  CONSTRAINT [R_255] FOREIGN KEY([PRO_CODE])
REFERENCES [dbo].[FARE_GROUP] ([PRO_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FARE_GROUP_SEGMENT] CHECK CONSTRAINT [R_255]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT', @level2type=N'COLUMN',@level2name=N'SEG_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발고항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT', @level2type=N'COLUMN',@level2name=N'DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT', @level2type=N'COLUMN',@level2name=N'ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'편명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT', @level2type=N'COLUMN',@level2name=N'FLIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT', @level2type=N'COLUMN',@level2name=N'ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌석상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT', @level2type=N'COLUMN',@level2name=N'SEAT_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공동구매세그정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FARE_GROUP_SEGMENT'
GO
