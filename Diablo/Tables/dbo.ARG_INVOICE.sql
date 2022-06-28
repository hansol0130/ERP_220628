USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARG_INVOICE](
	[ARG_CODE] [varchar](12) NOT NULL,
	[GRP_SEQ_NO] [int] NOT NULL,
	[LAND_SEQ_NO] [int] NULL,
	[CURRENCY] [int] NULL,
	[EXH_RATE] [money] NULL,
	[AIRLINE] [varchar](200) NULL,
	[HOTEL] [varchar](500) NULL,
	[CONTENT] [nvarchar](max) NULL,
	[ACC_NAME] [varchar](30) NULL,
	[REG_NAME] [varchar](20) NULL,
	[REG_NUMBER] [varchar](20) NULL,
	[HOPE_PAYDATE] [datetime] NULL,
 CONSTRAINT [PK_ARG_INVOICE] PRIMARY KEY CLUSTERED 
(
	[ARG_CODE] ASC,
	[GRP_SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ARG_INVOICE]  WITH CHECK ADD  CONSTRAINT [R_411] FOREIGN KEY([ARG_CODE], [GRP_SEQ_NO])
REFERENCES [dbo].[ARG_DETAIL] ([ARG_CODE], [GRP_SEQ_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ARG_INVOICE] CHECK CONSTRAINT [R_411]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수배번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE', @level2type=N'COLUMN',@level2name=N'ARG_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'그룹순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE', @level2type=N'COLUMN',@level2name=N'GRP_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE', @level2type=N'COLUMN',@level2name=N'LAND_SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 : KRW, 1 : USD, 2 : EUR, 3 : JPY, 4 : CNY, 5 : CHF, 6 : AUD, 7 : HKD, 8 : NZD,  9 : THB, 10 : GBP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE', @level2type=N'COLUMN',@level2name=N'CURRENCY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'환율' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE', @level2type=N'COLUMN',@level2name=N'EXH_RATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'항공' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE', @level2type=N'COLUMN',@level2name=N'AIRLINE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE', @level2type=N'COLUMN',@level2name=N'HOTEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'내용' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE', @level2type=N'COLUMN',@level2name=N'CONTENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE', @level2type=N'COLUMN',@level2name=N'ACC_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예금주' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE', @level2type=N'COLUMN',@level2name=N'REG_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'계좌번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE', @level2type=N'COLUMN',@level2name=N'REG_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금희망일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE', @level2type=N'COLUMN',@level2name=N'HOPE_PAYDATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수배 인보이스' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ARG_INVOICE'
GO
