USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DSR_VOID](
	[TICKET] [varchar](10) NOT NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[VOID_REMARK] [varchar](200) NULL,
	[PROCESS_DATE] [datetime] NULL,
	[EMP_CODE] [dbo].[EMP_CODE] NULL,
 CONSTRAINT [XPKVOID] PRIMARY KEY CLUSTERED 
(
	[TICKET] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DSR_VOID]  WITH CHECK ADD  CONSTRAINT [R_307] FOREIGN KEY([TICKET])
REFERENCES [dbo].[DSR_TICKET] ([TICKET])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DSR_VOID] CHECK CONSTRAINT [R_307]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'티켓번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_VOID', @level2type=N'COLUMN',@level2name=N'TICKET'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_VOID', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_VOID', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VOID 사유' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_VOID', @level2type=N'COLUMN',@level2name=N'VOID_REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리일자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_VOID', @level2type=N'COLUMN',@level2name=N'PROCESS_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리자 코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_VOID', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'VOID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DSR_VOID'
GO
