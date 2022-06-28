USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARG_INVOICE_DETAIL](
	[ARG_CODE] [varchar](12) NOT NULL,
	[GRP_SEQ_NO] [int] NOT NULL,
	[DET_SEQ_NO] [int] NOT NULL,
	[INV_SEQ_NO] [int] NOT NULL,
	[PRICE] [decimal](10, 2) NULL,
	[PERSONS] [int] NULL,
	[FOC] [int] NULL,
	[ETC_REMARK] [nvarchar](1000) NULL,
 CONSTRAINT [PK_ARG_INVOICE_DETAIL] PRIMARY KEY CLUSTERED 
(
	[ARG_CODE] ASC,
	[GRP_SEQ_NO] ASC,
	[DET_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ARG_INVOICE_DETAIL]  WITH CHECK ADD  CONSTRAINT [R_414] FOREIGN KEY([ARG_CODE], [GRP_SEQ_NO])
REFERENCES [dbo].[ARG_INVOICE] ([ARG_CODE], [GRP_SEQ_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ARG_INVOICE_DETAIL] CHECK CONSTRAINT [R_414]
GO
ALTER TABLE [dbo].[ARG_INVOICE_DETAIL]  WITH CHECK ADD  CONSTRAINT [R_415] FOREIGN KEY([INV_SEQ_NO])
REFERENCES [dbo].[ARG_INVOICE_ITEM] ([INV_SEQ_NO])
GO
ALTER TABLE [dbo].[ARG_INVOICE_DETAIL] CHECK CONSTRAINT [R_415]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE_DETAIL', @level2type=N'COLUMN',@level2name=N'GRP_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'상세순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE_DETAIL', @level2type=N'COLUMN',@level2name=N'DET_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인보이스항목번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE_DETAIL', @level2type=N'COLUMN',@level2name=N'INV_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE_DETAIL', @level2type=N'COLUMN',@level2name=N'PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'인원' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE_DETAIL', @level2type=N'COLUMN',@level2name=N'PERSONS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FOC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE_DETAIL', @level2type=N'COLUMN',@level2name=N'FOC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE_DETAIL', @level2type=N'COLUMN',@level2name=N'ETC_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수배 인보이스 항목' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE_DETAIL'
GO
