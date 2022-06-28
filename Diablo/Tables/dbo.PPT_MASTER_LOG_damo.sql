USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PPT_MASTER_LOG_damo](
	[RES_CODE] [dbo].[RES_CODE] NOT NULL,
	[PPT_NO] [dbo].[SEQ_NO] NOT NULL,
	[LAST_NAME] [varchar](20) NULL,
	[FIRST_NAME] [varchar](20) NULL,
	[GENDER] [char](1) NULL,
	[BIRTH_DATE] [datetime] NULL,
	[PASS_ISSUE] [datetime] NULL,
	[PASS_EXPIRE] [datetime] NULL,
	[row_id] [uniqueidentifier] NULL,
	[sec_PASS_NUM] [varbinary](32) NULL,
	[KOR_NAME] [varchar](20) NULL,
 CONSTRAINT [PK_PPT_MASTER_LOG] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC,
	[PPT_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PPT_MASTER_LOG_damo] ADD  CONSTRAINT [DEF_PPT_MASTER_LOG_PPT_NO]  DEFAULT ((0)) FOR [PPT_NO]
GO
ALTER TABLE [dbo].[PPT_MASTER_LOG_damo] ADD  CONSTRAINT [PPT_MASTER_LOG_df_rowid]  DEFAULT (newid()) FOR [row_id]
GO
ALTER TABLE [dbo].[PPT_MASTER_LOG_damo]  WITH CHECK ADD  CONSTRAINT [R_553] FOREIGN KEY([RES_CODE], [PPT_NO])
REFERENCES [dbo].[PPT_MASTER] ([RES_CODE], [PPT_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PPT_MASTER_LOG_damo] CHECK CONSTRAINT [R_553]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER_LOG_damo', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권수신번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER_LOG_damo', @level2type=N'COLUMN',@level2name=N'PPT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문성' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER_LOG_damo', @level2type=N'COLUMN',@level2name=N'LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'영문이름' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER_LOG_damo', @level2type=N'COLUMN',@level2name=N'FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'성별' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER_LOG_damo', @level2type=N'COLUMN',@level2name=N'GENDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'생년월일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER_LOG_damo', @level2type=N'COLUMN',@level2name=N'BIRTH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'발급일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER_LOG_damo', @level2type=N'COLUMN',@level2name=N'PASS_ISSUE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'만료일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER_LOG_damo', @level2type=N'COLUMN',@level2name=N'PASS_EXPIRE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'줄번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER_LOG_damo', @level2type=N'COLUMN',@level2name=N'row_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권번호_암호화필드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER_LOG_damo', @level2type=N'COLUMN',@level2name=N'sec_PASS_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권정보로그' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER_LOG_damo'
GO
