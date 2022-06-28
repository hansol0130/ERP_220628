USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SET_LAND_AGENT](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[LAND_SEQ_NO] [int] NOT NULL,
	[AGT_CODE] [varchar](10) NULL,
	[CUR_TYPE] [int] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[REMARK] [varchar](500) NULL,
	[PAY_PRICE] [decimal](12, 2) NULL,
	[PAY_PRICE_YN] [char](1) NULL,
	[DOC_YN] [char](1) NULL,
	[EDI_CODE] [dbo].[EDI_CODE] NULL,
	[PAY_DATE] [datetime] NULL,
	[FOC_COUNT] [int] NULL,
	[FOREIGN_PRICE] [money] NULL,
	[KOREAN_PRICE] [money] NULL,
	[VAT_PRICE] [money] NULL,
	[RES_COUNT] [int] NULL,
	[COM_RATE] [numeric](5, 2) NULL,
	[COM_PRICE] [int] NULL,
	[EXC_RATE] [decimal](8, 2) NULL,
 CONSTRAINT [PK_SET_LAND_AGENT] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[LAND_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SET_LAND_AGENT] ADD  CONSTRAINT [DEF_SET_LAND_AGENT_PAY_PRICE]  DEFAULT ((0.00)) FOR [PAY_PRICE]
GO
ALTER TABLE [dbo].[SET_LAND_AGENT]  WITH CHECK ADD  CONSTRAINT [R_312] FOREIGN KEY([PRO_CODE])
REFERENCES [dbo].[SET_MASTER] ([PRO_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SET_LAND_AGENT] CHECK CONSTRAINT [R_312]
GO
ALTER TABLE [dbo].[SET_LAND_AGENT]  WITH CHECK ADD  CONSTRAINT [R_321] FOREIGN KEY([AGT_CODE])
REFERENCES [dbo].[AGT_MASTER] ([AGT_CODE])
GO
ALTER TABLE [dbo].[SET_LAND_AGENT] CHECK CONSTRAINT [R_321]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처 순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'LAND_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'AGT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0: KRW, 1: USD, 2: EUR, 3: JPY, 4: CNY, 5: CHF, 6: AUD, 7: HKD, 8: NZD, 9: THB, 10: GBP, 11: TWD, 12: CAD, 13: SGD' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'CUR_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'PAY_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'PAY_PRICE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지결작성유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'DOC_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'문서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'EDI_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지급일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'PAY_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FOC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'FOC_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'외화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'FOREIGN_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'원화' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'KOREAN_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'부가세' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'VAT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'RES_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'COM_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'COM_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환율기준' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT', @level2type=N'COLUMN',@level2name=N'EXC_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지상비 거래처' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_LAND_AGENT'
GO
