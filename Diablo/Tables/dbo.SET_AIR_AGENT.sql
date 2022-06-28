USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SET_AIR_AGENT](
	[PRO_CODE] [dbo].[PRO_CODE] NOT NULL,
	[AIRLINE_CODE] [dbo].[AIRLINE_CODE] NOT NULL,
	[AIR_SEQ_NO] [int] NOT NULL,
	[DEP_DATE] [datetime] NULL,
	[ROUTING] [varchar](100) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[FOC_COUNT] [int] NULL,
	[FOC_PROFIT] [int] NULL,
	[DOC_YN] [char](1) NULL,
	[EDI_CODE] [char](10) NULL,
	[AIR_ETC_PROFIT] [int] NULL,
	[AIR_ETC_PRICE] [int] NULL,
	[COM_RATE] [int] NULL,
	[COMM_PRICE] [int] NULL,
	[VAT_PRICE] [int] NULL,
	[CITY_CODE] [char](3) NULL,
 CONSTRAINT [PK_SET_AIR_AGENT] PRIMARY KEY CLUSTERED 
(
	[PRO_CODE] ASC,
	[AIR_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SET_AIR_AGENT] ADD  DEFAULT ('N') FOR [DOC_YN]
GO
ALTER TABLE [dbo].[SET_AIR_AGENT] ADD  CONSTRAINT [DF_SET_AIR_AGENT_AIR_ETC_PROFIT]  DEFAULT ((0)) FOR [AIR_ETC_PROFIT]
GO
ALTER TABLE [dbo].[SET_AIR_AGENT] ADD  CONSTRAINT [DF_SET_AIR_AGENT_AIR_ETC_PRICE]  DEFAULT ((0)) FOR [AIR_ETC_PRICE]
GO
ALTER TABLE [dbo].[SET_AIR_AGENT] ADD  CONSTRAINT [DF_SET_AIR_AGENT_COM_RATE]  DEFAULT ((0)) FOR [COM_RATE]
GO
ALTER TABLE [dbo].[SET_AIR_AGENT] ADD  CONSTRAINT [DF_SET_AIR_AGENT_COMM_PRICE]  DEFAULT ((0)) FOR [COMM_PRICE]
GO
ALTER TABLE [dbo].[SET_AIR_AGENT] ADD  CONSTRAINT [DF_SET_AIR_AGENT_VAT_PRICE]  DEFAULT ((0)) FOR [VAT_PRICE]
GO
ALTER TABLE [dbo].[SET_AIR_AGENT]  WITH CHECK ADD  CONSTRAINT [R_310] FOREIGN KEY([PRO_CODE])
REFERENCES [dbo].[SET_MASTER] ([PRO_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SET_AIR_AGENT] CHECK CONSTRAINT [R_310]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'행사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'PRO_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공사코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'AIRLINE_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처 순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'AIR_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출발일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'DEP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여정' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'ROUTING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FOC 장수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'FOC_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FOC 수익' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'FOC_PROFIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'지결작성유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'DOC_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'문서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'EDI_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예외수익' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'AIR_ETC_PROFIT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예외비용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'AIR_ETC_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'COM_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수수료금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'COMM_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VAT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'VAT_PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'도시코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT', @level2type=N'COLUMN',@level2name=N'CITY_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공비 거래처' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SET_AIR_AGENT'
GO
