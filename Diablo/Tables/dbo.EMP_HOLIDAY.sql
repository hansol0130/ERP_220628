USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMP_HOLIDAY](
	[EMP_CODE] [dbo].[EMP_CODE] NOT NULL,
	[APPLY_YEAR] [char](4) NOT NULL,
	[HOLIDAY_TYPE] [char](1) NOT NULL,
	[CAN_DAY] [numeric](18, 1) NULL,
	[REMARK] [varchar](200) NULL,
	[NEW_CODE] [dbo].[NEW_CODE] NOT NULL,
	[NEW_DATE] [dbo].[NEW_DATE] NULL,
	[EDT_CODE] [dbo].[EDT_CODE] NULL,
	[EDT_DATE] [dbo].[EDT_DATE] NULL,
 CONSTRAINT [PK_EMP_HOLIDAY] PRIMARY KEY CLUSTERED 
(
	[EMP_CODE] ASC,
	[APPLY_YEAR] ASC,
	[HOLIDAY_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EMP_HOLIDAY]  WITH NOCHECK ADD  CONSTRAINT [R_9] FOREIGN KEY([EMP_CODE])
REFERENCES [dbo].[EMP_MASTER_damo] ([EMP_CODE])
GO
ALTER TABLE [dbo].[EMP_HOLIDAY] CHECK CONSTRAINT [R_9]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'사원코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY', @level2type=N'COLUMN',@level2name=N'EMP_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'적용연도' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY', @level2type=N'COLUMN',@level2name=N'APPLY_YEAR'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 휴가, 2 : 출장' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY', @level2type=N'COLUMN',@level2name=N'HOLIDAY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'가능일수' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY', @level2type=N'COLUMN',@level2name=N'CAN_DAY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'비고' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY', @level2type=N'COLUMN',@level2name=N'REMARK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY', @level2type=N'COLUMN',@level2name=N'EDT_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'수정일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY', @level2type=N'COLUMN',@level2name=N'EDT_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'출장휴가관리' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMP_HOLIDAY'
GO
