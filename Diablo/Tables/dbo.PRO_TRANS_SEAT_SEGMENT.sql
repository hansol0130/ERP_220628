USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRO_TRANS_SEAT_SEGMENT](
	[SEAT_CODE] [dbo].[SEAT_CODE] NOT NULL,
	[TRANS_SEQ] [int] NOT NULL,
	[SEG_NO] [int] NOT NULL,
	[DEP_AIRPORT_CODE] [dbo].[AIRPORT_CODE] NULL,
	[ARR_AIRPORT_CODE] [dbo].[AIRPORT_CODE] NULL,
	[AIRLINE_CODE] [dbo].[AIRLINE_CODE] NULL,
	[FLIGHT] [varchar](20) NULL,
	[DEP_DATE] [datetime] NULL,
	[ARR_DATE] [datetime] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[REAL_AIRLINE_CODE] [varchar](2) NULL,
	[FLYING_TIME] [varchar](5) NULL,
 CONSTRAINT [PKG_PRO_TRANS_SEAT_SEGMENT] PRIMARY KEY CLUSTERED 
(
	[SEAT_CODE] ASC,
	[TRANS_SEQ] ASC,
	[SEG_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PRO_TRANS_SEAT_SEGMENT]  WITH CHECK ADD  CONSTRAINT [R_257] FOREIGN KEY([SEAT_CODE])
REFERENCES [dbo].[PRO_TRANS_SEAT] ([SEAT_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PRO_TRANS_SEAT_SEGMENT] CHECK CONSTRAINT [R_257]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌석코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'SEAT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'TRANS_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'세그순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'SEG_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'DEP_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착공항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'ARR_AIRPORT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공편명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'FLIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'실제운항코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'REAL_AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비행시간' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT', @level2type=N'COLUMN',@level2name=N'FLYING_TIME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'좌석관리상세세그정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PRO_TRANS_SEAT_SEGMENT'
GO
