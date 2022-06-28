USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DSR_SEGMENT](
	[BKG_CLASS] [varchar](20) NULL,
	[TICKET] [varchar](10) NOT NULL,
	[FARE_BASIS] [varchar](20) NULL,
	[AIRLINE_CODE] [varchar](20) NULL,
	[FLIGHT] [varchar](20) NULL,
	[DEPARTURE_DATE] [datetime] NULL,
	[ARRIVAL_DATE] [datetime] NULL,
	[BKS_STATUS] [varchar](20) NULL,
	[VALID_BEFORE] [datetime] NULL,
	[VALID_AFTER] [datetime] NULL,
	[SEG_SEQ] [int] NOT NULL,
 CONSTRAINT [PK_DSR_SEGMENT] PRIMARY KEY CLUSTERED 
(
	[TICKET] ASC,
	[SEG_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DSR_SEGMENT]  WITH CHECK ADD  CONSTRAINT [R_297] FOREIGN KEY([TICKET])
REFERENCES [dbo].[DSR_TICKET] ([TICKET])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DSR_SEGMENT] CHECK CONSTRAINT [R_297]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CLASS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_SEGMENT', @level2type=N'COLUMN',@level2name=N'BKG_CLASS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_SEGMENT', @level2type=N'COLUMN',@level2name=N'TICKET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'운임종류' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_SEGMENT', @level2type=N'COLUMN',@level2name=N'FARE_BASIS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_SEGMENT', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공편' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_SEGMENT', @level2type=N'COLUMN',@level2name=N'FLIGHT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_SEGMENT', @level2type=N'COLUMN',@level2name=N'DEPARTURE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_SEGMENT', @level2type=N'COLUMN',@level2name=N'ARRIVAL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_SEGMENT', @level2type=N'COLUMN',@level2name=N'BKS_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓유효시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_SEGMENT', @level2type=N'COLUMN',@level2name=N'VALID_BEFORE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓유효종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_SEGMENT', @level2type=N'COLUMN',@level2name=N'VALID_AFTER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'경유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_SEGMENT', @level2type=N'COLUMN',@level2name=N'SEG_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DSR경유정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_SEGMENT'
GO
