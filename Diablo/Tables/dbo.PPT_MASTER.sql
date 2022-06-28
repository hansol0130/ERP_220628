USE [Diablo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PPT_MASTER](
	[RES_CODE] [char](12) NOT NULL,
	[PPT_NO] [int] NOT NULL,
	[CUS_IDENTIFY] [varchar](max) NULL,
	[PASS_STATUS] [int] NULL,
	[CUS_NO] [int] NULL,
	[CUS_YN] [char](1) NULL,
	[RCV_DATE] [datetime] NULL,
	[RCV_CODE] [char](7) NULL,
	[NEW_CODE] [char](7) NOT NULL,
	[NEW_DATE] [datetime] NULL,
	[RES_NO] [int] NULL,
 CONSTRAINT [PK_PPT_MASTER] PRIMARY KEY CLUSTERED 
(
	[RES_CODE] ASC,
	[PPT_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PPT_MASTER]  WITH CHECK ADD FOREIGN KEY([RES_CODE])
REFERENCES [dbo].[RES_MASTER_damo] ([RES_CODE])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'예약코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER', @level2type=N'COLUMN',@level2name=N'RES_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권수신번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER', @level2type=N'COLUMN',@level2name=N'PPT_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객인증정보' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER', @level2type=N'COLUMN',@level2name=N'CUS_IDENTIFY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 : 사진, 2 : APIS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER', @level2type=N'COLUMN',@level2name=N'PASS_STATUS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객고유번호' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER', @level2type=N'COLUMN',@level2name=N'CUS_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'고객정보입력동의여부' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER', @level2type=N'COLUMN',@level2name=N'CUS_YN'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER', @level2type=N'COLUMN',@level2name=N'RCV_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'처리자' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER', @level2type=N'COLUMN',@level2name=N'RCV_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성자코드' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_CODE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'작성일' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER', @level2type=N'COLUMN',@level2name=N'NEW_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여행자순번' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER', @level2type=N'COLUMN',@level2name=N'RES_NO'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'여권정보 마스터' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPT_MASTER'
GO
