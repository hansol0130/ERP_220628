USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DSR_ACDM](
	[TICKET] [varchar](10) NOT NULL,
	[PROCESS_NUM] [varchar](20) NULL,
	[PRICE] [int] NULL,
	[ACM_YN] [char](1) NOT NULL,
	[PROCESS_DATE] [datetime] NULL,
	[BSP_DAY] [varchar](10) NULL,
	[EMP_CODE] [dbo].[EMP_CODE] NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[REMARK] [varchar](1000) NULL,
 CONSTRAINT [XPKACM_ADM] PRIMARY KEY CLUSTERED 
(
	[TICKET] ASC,
	[ACM_YN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DSR_ACDM]  WITH CHECK ADD  CONSTRAINT [R_305] FOREIGN KEY([TICKET])
REFERENCES [dbo].[DSR_TICKET] ([TICKET])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DSR_ACDM] CHECK CONSTRAINT [R_305]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_ACDM', @level2type=N'COLUMN',@level2name=N'TICKET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_ACDM', @level2type=N'COLUMN',@level2name=N'PROCESS_NUM'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'금액' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_ACDM', @level2type=N'COLUMN',@level2name=N'PRICE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ACM 여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_ACDM', @level2type=N'COLUMN',@level2name=N'ACM_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_ACDM', @level2type=N'COLUMN',@level2name=N'PROCESS_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'BSP 반영주기' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_ACDM', @level2type=N'COLUMN',@level2name=N'BSP_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리자 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_ACDM', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'담당자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_ACDM', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_ACDM', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사유' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_ACDM', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ACM/ADM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_ACDM'
GO
