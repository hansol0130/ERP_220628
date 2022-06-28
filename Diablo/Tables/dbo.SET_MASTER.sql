USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SET_MASTER](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[SET_STATE] [int] NULL,
	[PROFIT] [int] NULL,
	[PAY_PRICE] [int] NULL,
	[GRP_PRICE] [int] NULL,
	[AIR_PRICE] [int] NULL,
	[LAND_PRICE] [int] NULL,
	[PRI_PRICE] [int] NULL,
	[COM_PRICE] [int] NULL,
	[AIR_PROFIT] [int] NULL,
	[SALE_PRICE] [int] NULL,
	[GRP_PROFIT] [int] NULL,
	[EDI_CODE] [dbo].[EDI_CODE] NULL,
	[MASTER_CODE] [dbo].[MASTER_CODE] NULL,
	[PRO_TYPE] [dbo].[PRO_TYPE] NULL,
	[DEP_DATE] [datetime] NULL,
	[ARR_DATE] [datetime] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[PROFIT_TEAM_CODE] [varchar](3) NULL,
	[PROFIT_TEAM_NAME] [varchar](50) NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[PRI_CLOSE_YN] [char](1) NULL,
	[CLOSE_CODE] [char](7) NULL,
	[CLOSE_DATE] [datetime] NULL,
 CONSTRAINT [PK_SET_MASTER] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SET_MASTER] ADD  DEFAULT ('N') FOR [PRI_CLOSE_YN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : 정산진행중, 1 : 결재진행중, 2 : 정산완료, 3 : 재정산 ( 0 : 전체, 1 : 정산진행중, 2 : 미정산, 3 : 재정산, 4 : SYSTEM마감, 5 : 정산완료)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'SET_STATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품수익' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'PROFIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'PAY_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'공동경비' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'GRP_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공비' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'AIR_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지상비' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'LAND_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'개인경비' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'PRI_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'COM_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공수익' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'AIR_PROFIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'매출액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'SALE_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'기타수익' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'GRP_PROFIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'문서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'EDI_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상품타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'PRO_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도착일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'ARR_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매실적부서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'PROFIT_TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'판매실적부서명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'PROFIT_TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정산마감여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'PRI_CLOSE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정산마감자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'CLOSE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정산마감일시' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER', @level2type=N'COLUMN',@level2name=N'CLOSE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'정산 마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_MASTER'
GO
