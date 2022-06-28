USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AIRLINE_QCHARGE](
	[AIRLINE_CODE] [dbo].[AIRLINE_CODE] NOT NULL,
	[GROUP_SEQ] [int] NOT NULL,
	[REGION_SEQ] [int] NOT NULL,
	[QCHARGE_SEQ] [int] NOT NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[QCHARGE_PRICE] [decimal](10, 0) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[ADT_QCHARGE] [int] NULL,
	[CHD_QCHARGE] [int] NULL,
	[INF_QCHARGE] [int] NULL,
	[EDT_DATE] [datetime] NULL,
	[EDT_CODE] [dbo].[EMP_CODE] NULL,
 CONSTRAINT [PK_AIRLINE_QCHARGE] PRIMARY KEY CLUSTERED 
(
	[AIRLINE_CODE] ASC,
	[GROUP_SEQ] ASC,
	[REGION_SEQ] ASC,
	[QCHARGE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIRLINE_QCHARGE]  WITH CHECK ADD  CONSTRAINT [R_407] FOREIGN KEY([AIRLINE_CODE], [GROUP_SEQ], [REGION_SEQ])
REFERENCES [dbo].[AIRLINE_REGION] ([AIRLINE_CODE], [GROUP_SEQ], [REGION_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AIRLINE_QCHARGE] CHECK CONSTRAINT [R_407]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'GROUP_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지역순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'REGION_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'요금순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'QCHARGE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용시작일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'START_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용종료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'END_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'QCHARGE_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성인유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'ADT_QCHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'아동유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'CHD_QCHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유아유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'INF_QCHARGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사지역별유류할증료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AIRLINE_QCHARGE'
GO
