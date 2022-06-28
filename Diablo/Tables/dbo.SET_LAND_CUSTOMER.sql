USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SET_LAND_CUSTOMER](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[LAND_SEQ_NO] [int] NOT NULL,
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[RES_SEQ_NO] [int] NOT NULL,
	[VAT_PRICE] [money] NULL,
	[EXC_RATE] [money] NULL,
	[CUR_TYPE] [int] NULL,
	[FOREIGN_PRICE] [money] NULL,
	[KOREAN_PRICE] [money] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[REMARK] [varchar](200) NULL,
	[PAY_PRICE] [int] NULL,
	[COM_RATE] [numeric](5, 2) NULL,
	[COM_PRICE] [int] NULL,
 CONSTRAINT [PK_SET_LAND_CUSTOMER] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[LAND_SEQ_NO] ASC,
	[RES_CODE] ASC,
	[RES_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SET_LAND_CUSTOMER]  WITH CHECK ADD  CONSTRAINT [R_314] FOREIGN KEY([PRO_CODE], [LAND_SEQ_NO])
REFERENCES [dbo].[SET_LAND_AGENT] ([PRO_CODE], [LAND_SEQ_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SET_LAND_CUSTOMER] CHECK CONSTRAINT [R_314]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처 순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'LAND_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'RES_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부가세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'VAT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환율기준' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'EXC_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 원화, 2 : 달러화, 3 : 엔화, 4 : 유로화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'CUR_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'외화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'FOREIGN_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'원화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'KOREAN_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'PAY_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'COM_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER', @level2type=N'COLUMN',@level2name=N'COM_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지상비 거래처별 고객' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_CUSTOMER'
GO
