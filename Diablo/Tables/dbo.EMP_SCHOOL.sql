USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMP_SCHOOL](
	[EMP_CODE] [dbo].[EMP_CODE] NOT NULL,
	[SEQ_NO] [dbo].[SEQ_NO] NOT NULL,
	[JOIN_DATE] [smalldatetime] NULL,
	[OUT_DATE] [smalldatetime] NULL,
	[SCH_NAME] [varchar](20) NULL,
	[MAJOR] [varchar](20) NULL,
	[SCH_TYPE] [char](1) NOT NULL,
	[SCH_STATUS] [char](1) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_EMP_SCHOOL] PRIMARY KEY CLUSTERED 
(
	[EMP_CODE] ASC,
	[SEQ_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EMP_SCHOOL]  WITH CHECK ADD  CONSTRAINT [R_6] FOREIGN KEY([EMP_CODE])
REFERENCES [dbo].[EMP_MASTER_damo] ([EMP_CODE])
GO
ALTER TABLE [dbo].[EMP_SCHOOL] CHECK CONSTRAINT [R_6]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_SCHOOL', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_SCHOOL', @level2type=N'COLUMN',@level2name=N'SEQ_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'입학일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_SCHOOL', @level2type=N'COLUMN',@level2name=N'JOIN_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'졸업일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_SCHOOL', @level2type=N'COLUMN',@level2name=N'OUT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'학교명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_SCHOOL', @level2type=N'COLUMN',@level2name=N'SCH_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'전공' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_SCHOOL', @level2type=N'COLUMN',@level2name=N'MAJOR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:고등학교 2:대학2년 3:대학3년 4:대학교(4년) 5:대학원(석사) 6:대학원(박사)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_SCHOOL', @level2type=N'COLUMN',@level2name=N'SCH_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:졸업 2:편입 3:재학 4:자퇴 5:퇴학' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_SCHOOL', @level2type=N'COLUMN',@level2name=N'SCH_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_SCHOOL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_SCHOOL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_SCHOOL', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_SCHOOL', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원학력' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_SCHOOL'
GO
