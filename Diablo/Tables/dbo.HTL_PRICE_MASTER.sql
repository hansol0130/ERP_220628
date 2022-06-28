USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HTL_PRICE_MASTER](
	[MASTER_CODE] [dbo].[MASTER_CODE] NOT NULL,
	[PRICE_SEQ] [int] NOT NULL,
	[ROOM_TYPE] [int] NULL,
	[ROOM_NAME] [varchar](30) NULL,
	[BREAKFAST_YN] [char](1) NULL,
	[BREAKFAST_NAME] [varchar](30) NULL,
	[AGT_MASTER] [varchar](10) NULL,
	[PRICE_REMARK] [varchar](30) NULL,
	[SHOW_YN] [char](1) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
 CONSTRAINT [PK_HTL_PRICE_MASTER] PRIMARY KEY CLUSTERED 
(
	[MASTER_CODE] ASC,
	[PRICE_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HTL_PRICE_MASTER]  WITH CHECK ADD  CONSTRAINT [R_376] FOREIGN KEY([MASTER_CODE])
REFERENCES [dbo].[HTL_MASTER] ([MASTER_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[HTL_PRICE_MASTER] CHECK CONSTRAINT [R_376]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔마스터코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER', @level2type=N'COLUMN',@level2name=N'MASTER_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER', @level2type=N'COLUMN',@level2name=N'PRICE_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룸타입 ( 0 : None, 1 : SGL, 2 : DBL, 3 : TWN , 4 : TRP, 5 : QRD, 21 : BS, 22 : DB, 23 : FT, 24 : OB, 25 : OD, 26 : Q, 27 : SB, 28 : TB, 29 : TR, 30 : TS )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER', @level2type=N'COLUMN',@level2name=N'ROOM_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'룸명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER', @level2type=N'COLUMN',@level2name=N'ROOM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조식여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER', @level2type=N'COLUMN',@level2name=N'BREAKFAST_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'조식명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER', @level2type=N'COLUMN',@level2name=N'BREAKFAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'거래처코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER', @level2type=N'COLUMN',@level2name=N'AGT_MASTER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가격비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER', @level2type=N'COLUMN',@level2name=N'PRICE_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'활성여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER', @level2type=N'COLUMN',@level2name=N'SHOW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'호텔가격마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HTL_PRICE_MASTER'
GO
