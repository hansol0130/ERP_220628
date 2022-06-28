USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FAX_RECEIVE](
	[RCV_SEQ] [dbo].[SEQ_NO] NOT NULL,
	[FAX_SEQ] [char](17) NOT NULL,
	[RCV_NUMBER1] [varchar](4) NULL,
	[RCV_NUMBER2] [varchar](4) NULL,
	[RCV_NUMBER3] [varchar](4) NULL,
	[KOR_NAME] [dbo].[KOR_NAME] NULL,
	[CALL_MESSAGE] [nvarchar](100) NULL,
	[CALL_STATUS] [varchar](20) NULL,
	[CALL_DATE] [datetime] NULL,
	[RCV_EMP_CODE] [dbo].[EMP_CODE] NULL,
	[CFM_DATE] [datetime] NULL,
	[CFM_EMP_CODE] [char](7) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FAX_RECEIVE]  WITH CHECK ADD  CONSTRAINT [R_57] FOREIGN KEY([FAX_SEQ])
REFERENCES [dbo].[FAX_MASTER] ([FAX_SEQ])
GO
ALTER TABLE [dbo].[FAX_RECEIVE] CHECK CONSTRAINT [R_57]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_RECEIVE', @level2type=N'COLUMN',@level2name=N'RCV_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_RECEIVE', @level2type=N'COLUMN',@level2name=N'FAX_SEQ'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신번호1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_RECEIVE', @level2type=N'COLUMN',@level2name=N'RCV_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신번호2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_RECEIVE', @level2type=N'COLUMN',@level2name=N'RCV_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신번호3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_RECEIVE', @level2type=N'COLUMN',@level2name=N'RCV_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_RECEIVE', @level2type=N'COLUMN',@level2name=N'KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신메세지' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_RECEIVE', @level2type=N'COLUMN',@level2name=N'CALL_MESSAGE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_RECEIVE', @level2type=N'COLUMN',@level2name=N'CALL_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_RECEIVE', @level2type=N'COLUMN',@level2name=N'CALL_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'팩스수신' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FAX_RECEIVE'
GO
