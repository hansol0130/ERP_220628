USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PUB_AIRLINE](
	[AIRLINE_CODE] [char](2) NOT NULL,
	[KOR_NAME] [varchar](100) NULL,
	[ENG_NAME] [varchar](100) NULL,
	[ALLIANCE_CODE] [char](2) NULL,
	[LINK_LVL] [char](2) NULL,
	[CRS] [char](1) NULL,
	[SORT_ORDER] [int] NULL,
	[DISPLAY_YN] [char](1) NULL,
	[NEW_CODE] [varchar](25) NULL,
	[NEW_DATE] [datetime] NULL,
	[EDT_CODE] [varchar](25) NULL,
	[EDT_DATE] [datetime] NULL,
	[air_num] [varchar](3) NULL,
	[AIRLINE_TYPE] [int] NULL,
 CONSTRAINT [PK__PUB_AIRLINE__1273C1CD] PRIMARY KEY CLUSTERED 
(
	[AIRLINE_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PUB_AIRLINE] ADD  CONSTRAINT [DF_PUB_AIRLINE_SORT_ORDER]  DEFAULT ((50)) FOR [SORT_ORDER]
GO
ALTER TABLE [dbo].[PUB_AIRLINE] ADD  CONSTRAINT [DF_PUB_AIRLINE_DISPLAY_YN]  DEFAULT ('Y') FOR [DISPLAY_YN]
GO
ALTER TABLE [dbo].[PUB_AIRLINE] ADD  CONSTRAINT [DF__PUB_AIRLI__CREAT__1367E606]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[PUB_AIRLINE] ADD  CONSTRAINT [DEF_PUB_AIRLINE_AIRLINE_TYPE]  DEFAULT ((3)) FOR [AIRLINE_TYPE]
GO
ALTER TABLE [dbo].[PUB_AIRLINE]  WITH CHECK ADD  CONSTRAINT [FK__PUB_AIRLI__ALLIA__25869641] FOREIGN KEY([ALLIANCE_CODE])
REFERENCES [dbo].[PUB_ALLIANCE] ([ALLIANCE_CODE])
GO
ALTER TABLE [dbo].[PUB_AIRLINE] CHECK CONSTRAINT [FK__PUB_AIRLI__ALLIA__25869641]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'한굴항공사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문항공사명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'ENG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공동맹코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'ALLIANCE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가입레벨' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'LINK_LVL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사용CRS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'CRS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정렬순서' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'SORT_ORDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'표시여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'DISPLAY_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'air_num'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE', @level2type=N'COLUMN',@level2name=N'AIRLINE_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PUB_AIRLINE'
GO
