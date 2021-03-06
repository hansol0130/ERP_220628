USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMP_MASTER_damo](
	[EMP_CODE] [dbo].[EMP_CODE] NOT NULL,
	[KOR_NAME] [dbo].[KOR_NAME] NOT NULL,
	[ENG_FIRST_NAME] [dbo].[ENG_FIRST_NAME] NULL,
	[ENG_LAST_NAME] [dbo].[ENG_LAST_NAME] NULL,
	[SOC_NUMBER1] [char](6) NULL,
	[GENDER] [char](1) NOT NULL,
	[PASSWORD] [varchar](100) NULL,
	[TEAM_CODE] [dbo].[TEAM_CODE] NOT NULL,
	[GROUP_CODE] [dbo].[GROUP_CODE] NULL,
	[WORK_TYPE] [int] NULL,
	[DUTY_TYPE] [int] NULL,
	[POS_TYPE] [int] NULL,
	[JOIN_TYPE] [int] NULL,
	[JOIN_DATE] [smalldatetime] NULL,
	[OUT_DATE] [smalldatetime] NULL,
	[EMAIL] [varchar](30) NULL,
	[EMAIL_PASSWORD] [varchar](30) NULL,
	[MESSENGER] [varchar](30) NULL,
	[INNER_NUMBER1] [varchar](4) NULL,
	[INNER_NUMBER2] [varchar](4) NULL,
	[INNER_NUMBER3] [varchar](4) NULL,
	[ZIP_CODE] [char](7) NOT NULL,
	[ADDRESS1] [varchar](50) NULL,
	[ADDRESS2] [varchar](80) NULL,
	[TEL_NUMBER1] [varchar](4) NULL,
	[TEL_NUMBER2] [varchar](4) NULL,
	[TEL_NUMBER3] [varchar](4) NULL,
	[HP_NUMBER1] [varchar](4) NULL,
	[HP_NUMBER2] [varchar](4) NULL,
	[HP_NUMBER3] [varchar](4) NULL,
	[FAX_NUMBER1] [varchar](4) NULL,
	[FAX_NUMBER2] [varchar](4) NULL,
	[FAX_NUMBER3] [varchar](4) NULL,
	[GREETING] [varchar](200) NULL,
	[PASSPORT] [dbo].[PASSPORT] NULL,
	[PASS_EXPIRE_DATE] [dbo].[PASS_EXPIRE_DATE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
	[BIRTH_DATE] [smalldatetime] NULL,
	[SALARY_CLASS] [varchar](3) NULL,
	[MATE_NUMBER] [varchar](4) NULL,
	[GROUP_TYPE] [int] NULL,
	[ACC_OUT_YN] [char](1) NULL,
	[CH_NUM] [int] NULL,
	[RECORD_YN] [char](1) NULL,
	[MY_AREA] [varchar](100) NULL,
	[SIGN_CODE] [varchar](1) NULL,
	[CTI_USE_YN] [char](1) NULL,
	[row_id] [uniqueidentifier] NULL,
	[sec_SOC_NUMBER2] [varbinary](16) NULL,
	[MATE_NUMBER2] [varchar](4) NULL,
	[MAIN_NUMBER1] [varchar](4) NULL,
	[MAIN_NUMBER2] [varchar](4) NULL,
	[MAIN_NUMBER3] [varchar](4) NULL,
	[IN_USE_YN] [varchar](1) NULL,
	[FALE_COUNT] [int] NULL,
	[BLOCK_YN] [char](1) NULL,
 CONSTRAINT [PK_EMP_MASTER] PRIMARY KEY CLUSTERED 
(
	[EMP_CODE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  CONSTRAINT [DEF_EMP_MASTER_GENDER]  DEFAULT ('F') FOR [GENDER]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  CONSTRAINT [DEF_EMP_MASTER_NEW_DATE]  DEFAULT (getdate()) FOR [NEW_DATE]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  DEFAULT ('Y') FOR [ACC_OUT_YN]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  CONSTRAINT [DEF_EMP_MASTER_RECORD_YN]  DEFAULT ('N') FOR [RECORD_YN]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  DEFAULT ('N') FOR [CTI_USE_YN]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  CONSTRAINT [EMP_MASTER_df_rowid]  DEFAULT (newid()) FOR [row_id]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] ADD  DEFAULT ('N') FOR [BLOCK_YN]
GO
ALTER TABLE [dbo].[EMP_MASTER_damo]  WITH CHECK ADD  CONSTRAINT [R_4] FOREIGN KEY([TEAM_CODE])
REFERENCES [dbo].[EMP_TEAM] ([TEAM_CODE])
GO
ALTER TABLE [dbo].[EMP_MASTER_damo] CHECK CONSTRAINT [R_4]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'KOR_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ENG_FIRST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ENG_LAST_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'SOC_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'M : ??????, F : ??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'GENDER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PASSWORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'TEAM_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'GROUP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ( 1 : ??????, 2 : ??????, 3 : ????????????, 4 : ?????????, 5 : ??????)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'WORK_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ( 1 : ??????, 2 : ????????????, 3 : ??????, 4 : ?????????, 5 : ??????, 6 : ??????, 7 : ?????????, 8 : ?????? )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'DUTY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ( 1 : ??????, 2 : ??????, 3 : ??????, 4 : ??????, 5 : ??????, 6 : ??????, 7 : ?????????, 8 : ??????, 9 : ??????, 10 : ??????, 11 : ??????, 98 : ?????????, 99 : ?????? )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'POS_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ( 1 : ??????, 2 : ?????? )' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'JOIN_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'JOIN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'OUT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EMAIL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EMAIL_PASSWORD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MESSENGER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'INNER_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'INNER_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'INNER_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ZIP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ADDRESS1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ADDRESS2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'TEL_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'TEL_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'TEL_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'HP_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'HP_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'HP_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FAX1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'FAX_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FAX2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'FAX_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FAX3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'FAX_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'GREETING'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PASSPORT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'PASS_EXPIRE_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'BIRTH_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'SALARY_CLASS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MATE_NUMBER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????? ( 1 : ??????, 2 : ?????????, 3 : ??????, 4 : ??????, 5 : ??????, 9 : ??????) ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'GROUP_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'ACC_OUT_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CH_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'RECORD_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MY_AREA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'??????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'SIGN_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CTI????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'CTI_USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'row_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????_???????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'sec_SOC_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MATE_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MAIN_NUMBER1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MAIN_NUMBER2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'MAIN_NUMBER3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'IN_USE_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'?????????????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'FALE_COUNT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo', @level2type=N'COLUMN',@level2name=N'BLOCK_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'????????????' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_MASTER_damo'
GO
