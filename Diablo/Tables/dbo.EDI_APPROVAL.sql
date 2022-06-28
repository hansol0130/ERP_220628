USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDI_APPROVAL](
	[EDI_CODE] [dbo].[EDI_CODE] NOT NULL,
	[SEQ_NO] [dbo].[SEQ_NO] NOT NULL,
	[APP_STATUS] [char](1) NULL,
	[APP_TYPE] [char](1) NULL,
	[APP_CODE] [dbo].[EMP_CODE] NOT NULL,
	[APP_NAME] [dbo].[KOR_NAME] NULL,
	[TEAM_NAME] [varchar](50) NULL,
	[DUTY_NAME] [dbo].[DUTY_NAME] NULL,
	[POS_NAME] [dbo].[POS_NAME] NULL,
	[APP_DATE] [datetime] NULL,
	[READ_YN] [char](1) NOT NULL,
	[VIEW_YN] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_TEAM_NAME] [varchar](50) NULL,
	[NEW_DUTY_NAME] [dbo].[DUTY_NAME] NULL,
	[NEW_POS_NAME] [dbo].[POS_NAME] NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
 CONSTRAINT [PK_EDI_APPROVER] PRIMARY KEY CLUSTERED 
(
	[EDI_CODE] ASC,
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EDI_APPROVAL] ADD  CONSTRAINT [DF_EDI_APPROVAL_READ_YN]  DEFAULT ('N') FOR [READ_YN]
GO
ALTER TABLE [dbo].[EDI_APPROVAL]  WITH CHECK ADD  CONSTRAINT [R_21] FOREIGN KEY([EDI_CODE])
REFERENCES [dbo].[EDI_MASTER_damo] ([EDI_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EDI_APPROVAL] CHECK CONSTRAINT [R_21]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'문서코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'EDI_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결재상태' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'APP_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 일반, 2 : 회계 ( 일반 : 1, 회계 : 2, 관리 : 3 , CS : 4 )  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'APP_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결재자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'APP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결재자명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'APP_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결재자팀명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결재자직책명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'DUTY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결재자직급명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'POS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결재일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'APP_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'읽음여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'READ_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'보기유무' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'VIEW_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자팀명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'NEW_TEAM_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자직책명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'NEW_DUTY_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자직급명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'NEW_POS_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'결재자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDI_APPROVAL'
GO
