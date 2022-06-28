USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SINGLE_PRODUCT](
	[SEQ] [int] IDENTITY(1,1) NOT NULL,
	[NAME] [varchar](20) NOT NULL,
	[TEL] [varchar](13) NOT NULL,
	[EMAIL] [varchar](40) NOT NULL,
	[DELV_NAME] [varchar](20) NOT NULL,
	[ZIP_CODE] [varchar](7) NOT NULL,
	[ADDRESS1] [varchar](100) NOT NULL,
	[ADDRESS2] [varchar](100) NOT NULL,
	[MARKETING] [varchar](1) NOT NULL,
	[CNT] [int] NOT NULL,
	[PRICE] [int] NOT NULL,
	[CUS_NO] [int] NULL,
	[NEW_DATE] [datetime] NOT NULL,
	[BBS_SEQ] [int] NOT NULL,
 CONSTRAINT [PK_SINGLE_PRODUCT] PRIMARY KEY CLUSTERED 
(
	[SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SINGLE_PRODUCT] ADD  DEFAULT (getdate()) FOR [NEW_DATE]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주문자이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전화번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'TEL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'배송받을이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'DELV_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'우편번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'ZIP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'ADDRESS1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'주소2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'ADDRESS2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'마케팅동의여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'MARKETING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수량' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'CNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'단가' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'게시판번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SINGLE_PRODUCT', @level2type=N'COLUMN',@level2name=N'BBS_SEQ'
GO
