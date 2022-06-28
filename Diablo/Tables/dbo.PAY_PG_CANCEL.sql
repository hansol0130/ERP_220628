USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PAY_PG_CANCEL](
	[PAY_SEQ] [int] NOT NULL,
	[CXL_PAY_SEQ] [int] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
 CONSTRAINT [PK_PAY_PG_CANCEL] PRIMARY KEY CLUSTERED 
(
	[PAY_SEQ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PAY_PG_CANCEL]  WITH CHECK ADD  CONSTRAINT [R_439] FOREIGN KEY([PAY_SEQ])
REFERENCES [dbo].[PAY_MASTER_damo] ([PAY_SEQ])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PAY_PG_CANCEL] CHECK CONSTRAINT [R_439]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입금순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_PG_CANCEL', @level2type=N'COLUMN',@level2name=N'PAY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'취소입금순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_PG_CANCEL', @level2type=N'COLUMN',@level2name=N'CXL_PAY_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_PG_CANCEL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_PG_CANCEL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'PG취소정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PAY_PG_CANCEL'
GO
