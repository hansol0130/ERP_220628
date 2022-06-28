USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PPT_DETAIL](
	[RES_CODE] [char](12) NOT NULL,
	[PPT_NO] [int] NOT NULL,
	[FILE_NO] [int] NOT NULL,
	[FILENAME] [varchar](100) NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[RCV_DATE] [datetime] NULL,
	[RCV_CODE] [char](7) NULL,
	[INFLOW_TYPE] [int] NULL,
 CONSTRAINT [PK_PPT_DETAIL] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC,
	[PPT_NO] ASC,
	[FILE_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PPT_DETAIL]  WITH CHECK ADD  CONSTRAINT [FK__PPT_DETAIL__148A9839] FOREIGN KEY([RES_CODE], [PPT_NO])
REFERENCES [dbo].[PPT_MASTER] ([RES_CODE], [PPT_NO])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PPT_DETAIL] CHECK CONSTRAINT [FK__PPT_DETAIL__148A9839]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_DETAIL', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권수신번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_DETAIL', @level2type=N'COLUMN',@level2name=N'PPT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_DETAIL', @level2type=N'COLUMN',@level2name=N'FILE_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'파일명' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_DETAIL', @level2type=N'COLUMN',@level2name=N'FILENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_DETAIL', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_DETAIL', @level2type=N'COLUMN',@level2name=N'RCV_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_DETAIL', @level2type=N'COLUMN',@level2name=N'RCV_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'유입처타입' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_DETAIL', @level2type=N'COLUMN',@level2name=N'INFLOW_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권정보등록화일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_DETAIL'
GO
