USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUS_RCV_AGREE](
	[RCV_NO] [int] IDENTITY(1,1) NOT NULL,
	[CUS_NO] [int] NULL,
	[CUS_ID] [varchar](20) NULL,
	[CUS_NAME] [varchar](20) NULL,
	[BIRTH_DAY] [datetime] NULL,
	[GENDER] [char](1) NULL,
	[EMAIL] [varchar](100) NULL,
	[NOR_TEL1] [varchar](4) NULL,
	[NOR_TEL2] [varchar](4) NULL,
	[NOR_TEL3] [varchar](4) NULL,
	[RCV_EMAIL_YN] [char](1) NULL,
	[RCV_SMS_YN] [char](1) NULL,
	[EMAIL_AGREE_DATE] [datetime] NULL,
	[SMS_AGREE_DATE] [datetime] NULL,
	[EMAIL_INFLOW_TYPE] [varchar](2) NULL,
	[SMS_INFLOW_TYPE] [varchar](2) NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신번호순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'RCV_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객아이디' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'CUS_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'CUS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생년월일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'BIRTH_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성별' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'GENDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핸드폰1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'NOR_TEL1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핸드폰2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'NOR_TEL2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'핸드폰3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'NOR_TEL3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일수신동의여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'RCV_EMAIL_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS수신동의여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'RCV_SMS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일수신동의날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'EMAIL_AGREE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS수신동의날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'SMS_AGREE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'이메일유입구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'EMAIL_INFLOW_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SMS유입구분' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'SMS_INFLOW_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입력날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정날짜' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수신동의여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CUS_RCV_AGREE'
GO
